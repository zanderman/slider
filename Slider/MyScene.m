//
//  MyScene.m
//  Slider
//
//  Created by Grant Spence on 4/18/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import "MyScene.h"
//#import "ViewController.h"
#include <QuartzCore/QuartzCore.h>
#include <stdlib.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MyScene ()
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic, retain) UIViewController *contentViewController;
@property (nonatomic,strong) ViewController *viewController;
@property NSInteger blocksX;
@property NSInteger blocksY;
@property NSMutableArray *blocks;
@end

@implementation MyScene
NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;
NSTimeInterval _lastMissileAdded;

static const uint32_t beeCategory     =  0x1 << 0;
static const uint32_t honeyCombCategory    =  0x1 << 1;
static const uint32_t rainCategory    =  0x1 << 2;
static const uint32_t wallCategory    =  0x1 << 3;
static const uint32_t flowerCategory    =  0x1 << 4;

SKLabelNode *pointsLabel;
SKLabelNode *levelLabel;
SKSpriteNode *honey1;
SKSpriteNode *honey2;
SKSpriteNode *honey3;
int life = 3;
int points = 0;

bool activeGame = true;

// Variables for drop timing
int dropDelay = 40;
int dropIndex = 0;

int waterDropsFallen = 0;
int level = 1;
bool isEnd = false;

static const float BG_VELOCITY = 100.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        NSLog(@"alskjdhflksajdhgflksdh");
    }
}
-(id)initWithSize:(CGSize)size {
    self.physicsWorld.contactDelegate = self;
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _viewController = [[ViewController alloc] init];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self initalizingScrollingBackground];
        
        
        float height = self.frame.size.height;
        float width =  self.frame.size.width;
        
        NSLog(@"Height of screen: %f", height);
        NSLog(@"Width of screen : %f", width);
        
        float gameHeight = height - 60;
        
        // Set up physics for the scene
        self.physicsWorld.gravity = CGVectorMake(0,-0.3f);
        self.physicsWorld.contactDelegate = self;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, width, gameHeight)];
        self.physicsBody.friction = 10.0f;
        self.physicsBody.collisionBitMask = beeCategory;
        self.physicsBody.contactTestBitMask = beeCategory;
        self.physicsBody.categoryBitMask = wallCategory;
        
        _blocks = [[NSMutableArray alloc] init];
        
        [self buildLevel1];
        [self createCharacter];
        
        pointsLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"] ;
        pointsLabel.position = CGPointMake(45, self.frame.size.height-40);
        pointsLabel.fontSize = 16;
        pointsLabel.fontColor = [SKColor blackColor];
        NSString *string = [NSString stringWithFormat:@"Points: %d",points];
        pointsLabel.text = string;
        [self addChild:pointsLabel];
        

        levelLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"] ;
        levelLabel.position = CGPointMake(self.frame.size.width - 45, self.frame.size.height-40);
        levelLabel.fontSize = 16;
        levelLabel.fontColor = [SKColor blackColor];
        levelLabel.text = @"Level 1 ";
        [self addChild:levelLabel];
        
        
        // Add the Honey Combs!
        honey1 = [[SKSpriteNode alloc] initWithImageNamed: @"honey2.png"];
        [honey1 setPosition:CGPointMake(CGRectGetMidX(self.frame)+35, self.frame.size.height-34)];
        [honey1 setSize:CGSizeMake(30, 30)];
        [self addChild:honey1];
        
        honey2 = [[SKSpriteNode alloc] initWithImageNamed: @"honey2.png"];
        [honey2 setPosition:CGPointMake(CGRectGetMidX(self.frame)+5, self.frame.size.height-34)];
        [honey2 setSize:CGSizeMake(30, 30)];
        [self addChild:honey2];
        
        honey3 = [[SKSpriteNode alloc] initWithImageNamed: @"honey2.png"];
        [honey3 setPosition:CGPointMake(CGRectGetMidX(self.frame)-25, self.frame.size.height-34)];
        [honey3 setSize:CGSizeMake(30, 30)];
        [self addChild:honey3];
        
        
    }
    return self;
}
-(SKSpriteNode*)buildIceBlock
{
    CGSize blockSize = CGSizeMake(20, 30);
    
    SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"raindrop.png"];
    [iceBlock setSize:blockSize];
    [self addChild:iceBlock];
    iceBlock.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:iceBlock.frame.size.width-10];
    
    iceBlock.physicsBody.restitution = 0.0f;
    iceBlock.physicsBody.friction = 10.0f;
    // make physicsBody static
    iceBlock.physicsBody.dynamic = NO;
    iceBlock.physicsBody.categoryBitMask = rainCategory;
    iceBlock.physicsBody.collisionBitMask = rainCategory | beeCategory;
    iceBlock.physicsBody.contactTestBitMask = rainCategory;
    return iceBlock;
}

-(SKSpriteNode*)buildHoneyComb
{
    CGSize blockSize = CGSizeMake(30, 30);
    
    SKSpriteNode* honeyComb = [[SKSpriteNode alloc] initWithImageNamed: @"honey2.png"];
    [honeyComb setSize:blockSize];
    [self addChild:honeyComb];
    honeyComb.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:honeyComb.frame.size.width-10];
    
    honeyComb.physicsBody.restitution = 0.0f;
    honeyComb.physicsBody.friction = 10.0f;
    
    // make physicsBody static
    honeyComb.physicsBody.dynamic = NO;
    
    honeyComb.physicsBody.categoryBitMask  = honeyCombCategory;
    honeyComb.physicsBody.collisionBitMask = honeyCombCategory | beeCategory;
    honeyComb.physicsBody.contactTestBitMask = honeyCombCategory | beeCategory;
    return honeyComb;
}

-(SKSpriteNode*)buildFlower
{
    CGSize blockSize = CGSizeMake(30, 30);
    
    SKSpriteNode* flower = [[SKSpriteNode alloc] initWithImageNamed: @"flower.png"];
    [flower setSize:blockSize];
    [self addChild:flower];
    flower.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:flower.frame.size.width-10];
    
    flower.physicsBody.restitution = 0.0f;
    flower.physicsBody.friction = 10.0f;
    
    // make physicsBody static
    flower.physicsBody.dynamic = NO;
    
    flower.physicsBody.categoryBitMask  = flowerCategory;
    flower.physicsBody.collisionBitMask = flowerCategory | beeCategory;
    flower.physicsBody.contactTestBitMask = flowerCategory | beeCategory;
    return flower;
}

-(void)buildLevel1
{
    
    //[self buildIceBlock].position = CGPointMake(CGRectGetMidX(self.frame)-20,10);
    //[self buildIceBlock].position = CGPointMake(CGRectGetMidX(self.frame)+20,10);
    
//    for (int i=0; i<10; i++) {
//        SKSpriteNode *node = [self buildIceBlock];
//        int r = (arc4random() % (NSInteger)self.frame.size.width/20);
//        r *= 20;
//        node.position = CGPointMake(r, arc4random() % (NSInteger)self.frame.size.height);
//        [_blocks insertObject:node atIndex:i];
//    }
//    
//    for (int i=0; i<10; i++) {
//        SKSpriteNode *node = [self buildIceBlock];
//        node.position = CGPointMake(190, i*20+150);
//        [_blocks insertObject:node atIndex:i+10];
//    }
    
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg.jpg"];
        bg1.position = CGPointMake(0, i * bg1.size.height);
        bg1.anchorPoint = CGPointZero;
        bg1.name = @"bg";
        [self addChild:bg1];
    }
    
}

- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(0, -BG_VELOCITY);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
         if (bg.position.y <= -bg.size.height)
         {
             bg.position = CGPointMake(bg.position.x,
                                       bg.position.y + bg.size.height*2);
         }
     }];
}

-(void)createCharacter
{
    
    // Character in the game.
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"bee_new.png"];
    self.player.position = CGPointMake(CGRectGetMidX(self.frame), 200);

    self.player.physicsBody.restitution = 0.1f;
    self.player.physicsBody.friction = 0.4f;
    [self.player setSize:CGSizeMake(30, 30)];
    //self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.frame.size];
    [self addChild:self.player];
    
    // Physics for penguin.
    self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.frame.size.width/2];
//    self.player.physicsBody.restitution = 0.1f;
//    self.player.physicsBody.friction = 0.4f;
    self.player.physicsBody.dynamic = YES;
    
    self.player.physicsBody.categoryBitMask = beeCategory;
    self.player.physicsBody.collisionBitMask = rainCategory;
    self.player.physicsBody.contactTestBitMask = rainCategory | beeCategory;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // Set the physics bodys collision
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // Contact with a raindrop
    if ( (secondBody.categoryBitMask & rainCategory )!= 0) {
        NSLog(@"Rain");
        [self.player removeAllActions];
        
        SKAction *pulseRed = [SKAction sequence:@[
//        [SKAction rotateByAngle:1.0f duration:0.3],
          [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
          [SKAction waitForDuration:0.1],
          [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15],
          ]];
        
        [self.player runAction: pulseRed];
        life--;
        // Remove a honeycomb
        if ( life == 2 ) {
            honey3.hidden = YES;
        }
        else if ( life == 1) {
            honey2.hidden = YES;
        }
        else if ( life == 0) {
            honey1.hidden = YES;
            NSString *scoreString = [NSString stringWithFormat:@"Score: %d", points];
            [_viewController showResultScreen:scoreString:@"YOU LOSE!"];
            activeGame = false;
            isEnd = true;
//            [self resetGame];
        }
        
        NSLog(@"Contact, Life: %d",life);
    }
    // Contact with a honeycomb
    else if ( (secondBody.categoryBitMask & honeyCombCategory )!= 0) {
        NSLog(@"Honey");
        SKSpriteNode *comb = secondBody.node;
        SKAction *pulseGreen = [SKAction sequence:@[
              [SKAction colorizeWithColor:[SKColor greenColor] colorBlendFactor:1.0 duration:0.15],
              [SKAction waitForDuration:0.1],
              [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
        [self.player runAction: pulseGreen];
        
        life++;
        
        // Restore lives
        if ( life == 1 ) {
            honey1.hidden = NO;
        }
        else if ( life == 2) {
            honey2.hidden = NO;
        }
        else if ( life == 3) {
            honey3.hidden = NO;
        }
        
        // Make it disappear
        [comb removeFromParent];
        [_blocks removeObject:comb];
    }
    // Contact with a honeycomb
    else if ( (secondBody.categoryBitMask & flowerCategory )!= 0) {
        NSLog(@"Flower");
        SKSpriteNode *flower = secondBody.node;
        
        points += 100;
        
        NSString *string = [NSString stringWithFormat:@"Points: %d",points];
        pointsLabel.text = string;
        
        // Make it disappear
        [flower removeFromParent];
        [_blocks removeObject:flower];
    }



}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"HERE");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        // Move penguin.
        CGPoint location = [touch locationInNode:self];
        SKAction *action = [SKAction moveTo:location duration:0.3f];
        [self.player runAction:action];
    }
}

// Touch event.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
    if(isEnd) {
        [_viewController removeResultScreen];
        [self resetGame];
    }
    else {
    for (UITouch *touch in touches) {
        // Move penguin.
        CGPoint location = [touch locationInNode:self];
        SKAction *action = [SKAction moveTo:location duration:0.5f];
        [self.player runAction:action];
    }
        
        // Alert popup.
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles: nil];
//        [alert show];
    
    // Load an image.
//    UIImageView *aView = [[UIImageView alloc] init];
//    aView.frame = self.view.frame;
//    aView.opaque = YES;
//    [aView setFrame:CGRectMake(200, 200, 250, 250)];
//    aView.layer.shadowRadius = 10;
//        aView.alpha = 0.33;
//        [aView setFrame:CGRectMake(100, 100, 150, 150)];
//        [aView setBackgroundColor:[UIImage imageNamed:@"Spaceship.png"]];
//        aView.layer.cornerRadius = 0.5;
//        aView.layer.borderColor = [UIColor redColor].CGColor;
//        aView.layer.borderWidth = 0.5f;
//        [self.view addSubview:aView];
    
    }
}

-(void)resetGame
{
//    [_viewController removeResultScreen];
    // Iterate through blocks
    for (SKSpriteNode *obj in _blocks) {
        if ( [obj isKindOfClass:[SKSpriteNode class]]) {
            obj.removeFromParent;
        }
    }
    
    // Reset variables
    points = 0;
    level = 1;
    dropDelay = 40;
    life = 3;
    dropIndex = 0;
    waterDropsFallen = 0;
    isEnd = false;
    
    // Reset Labels
    NSString *string = [NSString stringWithFormat:@"Points: %d",points];
    pointsLabel.text = string;
    NSString *string2 = [NSString stringWithFormat:@"Level: %d",level];
    levelLabel.text = string2;
    
    [_blocks removeAllObjects];
    self.player.position = CGPointMake(CGRectGetMidX(self.frame), 200);
    [_viewController removeResultScreen];
    [self.player removeAllActions];
    activeGame = true;
}

// Handle swipe gesture.
-(void)moveCharacter:(UISwipeGestureRecognizer *)recognizer {
    //    SKSpriteNode *temp = self.player;
    
    // Right
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe right.");
        //        CGPoint location = CGPointMake(100, 100);
        //        SKAction *action = [SKAction moveTo:location duration:1];
        SKAction *action = [SKAction moveToX:250 duration:1];
        [self.player runAction:action];
    }
    
    // Left
    if ((recognizer.direction == UISwipeGestureRecognizerDirectionLeft)) {
        NSLog(@"Swipe left.");
    }
    
    // Up
    if ((recognizer.direction == UISwipeGestureRecognizerDirectionUp)) {
        NSLog(@"Swipe up.");
    }
    
    // Down
    if ((recognizer.direction == UISwipeGestureRecognizerDirectionDown)) {
        NSLog(@"Swipe down.");
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    if (_lastUpdateTime && activeGame)
    {
        if ( _player.position.y <= 0 ) {
            NSString *scoreString = [NSString stringWithFormat:@"Score: %d", points];
            [_viewController showResultScreen:scoreString:@" You Lose!"];
            activeGame = false;
            isEnd = true;
//            [self resetGame];
        }
        
        _dt = currentTime - _lastUpdateTime;
        NSMutableArray *discardedItems = [NSMutableArray array];
        NSMutableArray *insertedItems = [NSMutableArray array];
        
        // Iterate through blocks
        for (SKSpriteNode *obj in _blocks) {
            if ( [obj isKindOfClass:[SKSpriteNode class]]) {
                obj.position = CGPointMake(obj.position.x, obj.position.y-1);
                
                // When a block has gone offscreen
                if (obj.position.y <= 0 && (obj.physicsBody.categoryBitMask & rainCategory) != 0 ) {
                    [discardedItems addObject:obj]; // Add to discarding array
                    obj.removeFromParent;
                    
                    // Every 10 water drops
                    waterDropsFallen++;
                    if ( waterDropsFallen % 10 == 0 ) {
                        // Get faster
                        if ( dropDelay >=0 )
                            dropDelay -= 5;
                        
                        level++;
                        NSString *string = [NSString stringWithFormat:@"Level: %d",level];
                        levelLabel.text = string;
                        
                    }
                    points++; // 1 More point
                    NSString *string = [NSString stringWithFormat:@"Points: %d",points];
                    pointsLabel.text = string;
                }
            }
        }
        
        if ( dropIndex >= dropDelay) {
            // Generate new iceblocks
	        for (int i=0; i<1; i++) {
	            int typeOfBlock = (arc4random() % 100);
	            SKSpriteNode *node;
	            if ( typeOfBlock < 10   ) {
                    if ( typeOfBlock < 5 ) {
                        node = [self buildFlower];
                    } else {
                        node = [self buildHoneyComb];
                    }
	            } else {
	                
	                // New icebock in a random spot, but at the top
	                node = [self buildIceBlock];
	            }
	            int r = (arc4random() % (NSInteger)self.frame.size.width/20);
	            r *= 20;
	            node.position = CGPointMake(r, self.frame.size.height);
	            
	            // Insert into inserting array
	            [insertedItems insertObject:node atIndex:i];
	        }
            dropIndex = 0;
        }
        dropIndex++;
        
        // Remove and insert
        [_blocks removeObjectsInArray:discardedItems];
        [_blocks addObjectsFromArray:insertedItems];
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
//
//    if( currentTime - _lastMissileAdded > 1)
//    {
//        _lastMissileAdded = currentTime + 1;
//    }
    
    
    [self moveBg];
}

@end

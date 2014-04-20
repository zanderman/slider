//
//  MyScene.m
//  Slider
//
//  Created by Grant Spence on 4/18/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import "MyScene.h"
#import "TitleViewController.h"
#include <stdlib.h>

@interface MyScene ()
@property (nonatomic) SKSpriteNode * player;
@property NSInteger blocksX;
@property NSInteger blocksY;
@property NSMutableArray *blocks;
@end

@implementation MyScene
NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;
NSTimeInterval _lastMissileAdded;

static const uint32_t penguinCategory     =  0x1 << 0;
SKLabelNode *pointsLabel;
SKLabelNode *levelLabel;
SKSpriteNode *honey1;
SKSpriteNode *honey2;
SKSpriteNode *honey3;
int life = 3;
int points = 0;

// Variables for drop timing
int dropDelay = 40;
int dropIndex = 0;

static const float BG_VELOCITY = 100.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

-(id)initWithSize:(CGSize)size {
    self.physicsWorld.contactDelegate = self;
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self initalizingScrollingBackground];
        
        
        float height = self.frame.size.height;
        float width =  self.frame.size.width;
        
        NSLog(@"Height of screen: %f", height);
        NSLog(@"Width of screen : %f", width);
        
        float gameHeight = height - 60;
        
        // Set up physics for the scene
        self.physicsWorld.gravity = CGVectorMake(0,-1);
        self.physicsWorld.contactDelegate = self;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, width, gameHeight)];
        self.physicsBody.friction = 10.0f;
        
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
    return iceBlock;
}

-(SKSpriteNode*)buildHoneyComb
{
    CGSize blockSize = CGSizeMake(30, 30);
    
    SKSpriteNode* honeyComb = [[SKSpriteNode alloc] initWithImageNamed: @"honey2.png"];
    [honeyComb setSize:blockSize];
    [self addChild:honeyComb];
 //   honeyComb.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:honeyComb.frame.size.width-10];
//    
//    honeyComb.physicsBody.restitution = 0.0f;
//    honeyComb.physicsBody.friction = 10.0f;
//    // make physicsBody static
//    honeyComb.physicsBody.dynamic = NO;
    return honeyComb;
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
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"bee.png"];
    self.player.position = CGPointMake(CGRectGetMidX(self.frame), 50);

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
    
    self.player.physicsBody.categoryBitMask = penguinCategory;
    self.player.physicsBody.collisionBitMask = penguinCategory;
    self.player.physicsBody.contactTestBitMask = penguinCategory;

}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
    [self.player removeAllActions];
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
    }
    NSLog(@"Contact, Life: %d",life);
}

// Touch event.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
    for (UITouch *touch in touches) {
        // Move penguin.
        CGPoint location = [touch locationInNode:self];
        SKAction *action = [SKAction moveTo:location duration:0.5f];
        
        [self.player runAction:action]; // run the action created above.
//        NSLog(self.maxAccX.text);
    }
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
    if (_lastUpdateTime)
    {
        if ( _player.position.y <= 0 ) {
            
        }
        
        _dt = currentTime - _lastUpdateTime;
        NSMutableArray *discardedItems = [NSMutableArray array];
        NSMutableArray *insertedItems = [NSMutableArray array];
        
        // Iterate through blocks
        for (SKSpriteNode *obj in _blocks) {
            if ( [obj isKindOfClass:[SKSpriteNode class]]) {
                obj.position = CGPointMake(obj.position.x, obj.position.y-1);
                
                // When a block has gone offscreen
                if (obj.position.y <= 0) {
                    [discardedItems addObject:obj]; // Add to discarding array
                    obj.removeFromParent;
                    
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
	            if ( typeOfBlock < 10 ) {
	                node = [self buildHoneyComb];
	                
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

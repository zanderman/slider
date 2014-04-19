//
//  MyScene.m
//  Slider
//
//  Created by Grant Spence on 4/18/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import "MyScene.h"
#import "TitleViewController.h"

@interface MyScene ()
@property (nonatomic) SKSpriteNode * player;
@property NSInteger blocksX;
@property NSInteger blocksY;

@end

@implementation MyScene

ViewController *parentView;

static const uint32_t penguinCategory     =  0x1 << 0;

int globalPoints;

-(id)initWithSize:(CGSize)size {
    self.physicsWorld.contactDelegate = self;
    globalPoints = 0;
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
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
        
        [self buildLevel1];
        [self createCharacter];

    }
    return self;
}
-(SKSpriteNode*)buildIceBlock
{
    CGSize blockSize = CGSizeMake(20, 20);
    
    SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"ice-icon.png"];
    [iceBlock setSize:blockSize];
    [self addChild:iceBlock];
    iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];
    
    iceBlock.physicsBody.restitution = 1.1f;
    iceBlock.physicsBody.friction = 1.0f;
    // make physicsBody static
    iceBlock.physicsBody.dynamic = NO;
    return iceBlock;
}
-(void)buildLevel1
{
    CGSize blockSize = CGSizeMake(20, 20);
    
    [self buildIceBlock].position = CGPointMake(CGRectGetMidX(self.frame)-20,10);
    [self buildIceBlock].position = CGPointMake(CGRectGetMidX(self.frame)+20,10);
    
    for (int i=0; i<10; i++) {
        [self buildIceBlock].position = CGPointMake(i*20+blockSize.width/2, 150);
    }
    
    for (int i=0; i<10; i++) {
        [self buildIceBlock].position = CGPointMake(190, i*20+150);
    }
    
}

-(void)createCharacter
{
    
    // Character in the game.
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    self.player.position = CGPointMake(CGRectGetMidX(self.frame), 50);

    self.player.physicsBody.restitution = 0.1f;
    self.player.physicsBody.friction = 0.4f;
    [self.player setSize:CGSizeMake(19, 19)];
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.frame.size];
    [self addChild:self.player];
    
    // Physics for penguin.
    //self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.frame.size.width/2];
//    self.player.physicsBody.restitution = 0.1f;
//    self.player.physicsBody.friction = 0.4f;
    self.player.physicsBody.dynamic = YES;
    
    self.player.physicsBody.categoryBitMask = penguinCategory;
    self.player.physicsBody.collisionBitMask = penguinCategory;
    self.player.physicsBody.contactTestBitMask = penguinCategory;

}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    globalPoints++;
    [self.player removeAllActions];
    NSLog(@"Contact");
}

// Touch event.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    for (UITouch *touch in touches) {
//        // Move penguin.
//        CGPoint location = [touch locationInNode:self];
//        SKAction *action = [SKAction moveTo:location duration:1];
//        
//        [self.player runAction:action]; // run the action created above.
////        NSLog(self.maxAccX.text);
//    }
}

// Motion code

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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

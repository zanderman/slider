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

+(void)setMyStaticVar:(ViewController*)newValue
{
    parentView = newValue;
}

-(id)initWithSize:(CGSize)size {    
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

-(void)buildLevel1
{
    CGSize blockSize = CGSizeMake(20, 20);
    
    for (int i=0; i<10; i++) {
        SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"ice-icon.png"];
        iceBlock.position = CGPointMake(i*20+blockSize.width/2, 150);
        [iceBlock setSize:blockSize];
        [self addChild:iceBlock];
        iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];
        
        iceBlock.physicsBody.restitution = 1.1f;
        iceBlock.physicsBody.friction = 1.0f;
        // make physicsBody static
        iceBlock.physicsBody.dynamic = NO;
    }
    
    for (int i=0; i<10; i++) {
        SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"ice-icon.png"];
        iceBlock.position = CGPointMake(190, i*20+150);
        [iceBlock setSize:blockSize];
        [self addChild:iceBlock];
        iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];
        iceBlock.physicsBody.restitution = 1.1f;
        iceBlock.physicsBody.friction = 1.0f;
        // make physicsBody static
        iceBlock.physicsBody.dynamic = NO;
    }
    
}

-(void)createCharacter
{
    // Character in the game.
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    self.player.position = CGPointMake(CGRectGetMidX(self.frame), 50);
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.frame.size];
    self.player.physicsBody.restitution = 0.1f;
    self.player.physicsBody.friction = 0.4f;
    [self.player setScale:0.1];
    self.player.physicsBody.categoryBitMask = penguinCategory;
    //  self.player.physicsBody.collisionBitMask = penguinCategory;
    self.player.physicsBody.contactTestBitMask = penguinCategory;
    [self addChild:self.player];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    globalPoints++;
    NSLog(@"Contact");
}

// Touch event.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        // Move penguin.
        CGPoint location = [touch locationInNode:self];
        SKAction *action = [SKAction moveTo:location duration:1];
        [self.player runAction:action]; // run the action created above.
//        NSLog(self.maxAccX.text);
    }
}

// Motion code


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

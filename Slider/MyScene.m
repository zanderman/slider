//
//  MyScene.m
//  Slider
//
//  Created by Grant Spence on 4/18/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()
@property (nonatomic) SKSpriteNode * player;
@end

@implementation MyScene

int globalPoints;

-(id)initWithSize:(CGSize)size {
    self.physicsWorld.contactDelegate = self;
    globalPoints = 0;
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        
        // Text at top of the screen.
        myLabel.text = @"Slipy Penguin";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 420);
        //myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
        //                              CGRectGetMidY(self.frame));
        self.physicsWorld.gravity = CGVectorMake(0, 0); // No XY gravity.
        self.physicsWorld.contactDelegate = self;
        
        
        
        [self addChild:myLabel];
        
        // Character in the game.
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.player.position = CGPointMake(CGRectGetMidX(self.frame), 50);
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.frame.size];
        self.player.physicsBody.restitution = 0.1f;
        self.player.physicsBody.friction = 0.4f;
        [self.player setScale:0.1];
        [self addChild:self.player];
        
        // Physics for penguin.
        self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.frame.size.width/2];
        self.player.physicsBody.restitution = 0.1f;
        self.player.physicsBody.friction = 0.4f;
        self.player.physicsBody.dynamic = YES;
        
//        SKSpriteNode* wall1 = [SKSpriteNode alloc];
        for (int i=0; i<10; i++) {
            SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"iceBlock.png"];
            iceBlock.position = CGPointMake(i*20, 150);
            [iceBlock setScale:0.2];
            [self addChild:iceBlock];
            iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:(iceBlock.frame.size)];
            iceBlock.physicsBody.restitution = 0.1f;
            iceBlock.physicsBody.friction = 0.4f;
            // make physicsBody static
            iceBlock.physicsBody.dynamic = NO;
//            [wall1 addChild:iceBlock];
        }
//        wall1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:(wall1.frame.size)];
//        wall1.physicsBody.restitution = 0.1f;
//        wall1.physicsBody.friction = 0.4f;
//        // make physicsBody static
//        wall1.physicsBody.dynamic = NO;
        
        
        
        
        
        
        
        
        for (int i=0; i<10; i++) {
            SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"iceBlock.png"];
            iceBlock.position = CGPointMake(180, i*20+150);
            [iceBlock setScale:0.2];
            [self addChild:iceBlock];
            iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];
            iceBlock.physicsBody.restitution = 0.1f;
            iceBlock.physicsBody.friction = 0.4f;
            // make physicsBody static
            iceBlock.physicsBody.dynamic = NO;
        }
        


        // Create physics.
//        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
//        self.player.physicsBody.dynamic = YES;
//        self.player.physicsBody.
//        SKAction *move_up = [SKAction move];
    }
    return self;
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

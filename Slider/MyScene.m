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

-(id)initWithSize:(CGSize)size {    
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
        
        [self addChild:myLabel];
        
        // Character in the game.
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.player.position = CGPointMake(CGRectGetMidX(self.frame), 50);
        [self.player setScale:0.1];
        
        [self addChild:self.player];
        
        for (int i=0; i<10; i++) {
            SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"iceBlock.png"];
            iceBlock.position = CGPointMake(i*20, 150);
            [iceBlock setScale:0.2];
            [self addChild:iceBlock];
            iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];
            iceBlock.physicsBody.restitution = 0.1f;
            iceBlock.physicsBody.friction = 0.4f;
            // make physicsBody static
            iceBlock.physicsBody.dynamic = NO;
        }
        
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

    }
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contact");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        // Move penguin.
        CGPoint location = [touch locationInNode:self];
        SKAction *action = [SKAction moveTo:location duration:1];
        [self.player runAction:action];
        
        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        sprite.position = location; //set position of the new sprite.
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1]
//        [self.player runAction:[SKAction repeatActionForever:action]];
//        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

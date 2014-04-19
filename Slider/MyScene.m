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
@property NSMutableArray *outer;
@property NSMutableArray *inner;
@property NSInteger blocksX;
@property NSInteger blocksY;
@end

@implementation MyScene
static const uint32_t penguinCategory     =  0x1 << 0;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];

        
        float height = self.frame.size.height;
        float width =  self.frame.size.width;
        
        NSLog(@"Height of screen: %f", height);
        NSLog(@"Width of screen : %f", width);
        
        float gameHeight = height - 60;
        
//        self.outer = [[NSMutableArray alloc] initWithCapacity:width/20];
//        self.inner = [[NSMutableArray alloc] initWithCapacity:gameHeight/20];
//        
//    
//        self.blocksX = width/20;
//        self.blocksY = gameHeight/20;
//        
//        
//        self.outer = [[NSMutableArray init]alloc];
//        for (int i=0;i<_blocksX;i++)
//        {
//            NSMutableArray * my2dArray = [[NSMutableArray init]alloc];
//            for (int j=0;j<_blocksY;j++)
//            {
//                [my2dArray addObject:NULL];  // ad objects to the array
//            }
//            [self.outer addObject: my2dArray]; //add the array to the main array
//            [my2dArray: release];
//        }
//        
//
//        
        
//        for (int i=0; i<width/20; i++) {
//            SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"iceBlock.png"];
////            iceBlock.position = CGPointMake(20, 150);
//            [iceBlock setSize:CGSizeMake(20, 20)];
//            iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];
//            
//            iceBlock.physicsBody.restitution = 0.1f;
//            iceBlock.physicsBody.friction = 0.4f;
//            // make physicsBody static
//            iceBlock.physicsBody.dynamic = NO;
//            
//            [[self.outer objectAtIndex:4] addObject:iceBlock];
   //     }
        [self buildLevel];
        // Text at top of the screen.
//        myLabel.text = @"Slipy Penguin";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 420);
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                      CGRectGetMidY(self.frame));
        
        self.physicsWorld.gravity = CGVectorMake(0,-1);
        self.physicsWorld.contactDelegate = self;
        
        [self addChild:myLabel];
        
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
        
        for (int i=0; i<10; i++) {
            SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"iceBlock.png"];
            iceBlock.position = CGPointMake(i*19, 150);
            [iceBlock setSize:CGSizeMake(20, 20)];
            [self addChild:iceBlock];
            iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];

            iceBlock.physicsBody.restitution = 1.1f;
            iceBlock.physicsBody.friction = 1.0f;
            // make physicsBody static
            iceBlock.physicsBody.dynamic = NO;
        }
        
        for (int i=0; i<10; i++) {
            SKSpriteNode* iceBlock = [[SKSpriteNode alloc] initWithImageNamed: @"iceBlock.png"];
            iceBlock.position = CGPointMake(180, i*19+150);
            [iceBlock setSize:CGSizeMake(20, 20)];
            [self addChild:iceBlock];
            iceBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:iceBlock.frame.size];
            iceBlock.physicsBody.restitution = 1.1f;
            iceBlock.physicsBody.friction = 1.0f;
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

-(void)buildLevel
{
    for(int x=0; x<self.blocksX; x++) {
        for(int y=0; y<self.blocksY; y++) {
            SKSpriteNode *node =[[self.outer objectAtIndex:x] objectAtIndex:y];
            if ( node != NULL) {
                [self addChild:node];
            }
        }
    }
    
    
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

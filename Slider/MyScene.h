//
//  MyScene.h
//  Slider
//

//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"

@interface MyScene : SKScene<SKPhysicsContactDelegate>
-(void)buildLevel1;
-(SKSpriteNode*)buildIceBlock;
-(void)createCharacter;
+(void)setMyStaticVar:(ViewController*)newValue;
@end

//
//  MyScene.h
//  Slider
//

//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"

@protocol MySceneDelagate
//-(void)moveCharacter:(UISwipeGestureRecognizer *)recognizer;
@end

@interface MyScene : SKScene<SKPhysicsContactDelegate>
-(void)buildLevel1;
@property id<MySceneDelagate> delegate;
-(SKSpriteNode*)buildIceBlock;
-(void)createCharacter;
-(void)moveCharacter:(UISwipeGestureRecognizer *)recognizer;
@end

//
//  MyScene.h
//  Slider
//

//  Copyright (c) 2014 Grant Spence. All rights reserved.
//
@protocol ViewControllerDelegate
-(void)updateLabel;
@end

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "CustomAlertViewController.h"

@protocol MySceneDelagate
//-(void)moveCharacter:(UISwipeGestureRecognizer *)recognizer;
@end


@interface MyScene : SKScene

-(void)buildLevel1;
@property id<MySceneDelagate> delegate;
-(SKSpriteNode*)buildIceBlock;
-(void)createCharacter;
-(void)moveCharacter:(UISwipeGestureRecognizer *)recognizer;
//@property (nonatomic,strong) ViewController *viewController;
//@property (nonatomic, strong) CustomAlertViewController *customAlert; // Ending popup window.
-(void)initalizingScrollingBackground;
@property (nonatomic, weak) id <ViewControllerDelegate> viewControllerDelegate;
-(SKSpriteNode*)buildHoneyComb;
-(SKSpriteNode*)buildFlower;
-(void)resetGame;

@end

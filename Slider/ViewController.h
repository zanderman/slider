//
//  ViewController.h
//  Slider
//

//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

@protocol TitleViewDelegate
@required
-(void) updateLabel;
@end

//#import "MyScene.h"
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MyScene.h"
#import "CustomAlertViewController.h"


// Motion Variables
double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;
double currentMaxRotX;
double currentMaxRotY;
double currentMaxRotZ;

@interface ViewController : UIViewController<CustomAlertViewControllerDelegate>

// Motion
@property (strong, nonatomic) IBOutlet UILabel *accX;
@property (strong, nonatomic) IBOutlet UILabel *accY;
@property (strong, nonatomic) IBOutlet UILabel *accZ;

@property (strong, nonatomic) IBOutlet UILabel *maxAccX;
@property (strong, nonatomic) IBOutlet UILabel *maxAccY;
@property (strong, nonatomic) IBOutlet UILabel *maxAccZ;

@property (strong, nonatomic) IBOutlet UILabel *rotX;
@property (strong, nonatomic) IBOutlet UILabel *rotY;
@property (strong, nonatomic) IBOutlet UILabel *rotZ;

@property (strong, nonatomic) IBOutlet UILabel *maxRotX;
@property (strong, nonatomic) IBOutlet UILabel *maxRotY;
@property (strong, nonatomic) IBOutlet UILabel *maxRotZ;

//- (IBAction)resetMaxValues:(id)sender;
@property (nonatomic, strong) CustomAlertViewController *customAlert; // Ending popup window.
@property (strong, nonatomic) CMMotionManager *motionManager;
-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer;
-(void)showResultScreen: (NSString*)str1 : (NSString*)str2;
-(void)removeResultScreen;

-(void)test;

@property (nonatomic, weak) id <TitleViewDelegate> titleViewDelegate;
@property id<ViewControllerDelegate> delegate;
@end

//
//  ViewController.m
//  Slider
//
//  Created by Grant Spence on 4/18/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
//#import "CustomAlertViewController.m"

// Interface
@interface ViewController ()
-(void)showResultScreen:(NSString*)str1 : (NSString*)str2;
@property (nonatomic, strong) SKScene *scene;
@end

// Implementation
@implementation ViewController
MyScene *obj; // Declare MyScene object.
UIViewController *uivc;
@synthesize titleViewDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    uivc = self;

//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [MyScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    
    
    
    // INitialize the custom view.
//    _customAlert = [[CustomAlertViewController alloc] init];
//    [_customAlert setDelegate:self];
//    [_customAlert showCustomAlertInView:self.view withMessage:@"Score: ???":@"WIN!"];
    
    
    
    
    // Present the scene.
    [skView presentScene:_scene];
    skView.bounds.size.width;
    
    
    
    
    // Configure delegate
    obj = _scene;
    [obj setDelegate:self];
    CGPointMake(2,3);
    
    
    
    
    
    // swipe gesture variable
    UISwipeGestureRecognizer *left_gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    UISwipeGestureRecognizer *right_gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    UISwipeGestureRecognizer *up_gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    UISwipeGestureRecognizer *down_gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    
    // initialize gesture directions.
    [left_gesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [right_gesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [up_gesture setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [down_gesture setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    
    // Set as gesture possibility for the main view window.
    [self.view addGestureRecognizer:left_gesture];
    [self.view addGestureRecognizer:right_gesture];
    [self.view addGestureRecognizer:up_gesture];
    [self.view addGestureRecognizer:down_gesture];
    
    
//    // View Controller Popup code.
//    ViewController *viewController = [[ViewController alloc] init];
//    [self  addChildViewController:viewController];
//    viewController.view.frame = scene.frame;
//    [scene.view addSubview:viewController.view];
//    viewController.view.alpha = 0;
//    [viewController didMoveToParentViewController:scene];
    
    
//    // Motion
//    for (UIViewController *vc in [self childViewControllers]) {
//        if([vc isKindOfClass:[TitleViewController class]]){
//            tv = (TitleViewController *)vc; //Example & reminder to cast your reference
//        }
//    }
//    [tv setDelegate:self];
    //[obj buildIceBlock];
    //  f  // Motion
//    currentMaxAccelX = 0;
//    currentMaxAccelY = 0;
//    currentMaxAccelZ = 0;
//    currentMaxRotX = 0;
//    currentMaxRotY = 0;
//    currentMaxRotZ = 0;
//    self.motionManager = [[CMMotionManager alloc] init];
//    self.motionManager.accelerometerUpdateInterval = .2;
//    self.motionManager.gyroUpdateInterval = .2;
//    
//    //
//    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
//    withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
//        [self outputAccelertionData:accelerometerData.acceleration];
//        if(error){
//            NSLog(@"%@", error);
//        }
//        }];
//    
//    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
//    withHandler:^(CMGyroData *gyroData, NSError *error) {
//        [self outputRotationData:gyroData.rotationRate];
//        }];
//
//    //
    
}

-(void)updateLabel
{
    NSLog(@"LOL2");
//    [tv updateLabel];
}

// Methods for getting the data.
-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
    
    
    self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
    self.accZ.text = [NSString stringWithFormat:@" %.2fg",acceleration.z];
    if(fabs(acceleration.z) > fabs(currentMaxAccelZ))
    {
        currentMaxAccelZ = acceleration.z;
    }
    
    self.maxAccX.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelX];
    self.maxAccY.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelY];
    self.maxAccZ.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelZ];
    
    
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    
    self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    if(fabs(rotation.x) > fabs(currentMaxRotX))
    {
        currentMaxRotX = rotation.x;
    }
    self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    if(fabs(rotation.y) > fabs(currentMaxRotY))
    {
        currentMaxRotY = rotation.y;
    }
    self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
    if(fabs(rotation.z) > fabs(currentMaxRotZ))
    {
        currentMaxRotZ = rotation.z;
    }
    
    self.maxRotX.text = [NSString stringWithFormat:@" %.2f",currentMaxRotX];
    self.maxRotY.text = [NSString stringWithFormat:@" %.2f",currentMaxRotY];
    self.maxRotZ.text = [NSString stringWithFormat:@" %.2f",currentMaxRotZ];
    
    // Print to output.
    NSLog(@"%@",self.maxRotX.text);
}
// -----------------------------







- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// Handle all swipe events.
-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
//    [skView presentScene:scene];
    [obj moveCharacter:recognizer]; // Call MyScene method.
}
-(void)showResultScreen:(NSString*)str1 : (NSString*)str2 {
//    NSLog(@"made it");
    _customAlert = [[CustomAlertViewController alloc] init];
    [_customAlert setDelegate:uivc];
    [_customAlert showCustomAlertInView:uivc.view withMessage:str1:str2];
}

@end

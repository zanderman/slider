//
//  ViewController.m
//  Slider
//
//  Created by Grant Spence on 4/18/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "TitleViewController.h"

@implementation ViewController
MyScene *obj; // Declare MyScene object.
TitleViewController *tv;
@synthesize titleViewDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;

//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Configure delegate
    obj = scene;
    [obj setDelegate:self];
    
    // Present the scene.
    [skView presentScene:scene];
    skView.bounds.size.width;
    
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
    
    for (UIViewController *vc in [self childViewControllers]) {
        if([vc isKindOfClass:[TitleViewController class]]){
            tv = (TitleViewController *)vc; //Example & reminder to cast your reference
        }
    }
    [tv setDelegate:self];
    [obj buildIceBlock];
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
    [tv updateLabel];
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
    [obj moveCharacter:recognizer]; // Call MyScene method.
}

@end

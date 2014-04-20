//
//  CustomAlertViewController.m
//  Slider
//
//  Created by Alexander DeRieux on 4/19/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import "CustomAlertViewController.h"
#define OK_BUTTON_TAG   888
#define ANIMATION_DURATION  0.25
#include "MyScene.h"

@interface CustomAlertViewController ()
@property (nonatomic,strong) MyScene *myscene;
@end
//SKScene *test;
@implementation CustomAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Allocate space for the scene variable.
//        test = _myscene.scene;
//        self.view.superview
        
        // Custom initialization
        [self.view setBackgroundColor:[UIColor  colorWithRed:0 green:0 blue:0 alpha:0]];
        [_viewMessage.layer setCornerRadius:10.0f];
        _viewMessage.layer.masksToBounds = YES;
        
        // Set Button Info.
        [_btnOK setTitle:@"Play Again!" forState:UIControlStateNormal];
        [_btnOK setEnabled:YES];

        [_btnOK setTag:OK_BUTTON_TAG];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)btnOkayTap:(id)sender {
//}

- (IBAction)btnOkayTap:(id)sender {
    [self.view removeFromSuperview];
    [_myscene resetGame];
}

-(void)showCustomAlertInView:(UIView *)targetView withMessage:(NSString *)message1 : (NSString *)message2 {
    CGFloat statusBarOffset;
    
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        // If the status bar is not hidden then we get its height and keep it to the statusBarOffset variable.
        // However, there is a small trick here that needs to be done.
        // In portrait orientation the status bar size is 320.0 x 20.0 pixels.
        // In landscape orientation the status bar size is 20.0 x 480.0 pixels (or 20.0 x 568.0 pixels on iPhone 5).
        // We need to check which is the smallest value (width or height). This is the value that will be kept.
        // At first we get the status bar size.
        CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
        if (statusBarSize.width < statusBarSize.height) {
            // If the width is smaller than the height then this is the value we need.
            statusBarOffset = statusBarSize.width;
        }
        else{
            // Otherwise the height is the desired value that we want to keep.
            statusBarOffset = statusBarSize.height;
        }
    }
    else{
        // Otherwise set it to 0.0.
        statusBarOffset = 0.0;
    }
    
    
    // Declare the following variables that will take their values
    // depending on the orientation.
    CGFloat width, height, offsetX, offsetY;
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        // If the orientation is landscape then the width
        // gets the targetView's height value and the height gets
        // the targetView's width value.
        width = targetView.frame.size.height;
        height = targetView.frame.size.width;
        
        offsetX = -statusBarOffset;
        offsetY = 0.0;
    }
    else{
        // Otherwise the width is width and the height is height.
        width = targetView.frame.size.width;
        height = targetView.frame.size.height;
        
        offsetX = 0.0;
        offsetY = -statusBarOffset;
    }
    
    // Set the view's frame and add it to the target view.
    [self.view setFrame:CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y, width, height)];
    [self.view setFrame:CGRectOffset(self.view.frame, self.view.frame.size.width*0.1, self.view.frame.size.height*0.2)]; // Set to center of screen.
    [targetView addSubview:self.view];
    
    
    // Set the initial frame of the message view.
    // It should be out of the visible area of the screen.
    [_viewMessage setFrame:CGRectMake(0.0, -_viewMessage.frame.size.height, _viewMessage.frame.size.width, _viewMessage.frame.size.height)];
//    [_viewMessage setBackgroundColor:[UIColor blackColor] colo];
    _viewMessage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _buttonWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [_btnOK setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_scoreMessage setTextColor:[UIColor whiteColor]];
    [_winloseMessage setTextColor:[UIColor whiteColor]];
    [_resultImage setImage:[UIImage imageNamed:@"Bee.png"]];
    _resultImage.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    // Animate the display of the message view.
    // We change the y point of its origin by setting it to 0 from the -height value point we previously set it.
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_viewMessage setFrame:CGRectMake(0.0, 0.0, _viewMessage.frame.size.width, _viewMessage.frame.size.height)];
//    [_viewMessage setFrame:CGRectMake(0.0, 0.0, 100, 100)];
    [UIView commitAnimations];
    
    // Set the message that will be displayed.
    [_scoreMessage setText:message1];
    [_winloseMessage setText:message2];
}

@end

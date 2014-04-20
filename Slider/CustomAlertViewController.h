//
//  CustomAlertViewController.h
//  Slider
//
//  Created by Alexander DeRieux on 4/19/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CustomAlertViewControllerDelegate
//-(void)customAlertOK;
//-(void)customAlertCancel;
@end

@interface CustomAlertViewController : UIViewController
@property (nonatomic, retain) id<CustomAlertViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *viewMessage;
@property (weak, nonatomic) IBOutlet UIView *buttonWindow;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *scoreMessage;
@property (weak, nonatomic) IBOutlet UILabel *winloseMessage;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;


@property (strong, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

// Actions
-(void)showCustomAlertInView:(UIView *)targetView withMessage:(NSString *)message1 : (NSString *)message2;
//- (IBAction)btnOkayTap:(id)sender;

@end

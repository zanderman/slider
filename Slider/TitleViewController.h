//
//  TitleViewController.h
//  Slider
//
//  Created by Grant Spence on 4/19/14.
//  Copyright (c) 2014 Grant Spence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScene.h"


@interface TitleViewController : UIViewController<TitleViewDelegate>
@property id<TitleViewDelegate> delegate;

@end

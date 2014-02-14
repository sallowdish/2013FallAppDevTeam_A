//
//  FullScreenImageController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenImageController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;


@property (weak, nonatomic) UIImage* image;

@end

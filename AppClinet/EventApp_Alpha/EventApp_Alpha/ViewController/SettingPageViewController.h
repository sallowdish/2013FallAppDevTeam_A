//
//  SettingPageViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-30.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CQMFloatingController.h"

@interface SettingPageViewController : UIViewController

- (IBAction)loginClicked:(id)sender;

@property (strong,nonatomic) CQMFloatingController *popController;


@end

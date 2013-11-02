//
//  SettingPageViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-30.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SettingPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *usetTokenLabel;
- (IBAction)onclickLoginViaWeibo:(id)sender;

@end

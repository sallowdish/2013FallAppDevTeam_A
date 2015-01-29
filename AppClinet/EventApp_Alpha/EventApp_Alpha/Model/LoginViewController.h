//
//  LoginViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-12-15.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CQMFloatingController.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *isKeepLoginSwitch;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (weak, nonatomic) CQMFloatingController *shareController;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak,nonatomic) UIViewController* hostViewController;
@end

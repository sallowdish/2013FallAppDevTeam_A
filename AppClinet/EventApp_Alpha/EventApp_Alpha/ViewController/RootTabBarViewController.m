//
//  RootTabBarViewController.m
//  哪兒玩
//
//  Created by Rui Zheng on 2014-10-24.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "RootTabBarViewController.h"

@implementation RootTabBarViewController

-(void)viewDidLoad{
    self.delegate=self;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
}
@end

//
//  CreditPageViewController.m
//  哪兒玩
//
//  Created by Rui Zheng on 2014-10-24.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "CreditPageViewController.h"

@implementation CreditPageViewController

-(void)viewDidLoad{
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}
@end

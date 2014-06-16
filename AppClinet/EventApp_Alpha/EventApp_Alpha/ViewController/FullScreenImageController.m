//
//  FullScreenImageController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "FullScreenImageController.h"

@interface FullScreenImageController ()

@end

@implementation FullScreenImageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView.image=self.image;
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonPressed:) forControlEvents:UIControlEventTouchDown];
}

- (IBAction)fullScreenButtonPressed:(id)sender{
    self.navigationController.navigationBarHidden=!self.navigationController.navigationBarHidden;
    self.tabBarController.tabBar.hidden=!self.tabBarController.tabBar.hidden;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

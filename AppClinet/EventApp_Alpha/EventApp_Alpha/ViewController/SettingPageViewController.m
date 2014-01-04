//
//  SettingPageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-30.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "SettingPageViewController.h"
#import "LoginViewController.h"



@interface SettingPageViewController ()
@end	

@implementation SettingPageViewController
//@synthesize popController;

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
}

- (IBAction)loginClicked:(id)sender
{
    [self popOver:sender];
}

//- (IBAction)onclickLoginViaWeibo:(id)sender {
////    [self loadLoginView];
//    [self popOver:sender];
//}

-(void)popOver:(id)sender
{
    LoginViewController* loginview=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    UIViewController* loginview=[[UIViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    [floatingController setFrameColor:[UIColor whiteColor]];
    [floatingController setLandscapeFrameSize:loginview.view.bounds.size];
    [floatingController setPortraitFrameSize:loginview.view.bounds.size];
    [floatingController showInView:self.view withContentViewController:loginview animated:YES];
}

//- (void)loadLoginView
//{
////    [[self view] addSubview:[[LoginViewController alloc] init]];
//    LoginViewController* loginview=[[LoginViewController alloc] initWithNibName:@"LoginViewController.xib" bundle:self.nibBundle];
//    UIPopoverController* pop=[[UIPopoverController alloc] initWithContentViewController:loginview];
//    [pop presentPopoverFromRect:CGRectMake(0, 0, 640, 960) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SettingPageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-30.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "SettingPageViewController.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "popoverAlterModel.h"



@interface SettingPageViewController ()
@property (weak, nonatomic) IBOutlet UIView *logoutCell;


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
    
    //Makeup
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapped)];
    tap.numberOfTapsRequired=1;
    [self.logoutCell addGestureRecognizer:tap];
}

-(void)logoutTapped{
    if ([UserModel isLogin]) {
        UserModel* model=[[UserModel alloc] init];
        [model logoutCurrentUser];
        [popoverAlterModel alterWithTitle:@"Logout" Message:@"Logout Succeed"];
        [self.view setNeedsDisplay];
    }
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
    [UserModel popupLoginViewToViewController:self];
    [self.view setNeedsDisplay];
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

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
#import "ProfilePageViewController.h"



@interface SettingPageViewController ()
@property (weak, nonatomic) IBOutlet UIView *logoutCell;
@property (weak, nonatomic) IBOutlet UIView *loginCell;
@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;


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
    
    
    //Functionanity Setup
    self.prompt.lineBreakMode=NSLineBreakByWordWrapping;
    self.prompt.numberOfLines=0;
    
    //Visual
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTopCell) name:@"loginProcessFinish" object:nil];
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapped)];
    tap.numberOfTapsRequired=1;
    [self.logoutCell addGestureRecognizer:tap];
    

}

-(void) viewWillAppear:(BOOL)animated{
    [self reloadTopCell];
}

-(void)reloadTopCell{
    UITapGestureRecognizer* tap;
    if ([UserModel isLogin]) {
        tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapped)];
        tap.numberOfTapsRequired=1;
        [self.loginCell addGestureRecognizer:tap];
        self.userProfileImage.image=[UserModel getProfileImage];
        self.prompt.text=[NSString stringWithFormat:@"Hi, %@.\nTap to see your profile.",[UserModel username]];
    }
    else{
        tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTapped)];
        tap.numberOfTapsRequired=1;
        [self.loginCell addGestureRecognizer:tap];
        self.userProfileImage.image=[UIImage imageNamed:@"default_profile_5_bigger.png"];
        self.prompt.text=@"Tap to login";
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)profileTapped{
    ProfilePageViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
    vc.targetUser=[UserModel current_user];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)logoutTapped{
    if ([UserModel isLogin]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTopCell) name:@"loginProcessFinish" object:nil];
        UserModel* model=[[UserModel alloc] init];
        [model logoutCurrentUser];
        [self reloadTopCell];
        [popoverAlterModel alterWithTitle:@"Logout" Message:@"Logout Succeed"];
//        [self.view setNeedsDisplay];
    }
}

- (void)loginTapped
{
    [self popOver];
//    [self.view setNeedsDisplay];
}

//- (IBAction)onclickLoginViaWeibo:(id)sender {
////    [self loadLoginView];
//    [self popOver:sender];
//}

-(void)popOver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTopCell) name:@"loginProcessFinish" object:nil];
    [UserModel popupLoginViewToViewController:self];
//    [self.view setNeedsDisplay];
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

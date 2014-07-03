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
@property (weak, nonatomic) IBOutlet UITableViewCell *topCell;
@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIView *profileCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *myEventListCell;

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
    self.topCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //Functionanity Setup
    self.prompt.lineBreakMode=NSLineBreakByWordWrapping;
    self.prompt.numberOfLines=0;
    
    //Visual
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //User Interaction
    UITapGestureRecognizer* tap;
    
    
    if (![UserModel isLogin]) {
        tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTapped)];
        tap.numberOfTapsRequired=1;
        [self.loginCell addGestureRecognizer:tap];
    }
    
    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapped)];
    tap.numberOfTapsRequired=1;
    [self.profileCell addGestureRecognizer:tap];
    
    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapped)];
    tap.numberOfTapsRequired=1;
    [self.logoutCell addGestureRecognizer:tap];
    
    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myEventListTapped:)];
    tap.numberOfTapsRequired=1;
    [self.myEventListCell addGestureRecognizer:tap];
    

}

-(void) viewWillAppear:(BOOL)animated{
    [self reloadTopCell];
}

-(void)reloadTopCell{
    //clean up the ges
    for (UIGestureRecognizer* ges in self.loginCell.gestureRecognizers) {
        [self.loginCell removeGestureRecognizer:ges];
    }
    UITapGestureRecognizer *tap;
    if ([UserModel isLogin]) {
        [UserModel getProfileImageWithUser:[UserModel current_user] Sender:self.userProfileImage];
        self.prompt.text=[NSString stringWithFormat:@"Hi, %@.\nTap to see your profile.",[UserModel username]];
    }
    else{
        tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTapped)];
        
        tap.numberOfTapsRequired=1;
        [self.loginCell addGestureRecognizer:tap];
        
        self.userProfileImage.image=[UIImage imageNamed:@"Blank-Profile-Image.png"];
        self.prompt.text=@"Tap to login";
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)profileTapped{
    if ([UserModel isLogin]) {
        ProfilePageViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
        vc.targetUser=[UserModel current_user];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        [self loginTapped];
    }
}

-(void)logoutTapped{
    if ([UserModel isLogin]) {
        UserModel* model=[[UserModel alloc] init];
        [model logoutCurrentUser];
        [self reloadTopCell];
        [popoverAlterModel alterWithTitle:@"Logout" Message:@"Logout Succeed"];
    }
}

- (void)loginTapped
{
    [self popOver];
//    [self.view setNeedsDisplay];
}

- (IBAction)myEventListTapped:(id)sender {
    if ([UserModel isLogin]) {
        [self performSegueWithIdentifier:@"myEventListSegue" sender:self];
    }
    else{
        [self loginTapped];
    }

}

-(void)popOver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTopCell) name:@"loginProcessFinish" object:nil];
//    LoginViewController* loginView=[[self.navigationController storyboard] instantiateViewControllerWithIdentifier:@"LoginPage"];
//    [self.navigationController pushViewController:loginView animated:YES];
//    [self presentViewController:loginView animated:YES completion:nil]
    
    [UserModel popupLoginViewToViewController:self complete:^(LoginViewController *loginview) {
        [self.navigationController pushViewController:loginview animated:YES];
    }];

    
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

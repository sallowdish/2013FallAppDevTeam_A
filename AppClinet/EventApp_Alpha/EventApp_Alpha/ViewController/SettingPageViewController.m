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
//@property (weak, nonatomic) IBOutlet UIView *profileCell;

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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTopCell) name:@"loginProcessFinish" object:nil];
    
    [UserModel popupLoginViewToViewController:self complete:nil];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"SettingToProfile"]) {
        ProfilePageViewController* vc=(ProfilePageViewController*)[segue destinationViewController];
        vc.targetUser=[UserModel current_user];
    }else{
        [super prepareForSegue:segue sender:sender];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 && indexPath.row==0) {
        if (![UserModel isLogin]) {
            [self loginTapped];
        }
        else{
            [self performSegueWithIdentifier:@"SettingToProfile" sender:self];
        }
    }
//    else{
//        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

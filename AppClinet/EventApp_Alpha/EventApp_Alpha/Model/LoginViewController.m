 //
//  LoginViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-12-15.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "LoginViewController.h"
#import "popoverAlterModel.h"
#import "UserModel.h"
#import "ProgressHUD.h"

#define MAXTAG 100

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *forgetLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel;
@property (weak, nonatomic) IBOutlet UIImageView *user_profile_image;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation LoginViewController
@synthesize usernameField,passwordField;

UserModel* model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
        [self viewDidLoad];
        
    }
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //initialize local var
    
    //Functionality Setup
    UITapGestureRecognizer* dismissKeyBoardTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    dismissKeyBoardTap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:dismissKeyBoardTap];
    
    //Visual Setup
    self.scrollview.contentSize=CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*1.0);
    [self.scrollview removeFromSuperview];
    self.scrollview.frame=CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:self.scrollview];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.forgetLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Forget your password?" attributes:underlineAttribute];
    self.signupLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Need a new account?" attributes:underlineAttribute];
    self.forgetButton.frame=self.forgetLabel.frame;
    self.signupButton.frame=self.signupLabel.frame;
    self.view.layer.cornerRadius=6;
    for (int i=100; i<MAXTAG+1; i++) {
        UIView* subview=[self.view viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }
    
    //Dynamic makeup
    if ([UserModel isLogin]) {
        self.loginButton.enabled=NO;
        self.user_profile_image.image=[UserModel getProfileImage];
    }else{
        model=[[UserModel alloc] init];
    }
}

-(void)dismissKeyBoard{
    [self.view endEditing:YES];
}

- (IBAction)cancelButtonPressed:(id)sende
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginProcessFinish" object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchOutside:(id)sender {
    [self.view endEditing:YES];
}

-(IBAction)loginButtonPressed:(id)sende{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:@"didLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailToLogin) name:@"failToLogin" object:nil];
    
    
    [UserModel turnOffDevelopmentMode];
    [ProgressHUD show:@"Login..."];
    [model logoutCurrentUser];
    [model loginWithUsername:self.usernameField.text AndPassword:self.passwordField.text];
}

-(void) didLogin{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [model updataUserInfo];
    [[ProgressHUD class] dismiss];
    
    self.user_profile_image.image=[UserModel getProfileImage];
    self.loginButton.enabled=NO;
    [popoverAlterModel alterWithTitle:@"Login Succeed" Message:[NSString stringWithFormat:@"Hi,%@",[UserModel username]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginProcessFinish" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) didFailToLogin{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[ProgressHUD class] dismiss];
    [popoverAlterModel alterWithTitle:@"Fail to login" Message:@"Please double check your username and password"];
}


- (IBAction)forgetPassword:(id)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forget Your Password?"
//                                                    message:@"Baka!\nばか!!\n馬~鹿!!!"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    [popoverAlterModel alterWithTitle:@"Forget Your Password?" Message:@"Baka!\nばか!!\n馬~鹿!!!"];
}


- (IBAction)signupButtonPassword:(id)sender
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SignupPage"] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

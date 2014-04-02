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
@property (weak, nonatomic) IBOutlet UIImageView *user_profile_image;

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
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.forgetLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Forget your password?" attributes:underlineAttribute];
    self.forgetButton.frame=self.forgetLabel.frame;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginProcessFinish" object:nil];
    [self.shareController dismissAnimated:YES];
}

- (IBAction)touchOutside:(id)sender {
    [self.view endEditing:YES];
}

-(IBAction)loginButtonPressed:(id)sende{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:@"didLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailToLogin) name:@"failToLogin" object:nil];
    
    [ProgressHUD show:@"Login..."];
    [model logoutCurrentUser];
    [model loginWithUsername:self.usernameField.text AndPassword:self.passwordField.text];
}

-(void) didLogin{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[ProgressHUD class] dismiss];
    
    self.user_profile_image.image=[UserModel getProfileImage];
    self.loginButton.enabled=NO;
    [popoverAlterModel alterWithTitle:@"Login Succeed" Message:[NSString stringWithFormat:@"Hi,%@",[UserModel username]]];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

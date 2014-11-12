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
#import "ColorStandarlizationModel.h"

#define MAXTAG_SIGNUP 100

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *forgetLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel;
@property (weak, nonatomic) IBOutlet UIImageView *user_profile_image;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutletCollection(id) NSArray *needRoundBorder;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *needRoundBorderButtons;


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
    
    self.scrollview.hidden=YES;
    CGRect containerFrame=self.containerView.frame;
    self.scrollview.contentSize=CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.containerView.frame));
//    [self.scrollview removeFromSuperview];
    self.scrollview.frame=CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    self.containerView.frame=containerFrame;
    self.scrollview.hidden=NO;
    
    UIImageView* backgroundContainer;
    for (id view in self.view.subviews) {
        if ([view isMemberOfClass:[UIImageView class]]) {
            backgroundContainer=view;
            break;
        }
    }

//    backgroundContainer.frame=CGRectFromString(NSStringFromCGRect(_containerView.frame));
    if ([[UIScreen mainScreen] bounds].size.height==480) {
        backgroundContainer.image=[UIImage imageNamed:@"background_4s.png"];
    }

    //profile image holder

    
    //textField decoration
    for (UIView* field in _needRoundBorder) {
        field.backgroundColor=[UIColor clearColor];
        
        field.layer.cornerRadius=((float)field.bounds.size.height)/2;
        field.layer.borderWidth=1.0f;
        field.layer.borderColor=[UIColor whiteColor].CGColor;
        field.clipsToBounds=YES;
//        field.layer.masksToBounds=YES;
    }
    
    //Button
    for (UIButton* button in _needRoundBorderButtons) {
        button.layer.borderColor=[UIColor clearColor].CGColor;
        button.layer.cornerRadius=((float)button.bounds.size.height)/2;
        button.backgroundColor=[ColorStandarlizationModel colorWithHexString:@"ff8f00"];
        [button setTintColor:[ColorStandarlizationModel colorWithRGBString:@"255 255 255"]];
    }
    
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.forgetLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Password" attributes:underlineAttribute];
    self.signupLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Register" attributes:underlineAttribute];
    self.forgetButton.frame=self.forgetLabel.frame;
    self.signupButton.frame=self.signupLabel.frame;
    self.view.layer.cornerRadius=6;
    for (int i=100; i<MAXTAG_SIGNUP+1; i++) {
        UIView* subview=[self.view viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }
    
    //Dynamic makeup
    if ([UserModel isLogin]) {
        self.loginButton.enabled=NO;
        [UserModel getProfileImageWithUser:[UserModel current_user] Sender:self.user_profile_image];
    }else{
        model=[[UserModel alloc] init];
    }
}

-(void)dismissKeyBoard{
    [self.view endEditing:YES];
}

- (IBAction)cancelButtonPressed:(id)sende
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [UserModel getProfileImageWithUser:[UserModel current_user] Sender:self.user_profile_image];
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
    [popoverAlterModel alterWithTitle:@"Forget Your Password?" Message:@"馬~鹿!!註冊個新的吧～\n或者請聯繫開發者sallowdish@gmail.com"];
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

-(IBAction)secureTextField:(id)sender{
    if ([sender isMemberOfClass:[UITextField class]]) {
        ((UITextField*)sender).secureTextEntry=YES;
    }
}

-(IBAction)clearTextField:(id)sender{
    if ([sender isMemberOfClass:[UITextField class]]) {
        ((UITextField*)sender).text=@"";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
}

@end

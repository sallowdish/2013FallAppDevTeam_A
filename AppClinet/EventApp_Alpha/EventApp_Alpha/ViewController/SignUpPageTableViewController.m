//
//  SignUpPageTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-27.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//
#import <MobileCoreServices/UTCoreTypes.h>
#import "SignUpPageTableViewController.h"
#import "SignUpModel.h"
#import "popoverAlterModel.h"
#import "ProgressHUD.h"
#import "ImageModel.h"
//#import "GKImagePicker.h"

@interface SignUpPageTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fillupCheckSet;
@property (weak, nonatomic) IBOutlet UITextField *nicknameField;
@property GKImagePicker* imagePicker;
@end

@implementation SignUpPageTableViewController

NSMutableDictionary* dict;
UIImage* selectedImage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dict=nil;
    selectedImage=nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitButtonPressed{
    if ([self validateInfo]) {
        dict=[NSMutableDictionary dictionaryWithCapacity:0];
        [dict setValue:self.usernameField.text forKey:@"username"];
        [dict setValue:self.passwordField.text forKey:@"password"];
        [dict setValue:self.emailField.text forKey:@"email"];
        [dict setValue:self.nicknameField.text forKey:@"user_nickname"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSignUp) name:@"didSignUp" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFailSignUp:) name:@"didFailSignUp" object:nil];
        [ProgressHUD show:@"Creating new account..."];
        [[[SignUpModel alloc]init] signUp:dict];
    }
    
}

-(void)didSignUp{
    [popoverAlterModel alterWithTitle:@"Succeed!" Message:[NSString stringWithFormat:@"You have created a new account named %@", self.usernameField.text]];
    if (selectedImage) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUploadProfileImage) name:@"didUploadImage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailUploadProfileImage) name:@"didFailUploadImage" object:nil];
        [[[ImageModel alloc] init] uploadImage:selectedImage User:self.usernameField.text];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
        [ProgressHUD dismiss];
    }
    
}

-(void)didUploadProfileImage{
//    [popoverAlterModel alterWithTitle:@"Succeed" Message:[NSString stringWithFormat:@"You have created a new account named %@",self.usernameField.text]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
    [ProgressHUD dismiss];
}

-(void)didFailUploadProfileImage{
    [popoverAlterModel alterWithTitle:@"Warning" Message:[NSString stringWithFormat:@"You have created a new account named %@.\n But the profile image upload failed, please try again in profile page later.",self.usernameField.text]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
    [ProgressHUD dismiss];
}

-(void)didFailSignUp:(NSNotification*) notif{
    NSDictionary* errorMessage=[NSJSONSerialization JSONObjectWithData:notif.object options:NSJSONReadingMutableContainers error:nil];
    [popoverAlterModel alterWithTitle:@"Failed." Message:[errorMessage objectForKey:@"error_message"]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
}

-(BOOL)validateInfo{
    //check required field
    for (UITextField* field in self.fillupCheckSet) {
        if ([field.text isEqualToString:@""]) {
            [popoverAlterModel alterWithTitle:@"Warning!" Message:@"Please fill up all blanks."];
            return NO;
        }
    }
    //check if username is valid
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    s=[s invertedSet];
    NSRange range=[self.usernameField.text rangeOfCharacterFromSet:s];
    if (range.location!=NSNotFound) {
        [popoverAlterModel alterWithTitle:@"Warning!" Message:@"Please use [a-z],[0-9] and '_' in username only."];
        return NO;

    }
    //check if email if valid
    BOOL res=[self isValidEmail:self.emailField.text];
    if (!res) {
        [popoverAlterModel alterWithTitle:@"Warning!" Message:@"Please submit a valid email address."];
        return NO;

    }
    //check if passwords are consistent
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        self.passwordField.text=@"";
        self.confirmPasswordField.text=@"";
        [popoverAlterModel alterWithTitle:@"Warning!" Message:@"Passwords are not consist!"];
        return NO;
    }
    return YES;
}


-(BOOL)isValidEmail:(NSString*)email{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegEx];
    return [emailTest evaluateWithObject:email];
}

-(IBAction)imagePickerPopup:(id)sender{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(320, 320);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
//    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];

    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}

-(void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    self.profileImageView.image=image;
    selectedImage=image;
    [self hideImagePicker];
}

-(void)hideImagePicker{
    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    // Code here to work with media
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
//    {
//        self.profileImageView.image=info[UIImagePickerControllerOriginalImage];
//        // Media is an image
////        [self updateSelectedImage];
//    }
//}
//
//
//-(void)imagePickerControllerDidCancel:
//(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


@end

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
        
        if (selectedImage) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishUploadImage:) name:@"didFinishUploadImage" object:nil];
            
            [ProgressHUD show:@"Uploading profile image..."];
            [[[ImageModel alloc]init] uploadImage:selectedImage];
            
        }else{
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSignUp) name:@"didSignUp" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFailSignUp:) name:@"didFailSignUp" object:nil];
            [ProgressHUD show:@"Creating new account..."];
            [[[SignUpModel alloc]init] signUp:dict];
        }
        
        
    }
    
}

-(void)didFinishUploadImage:(NSNotification*)notif{
    if (notif) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishUploadImage" object:nil];
        
#pragma pass the point to image into dict
        [dict setObject:[NSString stringWithFormat:@"%@",[notif object]] forKey:@"profile_image_name"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSignUp) name:@"didSignUp" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFailSignUp:) name:@"didFailSignUp" object:nil];
        [ProgressHUD show:@"Creating new account..."];
        [[[SignUpModel alloc]init] signUp:dict];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishUploadImage" object:nil];
        [ProgressHUD dismiss];
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Something went wrong. Please try again later."];
    }
    
//    [model postEventwithInfo:dic];
}
-(void)didSignUp{
    [popoverAlterModel alterWithTitle:@"Succeed!" Message:[NSString stringWithFormat:@"You have created a new account named %@", self.usernameField.text]];
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
    for (UITextField* field in self.fillupCheckSet) {
        if ([field.text isEqualToString:@""]) {
            [popoverAlterModel alterWithTitle:@"Warning!" Message:@"Please fill up all blanks."];
            return NO;
        }
    }
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        self.passwordField.text=@"";
        self.confirmPasswordField.text=@"";
        [popoverAlterModel alterWithTitle:@"Warning!" Message:@"Passwords are not consist!"];
        return NO;
    }
    return YES;
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

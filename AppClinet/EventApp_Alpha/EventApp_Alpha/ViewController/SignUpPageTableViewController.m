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

@interface SignUpPageTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fillupCheckSet;

@end

@implementation SignUpPageTableViewController

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
        NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithCapacity:0];
        [dict setValue:self.usernameField.text forKey:@"username"];
        [dict setValue:self.passwordField.text forKey:@"password"];
        [dict setValue:self.emailField.text forKey:@"email"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSignUp) name:@"didSignUp" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFailSignUp:) name:@"didFailSignUp" object:nil];
        [[[SignUpModel alloc]init] signUp:dict];
    }
    
}

-(void)didSignUp{
    [popoverAlterModel alterWithTitle:@"Succeed!" Message:[NSString stringWithFormat:@"You have created a new account named %@", self.usernameField.text]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didFailSignUp:(NSNotification*) notif{
    [popoverAlterModel alterWithTitle:@"Failed." Message:[[NSString alloc] initWithData:notif.object encoding:NSUTF8StringEncoding]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = self;
    
    [self presentViewController: mediaUI animated: YES completion:nil];
    //    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Code here to work with media
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.profileImageView.image=info[UIImagePickerControllerOriginalImage];
        // Media is an image
//        [self updateSelectedImage];
    }
}


-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

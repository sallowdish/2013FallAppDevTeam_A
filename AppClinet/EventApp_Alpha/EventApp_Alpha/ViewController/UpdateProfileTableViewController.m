//
//  UpdateProfileTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-09-08.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "UpdateProfileTableViewController.h"
#import "popoverAlterModel.h"
#import "ProgressHUD.h"
#import "ImageModel.h"
#import "UserModel.h"

@interface UpdateProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fillupCheckSet;
@property (weak, nonatomic) IBOutlet UITextField *nicknameField;
@property GKImagePicker* imagePicker;
@end

@implementation UpdateProfileTableViewController

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
    if (self.current_user) {
        self.nicknameField.text=self.current_user[@"user_nickname"];
        NSString *targetURL=[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,self.current_user[@"fk_user_image"][@"path"]];
        [self.profileImageView setImageWithURL:[NSURL URLWithString:targetURL] placeholderImage:[UIImage imageNamed:@"152_152icon.png"]];
    }else{
        [ProgressHUD showError:@"Cannot load current user's info."];
    }

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
        [dict setValue:self.nicknameField.text forKey:@"user_nickname"];

        [ProgressHUD show:@"Updating Profle Info..."];
        AFHTTPRequestOperationManager* mgr=[URLConstructModel authorizedJsonManger];
        [mgr PUT:[NSString stringWithFormat:@"%@%@%@%@%@%@/?username=%@&api_key=%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/user/",self.current_user[@"id"],[UserModel username],[UserModel userAPIKey]] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [ProgressHUD showSuccess:@"Update Your Profile Info Successfully."];
            [[UserModel class] updateUserInfo];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ProgressHUD showError:[NSString stringWithFormat:@"Oops, something goes wrong,%@",[error localizedDescription]]];
        }];
    }
}





-(BOOL)validateInfo{
    if (self.nicknameField.text.length>10) {
        [ProgressHUD showError:@"Nickname cannot exceed 10 letters."];
        return NO;
    }
    return YES;
}


//-(BOOL)isValidEmail:(NSString*)email{
//    NSString *emailRegEx =
//    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
//    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
//    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
//    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
//    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
//    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
//    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
//    
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegEx];
//    return [emailTest evaluateWithObject:email];
//}

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

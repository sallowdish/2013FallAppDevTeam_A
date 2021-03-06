//
//  ProfilePageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-04.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "UserModel.h"
#import "ImageModel.h"
#import "ProgressHUD.h"
#import "popoverAlterModel.h"
#import "RNGridMenu.h"
#import "UpdateProfileTableViewController.h"

#undef MAXTAG
#define MAXTAG 103

@interface ProfilePageViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *needBorder;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray * needTransparent;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *needRoundCorner;
@property (weak, nonatomic) IBOutlet UIButton *updateProfilImageButton;
@property (strong,nonatomic) GKImagePicker* imagePicker;
@property (strong,nonatomic) NSMutableArray* selectedPhoto;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateButton;

@end

@implementation ProfilePageViewController

@synthesize selectedPhoto;

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
    
}

-(void)dataSourceSetup{
    //Data Setup
    if (self.targetUser) {
        self.userID=[self.targetUser[@"id"] integerValue];
    }
    if(self.userID){
        [UserModel getUserInfo:self.userID complete:^(NSDictionary *userInfo) {
            self.targetUser=[userInfo valueForKey:@"objects"][0];
            [self dateSourceToViewMatch];
        } fail:^(NSError *error) {
            [ProgressHUD showError:[NSString stringWithFormat:@"Fail to get user info. %@",[error localizedDescription]]];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [ProgressHUD showError:@"Fatal operation"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)visualSetup{
    // Visual Setup
//    [self navigationController].automaticallyAdjustsScrollViewInsets=YES;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height*1.35)];
    
    //Set transparent background
    for (UIView *view in self.needTransparent) {
        [view setBackgroundColor:[UIColor clearColor]];
    }
    
    //Set border
    for (UIView *view in self.needBorder) {
        view.layer.borderWidth=4;
        view.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    //Set round corner
    for (UIView *view in self.needRoundCorner) {
        view.layer.cornerRadius=6;
    }
    //set up log view individually
    [self.view viewWithTag:999].layer.borderWidth=2;
    [self drawShadowForView:[self.view viewWithTag:998]];
    
    //set up container for redheart image
    [self.view viewWithTag:997].layer.borderWidth=3;
    [self.view viewWithTag:997].layer.borderColor=[UIColor grayColor].CGColor;
    [self.view viewWithTag:997].layer.cornerRadius=15;
    [self.view viewWithTag:996].layer.cornerRadius=15;
    
    if (self.targetUser) {
        [self dateSourceToViewMatch];
    }
    
}

-(void)dateSourceToViewMatch{
    [UserModel getProfileImageWithUser:self.targetUser Sender:self.userProfileImage];
    self.username.text=[[self.targetUser valueForKey:@"user_nickname"] isEqualToString:@""]?[self.targetUser valueForKey:@"username"]:[self.targetUser valueForKey:@"user_nickname"];
    self.userLocation.text=[[self.targetUser valueForKey:@"user_location"] isEqualToString:@""]?@"Unknown":[self.targetUser valueForKey:@"user_location"];
    self.userLike.text=@"N/A";
    if ([(NSArray*)self.targetUser[@"user_tag"] count]>0) {
        NSArray* tags=(NSArray*)self.targetUser[@"user_tag"];
        self.userTag.text=[[tags valueForKey:@"description"] componentsJoinedByString:@", "];
    }
    else{
        self.userTag.text=@"Nothing Here";
    }
    
    self.userDescription.text=![self.targetUser[@"user_description"] isEqualToString:@""]?self.targetUser[@"user_description"]:@"Nothing here";
    self.userRecentActivity.text=@"Top Secret";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self visualSetup];
    [self dataSourceSetup];
    
    [self.scrollView removeFromSuperview];
    self.scrollView.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:self.scrollView];
    self.updateProfilImageButton.enabled=NO;
    self.updateProfilImageButton.alpha=0.4f;
    self.updateButton.enabled=NO;
    if ([UserModel isLogin]) {
        if ([[self.targetUser objectForKey:@"username"] isEqualToString:[UserModel username]]) {
            self.updateProfilImageButton.enabled=YES;
            self.updateProfilImageButton.alpha=1;
            self.updateButton.enabled=YES;
        }
    }
}
-(void)drawShadowForView:(UIView*)view{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowPath = shadowPath.CGPath;
}

-(IBAction)didTapUpdateProfileImageButton{
    self.selectedPhoto=[NSMutableArray arrayWithCapacity:0];
    self.imagePicker = [[GKImagePicker alloc] init];
    //    self.imagePicker.cropSize = CGSizeMake(320, 90);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
//    [self.navigationController pushViewController:self.imagePicker.imagePickerController animated:YES];
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    [selectedPhoto removeAllObjects];
    [selectedPhoto addObject:image];
    [self hideImagePicker];
    [self updateSelectedImage];
}

- (void)hideImagePicker{
    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [selectedPhoto addObject:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) updateSelectedImage{
    [ProgressHUD show:@"Upload new profile image..."];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateProfileImage) name:@"didUploadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailUpdateProfileImage) name:@"didFailUploadImage" object:nil];
    ImageModel* uploadModel=[[ImageModel alloc] init];
    [uploadModel uploadUserImage:selectedPhoto[0] Mode:1];
}

- (void)didUpdateProfileImage{
    [ProgressHUD dismiss];
    [popoverAlterModel alterWithTitle:@"Succeed" Message:@"Updating is done. Please login again to see the new profile image."];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)didFailUpdateProfileImage{
    [ProgressHUD dismiss];
    [popoverAlterModel alterWithTitle:@"Failed" Message:@"Updating failed. Please try again later."];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([[segue identifier] isEqualToString:@"ProfileToUpdate"]) {
//        UpdateProfileTableViewController* vc=(UpdateProfileTableViewController*)[segue destinationViewController];
//        vc.current_user=self.targetUser;
//    }else{
//        [super prepareForSegue:segue sender:sender];
//    }
//}

-(IBAction)updateBarButtonTapped:(id)sender{
    UpdateProfileTableViewController* vc=[[self.navigationController storyboard] instantiateViewControllerWithIdentifier:@"UpdatePage"];
    vc.current_user=self.targetUser;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

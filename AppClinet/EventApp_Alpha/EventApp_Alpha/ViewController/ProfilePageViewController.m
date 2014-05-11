//
//  ProfilePageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-04.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "UserModel.h"
#define MAXTAG 103

@interface ProfilePageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *needBorder;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray * needTransparent;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *needRoundCorner;

@end

@implementation ProfilePageViewController

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
    
    
    //Data Setup
    if (self.targetUser) {
        
        self.userProfileImage.image=[UserModel getProfileImageWithUser:self.targetUser];
        self.username.text=[self.targetUser objectForKey:@"username"];
        self.userLocation.text=@"Unknown";
        self.userLike.text=@"N/A";
        self.userTag.text=@"";
        self.userDescription.text=@"Top Secret";
        self.userRecentActivity.text=@"Top Secret";
    }
    
	// Visual Setup
    [self navigationController].automaticallyAdjustsScrollViewInsets=YES;
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
    
    
    
//    [self.scrollView removeFromSuperview];
//    self.scrollView.frame=CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
//    [self.view addSubview:self.scrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.scrollView removeFromSuperview];
    self.scrollView.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:self.scrollView];
}
-(void)drawShadowForView:(UIView*)view{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowPath = shadowPath.CGPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

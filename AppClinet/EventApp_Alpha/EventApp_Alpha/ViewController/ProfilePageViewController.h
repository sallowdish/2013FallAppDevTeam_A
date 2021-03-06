//
//  ProfilePageViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-04.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"

@interface ProfilePageViewController : UIViewController<GKImagePickerDelegate>
@property (strong,nonatomic) NSDictionary* targetUser;
@property (nonatomic) NSInteger userID;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userLocation;
@property (weak, nonatomic) IBOutlet UILabel *userLike;
@property (weak, nonatomic) IBOutlet UILabel *userTag;
@property (weak, nonatomic) IBOutlet UITextView *userDescription;
@property (weak, nonatomic) IBOutlet UITextView *userRecentActivity;

@end

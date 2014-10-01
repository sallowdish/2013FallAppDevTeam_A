//
//  UpdateProfileTableViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-09-08.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"

@interface UpdateProfileTableViewController : UITableViewController<GKImagePickerDelegate>
@property (strong,nonatomic) NSDictionary* current_user;

@end
//
//  EventDetailViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-11.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController
@property (nonatomic) NSInteger eventID;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;

@end

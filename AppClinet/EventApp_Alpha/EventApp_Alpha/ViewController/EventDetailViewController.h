//
//  EventDetailViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-11.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSInteger eventID;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *hoster;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *RSVP;
@property (weak, nonatomic) IBOutlet UILabel *like;
@property (weak, nonatomic) IBOutlet UIImageView *images;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
//@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end





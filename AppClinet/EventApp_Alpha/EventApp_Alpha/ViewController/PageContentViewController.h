//
//  PageContentViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/10/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventHosterLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventRSVPLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLikeLabel;
@property NSUInteger pageIndex,eventLike,eventRSVP,pageTotalCount;

@property NSString *eventTitle,*eventDate,*eventLocation,*eventHoster;
@property (strong,nonatomic) NSDictionary* event;
@property NSString *eventImage;


@end

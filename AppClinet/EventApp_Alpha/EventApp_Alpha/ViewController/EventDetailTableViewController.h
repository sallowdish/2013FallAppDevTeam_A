//
//  EventDetailTableViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-02.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventHoster;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *eventPlace;
@property (weak, nonatomic) IBOutlet UILabel *eventCapcity;
@property (strong,nonatomic) NSDictionary* event;
@property (nonatomic) NSInteger eventID;
@end

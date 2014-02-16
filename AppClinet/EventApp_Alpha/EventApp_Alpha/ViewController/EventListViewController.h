	//
//  EventTableViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-10.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : UITableViewController
@property (nonatomic,strong) NSArray* eventList;
-(IBAction)segementationButtonPressed:(id)sender;
@end

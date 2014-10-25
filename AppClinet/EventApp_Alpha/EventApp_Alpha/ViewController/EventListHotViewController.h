//
//  EventListHotViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-04.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventListFetchModel.h"


@interface EventListHotViewController : UITableViewController
@property (nonatomic,strong) NSArray* eventList;
@property (strong,nonatomic)EventListFetchModel* model;
@property (assign, nonatomic) BOOL isNeedRefresh;
@end

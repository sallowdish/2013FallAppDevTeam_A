//
//  RecommandContainerViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-28.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventListViewController.h"

@interface RecommandContainerViewController : UIViewController
@property NSInteger selectedSegmentIndex;
@property EventListViewController* previousViewController;
@end

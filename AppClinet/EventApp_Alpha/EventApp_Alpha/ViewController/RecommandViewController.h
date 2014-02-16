//
//  ViewController.h
//  BTGlassScrollViewExample
//
//  Created by Byte on 10/18/13.
//  Copyright (c) 2013 Byte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGlassScrollView.h"

@interface RecommandViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *eventList;
@property (strong, nonatomic) NSArray *eventImages;
-(IBAction)segementeationPressed:(id)sender;
@end

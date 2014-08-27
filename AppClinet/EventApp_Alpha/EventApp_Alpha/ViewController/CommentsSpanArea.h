//
//  CommentsSpanArea.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-08-22.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsSpanArea : UITableViewController
@property (weak,nonatomic) NSArray* comments;
@property (weak,nonatomic) NSDictionary* event;
-(void)passCommentsToDisplay;
@end

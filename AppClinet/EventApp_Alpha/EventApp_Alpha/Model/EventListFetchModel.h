//
//  EventListFetchModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-01.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListViewController.h"

#import <Foundation/Foundation.h>
#import "DataTransferModel.h"

@interface EventListFetchModel : DataTransferModel

+(NSArray*)eventsList;
-(void) fetchEventListWithMode:(NSString*) mode;
-(void) fetchEventListFromFile;
-(void) fetchEventListWithUser;
-(void) fetchNextPage:(id)table;
//-(UIImage*)fetchProfileImageForUser:(NSDictionary*) user;
@end

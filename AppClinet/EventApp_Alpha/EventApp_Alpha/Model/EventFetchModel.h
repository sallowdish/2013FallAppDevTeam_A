//
//  EventFetchModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-02.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataTransferModel.h"
@interface EventFetchModel : DataTransferModel
@property NSDictionary* event;
-(void) fetchEventWithEventID:(NSInteger)EventID;
@end

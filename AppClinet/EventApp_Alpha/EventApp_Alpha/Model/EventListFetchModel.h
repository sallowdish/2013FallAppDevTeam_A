//
//  EventListFetchModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-01.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventListFetchModel : NSObject

+(NSArray*)eventsList;
-(void) fetchEventListWithMode:(NSString*) mode;
-(void) fetchEventListFromFile;
@end

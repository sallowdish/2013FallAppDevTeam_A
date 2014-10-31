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
+(NSString*)nextPage;
-(void) fetchEventListWithMode:(NSString*) mode;
-(void) fetchEventListFromFile;
-(void) fetchEventListWithUser;
-(void) fetchNextPage:(id)blank complete:(void(^)(void))completeBlock fail:(void(^)(NSError* error))failBlock;
-(void) fetchEventListByUsername:(NSString*)username complete:(void(^)(void))completeBlock;
-(void) fetchRecommendEvents:(void(^)(void))completeBlock;
@end

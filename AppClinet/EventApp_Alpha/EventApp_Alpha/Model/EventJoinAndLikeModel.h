//
//  EventJoinAndLikeModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface EventJoinAndLikeModel : DataTransferModel
-(void)joinEvent:(NSDictionary*)event;
-(void)quitEvent:(NSDictionary*)event;
-(void)likeEvent:(NSDictionary*)event;
-(void)dislikeEvent:(NSDictionary*)event;
@end

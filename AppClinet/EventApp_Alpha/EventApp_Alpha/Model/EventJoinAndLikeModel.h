//
//  EventJoinAndLikeModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "URLConstructModel.h"
#import "EventDetailViewController.h"


@interface EventJoinAndLikeModel :URLConstructModel
@property NSDictionary* json; //RSVPCount,likeCount;
-(void)rsvpEvent:(NSDictionary*)event succeed:(SucceeHandleBlock)succeedBlock failed:(FailureHandleBlock)failedBlock;
-(void)quitEvent:(NSDictionary*)event :(EventDetailViewController*)sender;
-(void)likeEvent:(NSDictionary*)event succeed:(SucceeHandleBlock)succeedBlock failed:(FailureHandleBlock)failedBlock;
-(void)dislikeEvent:(NSDictionary*)event :(EventDetailViewController*)sender;
-(void)getRSVPList:(NSDictionary*)event;
-(void)getLikeList:(NSDictionary*)event complete:(void (^)(void))completeBlock fail:(void (^)(NSError* error))failBlock;


-(BOOL)isCurrentUserinRSVPList;
-(BOOL)isCurrentUserinLikeList;


//class methods
+(NSMutableArray*)RSVPList;

+(void)setRSVPList:(NSMutableArray*)value;

+(NSMutableArray*)LikeList;

+(void)setLikeList:(NSMutableArray*)value;

@end

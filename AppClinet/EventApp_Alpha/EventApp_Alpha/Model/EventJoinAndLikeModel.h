//
//  EventJoinAndLikeModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "URLConstructModel.h"


@interface EventJoinAndLikeModel :URLConstructModel
@property NSDictionary* json; //RSVPCount,likeCount;
-(void)rsvpEvent:(NSDictionary*)event;
-(void)quitEvent:(NSDictionary*)event;
-(void)likeEvent:(NSDictionary*)event;
-(void)dislikeEvent:(NSDictionary*)event;
-(void)getRSVPList:(NSDictionary*)event;
-(void)getLikeList:(NSDictionary*)event;

//class methods
+(NSMutableArray*)RSVPList;

+(void)setRSVPList:(NSMutableArray*)value;

+(NSMutableArray*)LikeList;

+(void)setLikeList:(NSMutableArray*)value;

@end

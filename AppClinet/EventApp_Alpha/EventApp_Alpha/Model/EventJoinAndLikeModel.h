//
//  EventJoinAndLikeModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface EventJoinAndLikeModel : DataTransferModel
@property NSDictionary* json; //RSVPCount,likeCount;
-(void)rsvpEvent:(NSDictionary*)event;
-(void)quitEvent:(NSDictionary*)event;
-(void)likeEvent:(NSDictionary*)event;
-(void)dislikeEvent:(NSDictionary*)event;
-(void)countRSVP:(NSDictionary*)event;
-(void)countLike:(NSDictionary*)event;
@end


@interface RSVPAndLikeConnect: NSURLConnection
@property BOOL isRSVP,isLike,isCountingRSVP,isCountingLike;
+(RSVPAndLikeConnect*) connectionWithRequest:(NSURLRequest*)request delegate:(id) delegate;
@end
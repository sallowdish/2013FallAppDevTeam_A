//
//  EventJoinAndLikeModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventJoinAndLikeModel.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "EventDetailViewController.h"


@implementation EventJoinAndLikeModel
static  NSMutableArray* RSVPList;
static  NSMutableArray* LikeList;

+(NSMutableArray*)RSVPList{
    if (RSVPList==nil) {
        RSVPList=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return RSVPList;
}

+(void)setRSVPList:(NSMutableArray*)value{
    RSVPList=[value copy];
}


+(NSMutableArray*)LikeList{
    if (LikeList==nil) {
        LikeList=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return LikeList;
}

+(void)setLikeList:(NSMutableArray*)value{
    LikeList=[value copy];
}


-(void)getRSVPList:(NSDictionary*)event
{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    NSString *targetURL=[[[[self class] constructURLHeader] absoluteString] stringByAppendingFormat:@"%@%@%@%@%@",API,@"/eventrsvp/?",JSONFORMAT,@"&fk_event=",[event valueForKey:@"id"]];
    [manager GET:targetURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonDict=responseObject;
        [EventJoinAndLikeModel setRSVPList:[jsonDict valueForKey:@"objects"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didGetRSVPList" object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailGetRSVPList" object:nil];
    }];
}
-(void)getLikeList:(NSDictionary*)event{}
-(void)rsvpEvent:(NSDictionary*)event{

}
-(void)quitEvent:(NSDictionary*)event{}
-(void)likeEvent:(NSDictionary*)event{
}
-(void)dislikeEvent:(NSDictionary*)event{

}



@end

//@implementation RSVPAndLikeConnect
//
//+(RSVPAndLikeConnect*) connectionWithRequest:(NSURLRequest*)request delegate:(id) delegate{
////    [NSURLConnection connectionWithRequest:<#(NSURLRequest *)#> delegate:<#(id)#>]
//    return (RSVPAndLikeConnect*)[super connectionWithRequest:request delegate:delegate];
//}
//
//@end



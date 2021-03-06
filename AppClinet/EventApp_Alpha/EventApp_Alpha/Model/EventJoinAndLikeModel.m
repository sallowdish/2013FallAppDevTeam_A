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
-(void)getLikeList:(NSDictionary*)event complete:(void (^)(void))completeBlock fail:(void (^)(NSError* error))failBlock{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    NSString *targetURL=[[[[self class] constructURLHeader] absoluteString] stringByAppendingFormat:@"%@%@%@%@%@",API,@"/eventlike/?",JSONFORMAT,@"&fk_event=",[event valueForKey:@"id"]];
    [manager GET:targetURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LikeList=[responseObject valueForKey:@"objects"];
        completeBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}

-(void)rsvpEvent:(NSDictionary*)event succeed:(SucceeHandleBlock)succeedBlock failed:(FailureHandleBlock)failedBlock{
    if ([UserModel isLogin]) {
        NSString* targetURL=[[[URLConstructModel constructURLHeader] absoluteString] stringByAppendingFormat:@"%@%@",API,@"/eventrsvp/"];
        
        NSDictionary* para=@{@"fk_user":[UserModel userResourceURL], @"fk_event":[event valueForKey:@"resource_uri"]};
        AFHTTPRequestOperationManager* manager=[URLConstructModel authorizedJsonManger];
        [manager POST:targetURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                succeedBlock(nil);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failedBlock(error);
            });
        }];

    }
}
-(void)quitEvent:(NSDictionary*)event :(EventDetailViewController*)sender{}
-(void)likeEvent:(NSDictionary*)event succeed:(SucceeHandleBlock)succeedBlock failed:(FailureHandleBlock)failedBlock{
    if ([UserModel isLogin]) {
        NSString* targetURL=[[[URLConstructModel constructURLHeader] absoluteString] stringByAppendingFormat:@"%@%@",API,@"/eventlike/"];
        
        NSDictionary* para=@{@"fk_user":[UserModel userResourceURL], @"fk_event":[event valueForKey:@"resource_uri"]};
        AFHTTPRequestOperationManager* manager=[URLConstructModel authorizedJsonManger];
        [manager POST:targetURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                succeedBlock(nil);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failedBlock(error);
            });
        }];
    }
}
-(void)dislikeEvent:(NSDictionary*)event :(EventDetailViewController*)sender{

}

-(BOOL)isCurrentUserinRSVPList{
    for (NSDictionary* record in RSVPList) {
        NSString* resourceURL=[[record valueForKey:@"fk_user"] valueForKey:@"resource_uri"];
        if ([[UserModel userResourceURL] isEqualToString:resourceURL]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isCurrentUserinLikeList{
    for (NSDictionary* record in LikeList) {
        NSString* resourceURL=[[record valueForKey:@"fk_user"] valueForKey:@"resource_uri"];
        if ([[UserModel userResourceURL] isEqualToString:resourceURL]) {
            return YES;
        }
    }
    return NO;
}


@end





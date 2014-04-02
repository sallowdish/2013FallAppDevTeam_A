//
//  EventJoinAndLikeModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventJoinAndLikeModel.h"
#import "UserModel.h"

@implementation EventJoinAndLikeModel
-(void)joinEvent:(NSDictionary*)event{}
-(void)quitEvent:(NSDictionary*)event{}
-(void)likeEvent:(NSDictionary*)event{
    NSInteger currentlike=[[event objectForKey:@"event_like"] integerValue];
    currentlike+=1;
    NSDictionary* dic=[NSDictionary dictionaryWithObjects:@[@(currentlike)] forKeys:@[@"event_like"]];
    [self patchDate:dic toEvent:event];
}
-(void)dislikeEvent:(NSDictionary*)event{
    NSInteger currentlike=[[event objectForKey:@"event_like"] integerValue];
    currentlike-=1;
    NSDictionary* dic=[NSDictionary dictionaryWithObjects:@[@(currentlike)] forKeys:@[@"event_like"]];
    [self patchDate:dic toEvent:event];
    
}

-(void)patchDate:(NSDictionary*)dic toEvent:(NSDictionary*)event{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,API,@"/event/",[event objectForKey:@"id"],@"/?username=",[UserModel username],@"&api_key=",[UserModel userAPIKey]]];
    NSData* json=[self jsonFromDictionary:dic];
    [super patchData:json WithURL:url];
}
     
-(NSData*)jsonFromDictionary:(NSDictionary*)dic{
    NSData* json=nil;
    NSError* error=nil;
    @try {
        json=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            json=nil;
            @throw [NSException exceptionWithName:@"Fail" reason:@"Fail to serialize patch data" userInfo:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    @finally {
        return json;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ( [(NSHTTPURLResponse*)response statusCode]!= 202) {
        @throw [NSException exceptionWithName:@"Fail" reason:@"Fail to patch data" userInfo:nil];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didPatchDataWithEventID" object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

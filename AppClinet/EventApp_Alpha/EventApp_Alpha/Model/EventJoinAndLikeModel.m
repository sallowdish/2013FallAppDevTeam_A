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

bool isRSVP,isLike,isCountingRSVP,isCountingLike;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    if (self.data) {
        self.json=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    }
    if (isCountingLike) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishCountingLike" object:nil];
        isCountingLike=false;
    }
    else if(isCountingRSVP){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishCountingRSVP" object:nil];
        isCountingRSVP=false;
    }
//    else if (isLike) {
//        isLike=false;
//    }else if (isRSVP){
//        isRSVP=false;
//    }
//    isRSVP=isLike=isCountingLike=isCountingRSVP=false;
    
}


-(void)countRSVP:(NSDictionary*)event{
    isCountingRSVP=true;
    NSURL* url=[[self class] constructRequestWithResource:@"/eventrsvp"];
    url=[NSURL URLWithString:[[url absoluteString ] stringByAppendingString:[NSString stringWithFormat:@"/?%@&fk_event=%@",JSONFORMAT,[event objectForKey:@"id"]]]];
//    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
//    [NSURLConnection connectionWithRequest:<#(NSURLRequest *)#> delegate:<#(id)#>]
//    RSVPAndLikeConnect* conn=[RSVPAndLikeConnect connectionWithRequest:[self configGetRequest:request] delegate:self];
//    if (conn) {
//        conn.isCountingRSVP=true;
//        [self prepareForConnection];
//        [conn start];
//    }
    [self fetchDataWithUrl:url];
}

-(void)countLike:(NSDictionary*)event{
    isCountingLike=true;
    NSURL* url=[[self class] constructRequestWithResource:@"/eventlike"];
    url=[NSURL URLWithString:[[url absoluteString ] stringByAppendingString:[NSString stringWithFormat:@"/?%@&fk_event=%@",JSONFORMAT,[event objectForKey:@"id"]]]];
    [self fetchDataWithUrl:url];
}

-(void)rsvpEvent:(NSDictionary*)event{
    isRSVP=true;
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:@[[event objectForKey:@"resource_uri"],[UserModel userResourceURL]] forKeys:@[@"fk_event",@"fk_user"]];
    NSURL* url=[[self class] constructRequestWithResource:@"/eventrsvp"];
    url=[NSURL URLWithString:[[url absoluteString] stringByAppendingString:[NSString stringWithFormat:@"/?username=%@&api_key=%@",[UserModel username],[UserModel userAPIKey]]]];
    
    [self postData:[self jsonFromDictionary:dic] WithUrl:url];

}
-(void)quitEvent:(NSDictionary*)event{}
-(void)likeEvent:(NSDictionary*)event{
    isLike=true;
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:@[[event objectForKey:@"resource_uri"],[UserModel userResourceURL]] forKeys:@[@"fk_event",@"fk_user"]];
    NSURL* url=[[self class] constructRequestWithResource:@"/eventlike"];
    url=[NSURL URLWithString:[[url absoluteString] stringByAppendingString:[NSString stringWithFormat:@"/?username=%@&api_key=%@",[UserModel username],[UserModel userAPIKey]]]];
    
    [self postData:[self jsonFromDictionary:dic] WithUrl:url];
}
-(void)dislikeEvent:(NSDictionary*)event{
//    NSInteger currentlike=[[event objectForKey:@"event_like"] integerValue];
//    currentlike-=1;
//    NSDictionary* dic=[NSDictionary dictionaryWithObjects:@[@(currentlike)] forKeys:@[@"event_like"]];
//    [self patchDate:dic toEvent:event];
}

//-(void)patchDate:(NSDictionary*)dic toEvent:(NSDictionary*)event{
//    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/event/",[event objectForKey:@"id"],@"/?username=",[UserModel username],@"&api_key=",[UserModel userAPIKey]]];
//    NSData* json=[self jsonFromDictionary:dic];
//    [super patchData:json WithURL:url];
//}

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
    if (isRSVP) {
        if ( [(NSHTTPURLResponse*)response statusCode]!= 201) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didRSVPEventFailed" object:nil];
            self.receivedData=nil;
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didRSVPEvent" object:nil];
        
        }
        isRSVP=false;

    }
    else if (isLike)
    {
        if ( [(NSHTTPURLResponse*)response statusCode]!= 201) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didLikeEventFailed" object:nil];
            self.receivedData=nil;
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didLikeEvent" object:nil];
            
        }
        isLike=false;
    }
    else if (isCountingLike)
    {
        if ( [(NSHTTPURLResponse*)response statusCode]!= 200) {
            self.receivedData=nil;
        }
    }
    else if (isCountingRSVP)
    {
        if ( [(NSHTTPURLResponse*)response statusCode]!= 200) {
            self.receivedData=nil;
        }
    }
    
}
@end

@implementation RSVPAndLikeConnect

+(RSVPAndLikeConnect*) connectionWithRequest:(NSURLRequest*)request delegate:(id) delegate{
//    [NSURLConnection connectionWithRequest:<#(NSURLRequest *)#> delegate:<#(id)#>]
    return [super connectionWithRequest:request delegate:delegate];
}

@end



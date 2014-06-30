//
//  EventDeleteModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-05-10.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventDeleteModel.h"
#import "UserModel.h"

@implementation EventDeleteModel
-(void) deleteEvent:(NSDictionary*)event{
    @try {
        NSURL* targetUrl=[DataTransferModel constructRequestWithResource:@"/event"];
        targetUrl=[NSURL URLWithString:[[targetUrl absoluteString] stringByAppendingString:[NSString stringWithFormat:@"/%@/?format=json&username=%@&api_key=%@",[event objectForKey:@"id"],[UserModel username],[UserModel userAPIKey]]]];
        NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:targetUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"DELETE"];
        [self fetchData:request];
    }
    @catch (NSException *exception) {
        NSLog(@"Delete Failed");
        @throw exception;
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    [super connection:connection didReceiveResponse:response];
    NSHTTPURLResponse* rsp=(NSHTTPURLResponse*)response;
    
    if (rsp.statusCode==204) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didDeleteEvent" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailedDeleteEvent" object:nil];
    }
}
@end

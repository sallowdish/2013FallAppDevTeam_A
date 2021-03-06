//
//  SignUpModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-27.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "SignUpModel.h"

@implementation SignUpModel

bool isFailed=NO;

-(void)signUp:(NSDictionary *)info{
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/user/"]];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self configPostRequest:request withData:[NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil]];
    NSURLConnection* conn=[NSURLConnection connectionWithRequest:request delegate:self];
    self.receivedData=[NSMutableData dataWithCapacity:0];
    isFailed=NO;
    if (conn) {
        [conn start];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if([(NSHTTPURLResponse*)response statusCode]!=201)
    {
//        self.receivedData=nil;
        isFailed=YES;
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSignUp" object:nil];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    if (isFailed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailSignUp" object:self.data];
    }
    
}
@end

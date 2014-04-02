//
//  loginModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "LoginModel.h"
#import "AppDelegate.h"
@implementation LoginModel

-(void)loginWithUsername:(NSString*)username AndPassword:(NSString*) password{
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@:%@@%@%@%@%@", HTTPPREFIX, username,password,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/token/1/"]];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection* conn=[NSURLConnection connectionWithRequest:request delegate:self];
    self.receivedData=[NSMutableData dataWithCapacity:0];
    if (conn) {
        [conn start];
    }
}

-(void)logoutCurrentUser{
    
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if([(NSHTTPURLResponse*)response statusCode]!=200)
    {
        self.receivedData=nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"failToLogin" object:nil];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    
    if (self.data) {
        self.jsonInfo=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    }
}



@end

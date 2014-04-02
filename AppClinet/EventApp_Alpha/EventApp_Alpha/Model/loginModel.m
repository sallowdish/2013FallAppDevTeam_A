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

NSString* current_username;

-(void)loginWithUsername:(NSString*)username AndPassword:(NSString*) password{
    current_username=username;
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@:%@@%@%@%@", HTTPPREFIX, username,password,WEBSERVICEDOMAIN,API,@"/token/1/"]];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection* conn=[NSURLConnection connectionWithRequest:request delegate:self];
    if (conn) {
        [conn start];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if([(NSHTTPURLResponse*)response statusCode]!=200)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"failToLogin" object:nil];
        self.data=nil;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    
    if (self.data) {
        NSDictionary* json=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
        NSString* apikey=[json objectForKey:@"key"];
        [AppDelegate updateUserInfoWithUsername:current_username API_KEY:apikey Resource:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didLogin" object:nil];
    }
   
    
}
-(void)logoutCurrentUser{
    [AppDelegate cleanUpUserInfo];
    current_username=nil;
}
@end

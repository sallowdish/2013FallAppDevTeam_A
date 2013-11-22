//
//  EventPostModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-21.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventPostModel.h"

@implementation EventPostModel
-(bool)postEventWithRequest:(NSMutableURLRequest*)request{
    NSURLConnection* conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn)
        NSLog(@"conn set up successfully.");
    else
        NSLog(@"failed to set up.");
    //[conn start];
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSURLResponse *res=response;
    NSLog(@"%@",@"get a respond.");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}


@end

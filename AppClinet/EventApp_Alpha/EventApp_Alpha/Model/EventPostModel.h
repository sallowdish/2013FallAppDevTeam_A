//
//  EventPostModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-21.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "WebServiceCommunicationModel.h"

@interface EventPostModel : WebServiceCommunicationModel <NSURLConnectionDataDelegate>
-(bool)postEventWithRequest:(NSMutableURLRequest*)request;

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection
didFailWithError:(NSError *)error;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
@end
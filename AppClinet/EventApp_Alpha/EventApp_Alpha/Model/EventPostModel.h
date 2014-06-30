//
//  EventPostModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/22/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

<<<<<<< HEAD
#import "URLConstructModel.h"

@interface EventPostModel : URLConstructModel <NSURLConnectionDataDelegate>
-(bool)postEventWithRequest:(NSMutableURLRequest*)request;

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection
didFailWithError:(NSError *)error;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
@end
=======
#import "DataTransferModel.h"

@interface EventPostModel : DataTransferModel
-(void)postEventwithInfo:(NSMutableDictionary*)info;
-(void)postAddresswithInfo:(NSDictionary*)info;
@end
>>>>>>> Developing-Base-on-WS

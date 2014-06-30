//
//  DataTransferModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 1/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "URLConstructModel.h"

<<<<<<< HEAD
@interface DataTransferModel : URLConstructModel <NSURLConnectionDataDelegate>
@property NSData* data;

-(void)fetchDataWithUrl:(NSURL*)url;
=======
@interface DataTransferModel : URLConstructModel<NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSData* data;
@property (strong, nonatomic) NSMutableData* receivedData;
@property id externalDelegate;

-(void)prepareForConnection;
-(void)fetchDataWithUrl:(NSURL*)url;
-(void)fetchData:(NSURLRequest*)request;
-(void)postData:(NSData*)data WithUrl:(NSURL *)url;
-(void)patchData:(NSData*)data WithURL:(NSURL*)url;
-(NSMutableURLRequest*)configPostRequest:(NSMutableURLRequest*)request withData:(NSData*)data;
-(NSMutableURLRequest*)configPatchRequest:(NSMutableURLRequest*)request withData:(NSData*)data;
-(NSMutableURLRequest*)configGetRequest:(NSMutableURLRequest*)request;
>>>>>>> Developing-Base-on-WS
@end

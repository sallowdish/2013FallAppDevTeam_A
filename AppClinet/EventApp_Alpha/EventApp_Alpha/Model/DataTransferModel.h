//
//  DataTransferModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 1/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "URLConstructModel.h"

@interface DataTransferModel : URLConstructModel<NSURLConnectionDataDelegate>
@property NSData* data;
@property id externalDelegate;

-(void)fetchDataWithUrl:(NSURL*)url;
-(void)postData:(NSData*)data WithUrl:(NSURL *)url;
@end

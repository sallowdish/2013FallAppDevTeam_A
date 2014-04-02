//
//  DataTransferModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 1/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"
#import "popoverAlterModel.h"
NSError* error;


@implementation DataTransferModel
@synthesize receivedData;
-(void)fetchDataWithUrl:(NSURL*)url{
    //NSData* result;
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    receivedData=[NSMutableData dataWithCapacity:0];
//    NSURLResponse* response;
    NSURLConnection* conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!conn) {
        receivedData=nil;
    }
    else{
        [conn start];
    }
}

-(void)postData:(NSData*)data WithUrl:(NSURL *)url{
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    @try {
        request=[self configPostRequest:request withData:data];
        NSURLConnection* conn=[[NSURLConnection alloc] initWithRequest:request delegate:self.externalDelegate];
        [conn start];

        
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Fail" message:exception.name delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    @finally {
        
    }
}

-(void)patchData:(NSData*)data WithURL:(NSURL*)url{
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    @try {
        request=[self configPatchRequest:request withData:data];
        NSURLConnection* conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (!conn) {
            receivedData=nil;
        }
        else{
            [conn start];
        }
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Fail" message:exception.name delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    @finally {
        
    }
}

-(NSMutableURLRequest*)configPatchRequest:(NSMutableURLRequest*)request withData:(NSData*)data{
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PATCH"];
    [request setHTTPBody:data];
    return request;
}


-(NSMutableURLRequest*)configPostRequest:(NSMutableURLRequest*)request withData:(NSData*)data{
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response.MIMEType isEqualToString:@"application/json"])
    {
        [receivedData setLength:0];
    }else{
        receivedData=nil;
        @throw [NSException exceptionWithName:@"Fetch Json data Failed" reason:error.localizedDescription userInfo:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    if (receivedData) {
        [receivedData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    
    // release the connection, and the data object
    self.data=receivedData;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishLoadingData" object:self.data];
}

-(void)prepareForConnection{
    self.receivedData=[NSMutableData dataWithCapacity:0];
}

@end

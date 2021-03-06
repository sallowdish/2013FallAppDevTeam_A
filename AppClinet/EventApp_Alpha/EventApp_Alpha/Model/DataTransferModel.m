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
//    NSURLResponse* response;
    NSURLConnection* conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!conn) {
        receivedData=nil;
    }
    else{
        [self prepareForConnection];
        [conn start];
    }
}

-(void)fetchData:(NSURLRequest*)request{
    //NSData* result;
    NSURLConnection* conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!conn) {
        receivedData=nil;
    }
    else{
        [self prepareForConnection];
        [conn start];
    }
}

-(void)postData:(NSData*)data WithUrl:(NSURL *)url{
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    @try {
        request=[self configPostRequest:request withData:data];
        NSURLConnection* conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [self prepareForConnection];
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
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PATCH"];
    [request setHTTPBody:data];
    return request;
}


-(NSMutableURLRequest*)configPostRequest:(NSMutableURLRequest*)request withData:(NSData*)data{
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    return request;
}

-(NSMutableURLRequest*)configGetRequest:(NSMutableURLRequest*)request{
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response.MIMEType isEqualToString:@"application/json"])
    {
        [receivedData setLength:0];
    }else{
        receivedData=nil;
        NSLog(@"Fetch Json data Failed");
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

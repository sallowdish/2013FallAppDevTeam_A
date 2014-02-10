//
//  DataTransferModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 1/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"
#import "popoverAlterModel.h"

@implementation DataTransferModel
-(void)fetchDataWithUrl:(NSURL*)url{
    //NSData* result;
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError* error;
    //NSURLConnection* conn=[[NSURLConnection alloc] init];
    NSData* incomingBuffer=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        @throw [NSException exceptionWithName:@"Connection set up failed." reason:nil userInfo:nil];
    }
    else if ([response.MIMEType isEqualToString:@"application/json"])
    {
//        NSLog(@"%@",response);
//        NSLog(@"%@",[[NSString alloc]initWithData:incomingBuffer encoding:NSUTF8StringEncoding]);
        self.data=incomingBuffer;
    }else
    {
        @throw [NSException exceptionWithName:@"Connection set up failed." reason:nil userInfo:nil];
    }
    
}

-(void)postDataWithUrl:(NSURL *)url{
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError* error;
    //NSURLConnection* conn=[[NSURLConnection alloc] init];
    NSData* incomingBuffer=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        @throw [NSException exceptionWithName:@"Connection set up failed." reason:nil userInfo:nil];
    }
    else if ([response.MIMEType isEqualToString:@"application/json"])
    {
        //        NSLog(@"%@",response);
        //        NSLog(@"%@",[[NSString alloc]initWithData:incomingBuffer encoding:NSUTF8StringEncoding]);
        self.data=incomingBuffer;
    }else
    {
        @throw [NSException exceptionWithName:@"Connection set up failed." reason:nil userInfo:nil];
    }
    
}
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSLog(@"%@",response);
    }
}

//-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
//    if ()
//    {
//        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        
//        //You've got all the data now
//        //Do something with your response string
//        
//        
//        //[responseString release];
//    }
//}
@end

//
//  EventPostModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/22/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventPostModel.h"
#import "UserModel.h"

#define REFERR "http://www.machoapes.com/app_project/api/v01/event/?"


@implementation EventPostModel
bool isSendingAddress,isSendingEvent;

-(void)postEventwithInfo:(NSMutableDictionary*)info{
    [info setValue:[UserModel userResourceURL] forKey:@"fk_event_poster_user"];
    [info setValue:@"/app_project/api/v01/address/2/" forKey:@"fk_address"];
    NSURL* targetURL=[[self class] constructEventPostURLwithUsername:[UserModel username] andKey:[UserModel userAPIKey]];
    isSendingEvent=true;
    @try {
        NSError* err;
        NSData* data=[NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&err];
        NSString *jsonString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
//        data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (err) {
            @throw [NSException exceptionWithName:@"Failed" reason:@"Serialization Failed" userInfo:nil];
        }
        [self postData:data WithUrl:targetURL];
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Failed" message:exception.reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    @finally {
        
    }
}

-(void)postAddresswithInfo:(NSDictionary *)info{
    NSError* error;
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithDictionary:info];
    [dic setObject:[UserModel userResourceURL] forKey:@"fk_user"];
    isSendingAddress=true;
    @try {
        NSData* json=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            @throw [NSException exceptionWithName:@"Failed" reason:@"Fail to serialize address info." userInfo:nil];
        }
        NSURL* url=[[self class] constructRequestWithResource:@"/address"];
        url=[NSURL URLWithString:[[url absoluteString] stringByAppendingString:[NSString stringWithFormat:@"/?username=%@&api_key=%@",[UserModel username],[UserModel userAPIKey]]]];
        
        NSMutableURLRequest* request=[self configPostRequest:[NSMutableURLRequest requestWithURL:url] withData:json];
        NSURLConnection* conn=[NSURLConnection connectionWithRequest:request delegate:self];
        if (conn) {
            [self prepareForConnection];
            [conn start];
        }
        else{
            @throw [NSException exceptionWithName:@"Failed" reason:@"Fail to send address info." userInfo:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if ([(NSHTTPURLResponse*)response statusCode]!=201) {
        self.receivedData=nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostNewAddressFailed" object:nil];
    }
    else{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostNewAddress" object:[[(NSHTTPURLResponse*)response allHeaderFields] objectForKey:@"Location"]];
         }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    if (isSendingAddress) {
        isSendingAddress=NO;
    }
    else if (isSendingEvent) {
        isSendingEvent=NO;
    }
}
@end

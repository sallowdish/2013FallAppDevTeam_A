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
-(void)postEventwithInfo:(NSMutableDictionary*)info{
    [info setValue:[UserModel userResourceURL] forKey:@"fk_event_poster_user"];
    [info setValue:@"/app_project/api/v01/address/2/" forKey:@"fk_address"];
    NSURL* targetURL=[[self class] constructEventPostURLwithUsername:[UserModel username] andKey:[UserModel userAPIKey]];
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
@end

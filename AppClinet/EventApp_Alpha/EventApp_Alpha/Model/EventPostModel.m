//
//  EventPostModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/22/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventPostModel.h"
#import "AppDelegate.h"

#define REFERR "http://www.machoapes.com/app_project/api/v01/event/?"


@implementation EventPostModel
-(void)postEventwithInfo:(NSMutableDictionary*)info{
    [info setValue:[AppDelegate userUrl] forKey:@"fk_event_poster_user"];
    [info setValue:@"/app_project/api/v01/address/2/" forKey:@"fk_address"];
    NSURL* targetURL=[[self class] constructEventPostURLwithUsername:[AppDelegate username] andKey:[AppDelegate userApikey]];
    @try {
        NSError* err;
        NSData* data=[NSJSONSerialization dataWithJSONObject:info options:nil error:&err];
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

//
//  EventFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-02.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventFetchModel.h"

@implementation EventFetchModel
+(void) fetchEventWithEventID:(NSInteger)eventID Error: (NSError*)error
{
    
    NSString* buffer=[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.sfu.ca/~rza31/%ld.json",(long)eventID]] encoding:NSUTF8StringEncoding error:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        exit(0);
    }
    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EventDetails.json"];
    
    [buffer writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        exit(0);
    }
    else
        NSLog(@"%@",buffer);
}@end

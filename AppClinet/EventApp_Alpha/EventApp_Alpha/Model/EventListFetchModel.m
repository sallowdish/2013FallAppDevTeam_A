//
//  EventListFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-01.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListFetchModel.h"

@implementation EventListFetchModel
+(void) fetchEventList :(NSError*)error
{
    
    NSString* buffer=[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.sfu.ca/~rza31/Events.json"] encoding:NSUTF8StringEncoding error:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        exit(0);
    }
    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Events.json"];

    [buffer writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        exit(0);
    }
    else
        NSLog(@"%@",buffer);
}
@end

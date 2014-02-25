//
//  EventFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-02.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventFetchModel.h"

@implementation EventFetchModel
-(void) fetchEventWithEventID:(NSInteger)eventID
{
    NSError* error;
    NSURL* url=[[self class] constructFetchRequestWithResource:[NSString stringWithFormat:@"%@%ld/",@"/event/",(long)eventID] WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT];
    [self fetchDataWithUrl:url];
    if (!self.data) {
        @throw [NSException exceptionWithName:@"Failed" reason:@"Fetching the event detail failed." userInfo:nil];
    }
    NSDictionary *rawData=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&error];
    if(error||[NSJSONSerialization isValidJSONObject:rawData]==NO)
    {
        @throw [NSException exceptionWithName:@"Failed" reason:@"Serializtion failed!" userInfo:nil];
    }
    self.event=rawData;
//    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EventDetails.json"];
//    
//    [buffer writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    if(error)
//    {
//        NSLog(@"%@",[error localizedDescription]);
//        exit(0);
//    }
}

@end

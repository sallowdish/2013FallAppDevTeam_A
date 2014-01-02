//
//  EventListFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-01.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListFetchModel.h"
#import "WebServiceCommunicationModel.h"


@implementation EventListFetchModel

static NSArray* eventList;

+(NSArray*)eventsList{
    if (eventList==nil) {
        eventList=[[NSArray alloc] init];
    }
    return eventList;
}

+(void)setEventsList:(NSArray*)value{
    eventList=[value copy];
}

-(void) fetchEventList
{
    @try {
        NSError* error=nil;
        //get the json of eventlist from webservice
        NSData* buffer=[NSData dataWithContentsOfURL:[WebServiceCommunicationModel constructRequestWithResource:@"/Event/"] options:NSDataReadingMappedIfSafe error:&error];
        if(error)
        {
            @throw [NSException exceptionWithName:@"Fetching Failed" reason:error.localizedDescription userInfo:nil];
        }
        
        //Pharse the data
        NSArray* rawData=[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&error];
        if(error)
        {
            @throw [NSException exceptionWithName:@"Pharse Failed" reason:error.localizedDescription userInfo:nil];
        }
        eventList=[NSArray arrayWithArray:rawData];
        // TODO: write into local file
        if ([NSJSONSerialization isValidJSONObject:eventList]) {
            NSString *jsonContent=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:eventList options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
            NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Events.json"];
            
            [jsonContent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if(error)
            {
                @throw [NSException exceptionWithName:@"Write into file Failed" reason:error.localizedDescription userInfo:nil];
            }
            else
                NSLog(@"%@",jsonContent);

        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
    }
}

-(void) fetchEventListFromFile:(NSString*) filename
{
    @try {
        NSError* error=nil;
        //get the json of eventlist from webservice
//        NSData* buffer=[NSData dataWithContentsOfFile:filename];
        NSData* buffer=[NSData dataWithContentsOfFile:filename options:NSDataReadingUncached error:&error];
        if(error)
        {
            @throw [NSException exceptionWithName:@"Fetching Failed" reason:error.localizedDescription userInfo:nil];
        }
        
        //Pharse the data
        NSDictionary* rawData=[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&error];
        if(error)
        {
            @throw [NSException exceptionWithName:@"Pharse Failed" reason:error.localizedDescription userInfo:nil];
        }
        eventList=[NSArray arrayWithArray:[rawData valueForKey:@"objects"]];
        // TODO: write into local file
        if ([NSJSONSerialization isValidJSONObject:eventList]) {
            NSString *jsonContent=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:eventList options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
            NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Events.json"];
            
            [jsonContent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if(error)
            {
                @throw [NSException exceptionWithName:@"Write into file Failed" reason:error.localizedDescription userInfo:nil];
            }
            else
                NSLog(@"%@",jsonContent);
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
    }
}

@end

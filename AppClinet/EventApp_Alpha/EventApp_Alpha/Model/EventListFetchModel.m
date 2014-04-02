//
//  EventListFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-01.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListFetchModel.h"
#import "DataTransferModel.h"


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

-(void) fetchEventListWithMode:(NSString *)mode
{
    @try {
//        NSError* error=nil;
//        NSData* buffer=nil;
//        DataTransferModel* transfer=[[DataTransferModel alloc]init];
        //get the json of eventlist from webservice
//        NSData* buffer=[NSData dataWithContentsOfURL:[URLConstructModel constructFetchRequestWithResource:@"/event/" WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT] options:NSDataReadingMappedIfSafe error:&error];
        NSURL* targeturl=[DataTransferModel constructFetchRequestWithResource:@"/event/" WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT];
        if ([mode isEqualToString:@"time"]) {
            targeturl=[NSURL URLWithString:[[targeturl absoluteString] stringByAppendingString:@"&order_by=-event_create_time"]];
        }
        else if ([mode isEqualToString:@"hot"]){
            targeturl=[NSURL URLWithString:[[targeturl absoluteString] stringByAppendingString:@"&order_by=-event_rsvp"]];
        }
        NSLog(@"%@",[targeturl absoluteString]);
        [self fetchDataWithUrl:targeturl];
        

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchEventListWithMode:) name:@"didFinishLoadingData" object:nil];        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
    }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    NSData* buffer=self.data;
    NSError* error;
    //        writeIntoCache(buffer);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //Serialize the raw data
    NSDictionary* rawData=[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&error] ;
    if(error)
    {
        @throw [NSException exceptionWithName:@"Pharse Failed" reason:error.localizedDescription userInfo:nil];
    }
    eventList=[rawData valueForKey:@"objects"];
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
        {
            //                NSLog(@"%@",jsonContent);
        }
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFetchEventListWithMode" object:eventList];
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential* cre=[NSURLCredential credentialWithUser:PUBLICAUTHENUSER password:PUBLICAUTHENPASSWORD persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:cre forAuthenticationChallenge:challenge];
}

-(void)readFromCache{
    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Events.json"];
//    NSString* jsoncontent=[[NSString alloc]initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSData* buffer=[[NSData alloc] initWithContentsOfFile:filepath];
    
    NSError* error;
    NSArray* rawData=[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&error] ;
    if(error)
    {
        @throw [NSException exceptionWithName:@"Pharse Failed" reason:error.localizedDescription userInfo:nil];
    }
    eventList=rawData;
}

-(UIImage*)fetchProfileImageForUser:(NSDictionary*) user{
    if (![[user objectForKey:@"fk_user_image"] isEqual:[NSNull null]]) {
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,[[user objectForKey:@"fk_user_image"] objectForKey:@"path"]]];
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }else{
        return [UIImage imageNamed:@"152_152icon.png"];
    }
}


-(void) fetchEventListFromFile
{
    @try {
        [self readFromCache];
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
    }
}



@end

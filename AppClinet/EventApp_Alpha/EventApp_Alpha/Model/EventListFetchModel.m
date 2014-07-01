//
//  EventListFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-01.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListFetchModel.h"
#import "DataTransferModel.h"
#import "UserModel.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"



@implementation EventListFetchModel

static NSMutableArray* eventList;
static NSString* nextPage;

+(NSMutableArray*)eventsList{
    if (eventList==nil) {
        eventList=[[NSMutableArray alloc] init];
    }
    return eventList;
}

+(void)setEventsList:(NSMutableArray*)value{
    eventList=[value copy];
}

-(void) fetchEventListWithMode:(NSString *)mode
{
    @try {
        NSURL* targeturl=[DataTransferModel constructFetchRequestWithResource:@"/event/" WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT];
        if ([mode isEqualToString:@"time"]) {
            targeturl=[NSURL URLWithString:[[targeturl absoluteString] stringByAppendingString:@"&order_by=-event_create_time"]];
        }
        else if ([mode isEqualToString:@"hot"]){
            targeturl=[NSURL URLWithString:[[targeturl absoluteString] stringByAppendingString:@"&order_by=-event_rsvp"]];
        }
        NSLog(@"%@",[targeturl absoluteString]);
        [self fetchDataWithUrl:targeturl];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
    }
}

-(void) fetchNextPage:(id)blank complete:(void(^)(void))completeBlock fail:(void(^)(NSError* error))failBlock{
    if (!nextPage) {
        NSMutableDictionary* detail=[NSMutableDictionary dictionaryWithCapacity:0];
        [detail setValue:@"Network Issue, Plz check." forKey:NSLocalizedDescriptionKey];
        NSError* error=[[NSError alloc] initWithDomain:@"Event Fetching" code:200 userInfo:detail];
        failBlock(error);
    }
    else if (![nextPage isEqual:[NSNull null]]) {
        AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
        NSString* targetURL=[[[URLConstructModel constructURLHeader] absoluteString] stringByAppendingString:nextPage];
        [manager GET:targetURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* jsonDict=responseObject;
            nextPage=[[jsonDict valueForKey:@"meta"] valueForKey:@"next"];
            [eventList addObjectsFromArray:[jsonDict valueForKey:@"objects"]];
            NSLog(@"Downloaded/");
            completeBlock();
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"AFFAIL:%@",error);
        }];
    }else{
        NSMutableDictionary* detail=[NSMutableDictionary dictionaryWithCapacity:0];
        [detail setValue:@"No more events" forKey:NSLocalizedDescriptionKey];
        NSError* error=[[NSError alloc] initWithDomain:@"Event Fetching" code:200 userInfo:detail];
        failBlock(error);
    }
}

-(void) fetchEventListWithUser{
    @try {
        NSURL* targeturl=[DataTransferModel constructFetchRequestWithResource:@"/event/" WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT];
        targeturl=[NSURL URLWithString:[[targeturl absoluteString] stringByAppendingString:[NSString stringWithFormat:@"&fk_event_poster_user__username=%@", [UserModel username]]]];
        NSLog(@"%@",[targeturl absoluteString]);
        [self fetchDataWithUrl:targeturl];
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
        @throw exception;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailFetchEventListWithMode" object:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    if (self.data) {
        @try {
            NSData* buffer=self.data;
            NSError* error;
            //        writeIntoCache(buffer);
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            //Serialize the raw data
            NSDictionary* jsonDict=[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&error] ;
            if(error)
            {
                @throw [NSException exceptionWithName:@"Pharse Failed" reason:error.localizedDescription userInfo:nil];
            }
            eventList=[jsonDict valueForKey:@"objects"];
            nextPage=[[jsonDict valueForKey:@"meta"] valueForKey:@"next"];
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
                    //NSLog(@"%@",jsonContent);
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didFetchEventListWithMode" object:eventList];
            }

        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
        }
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailFetchEventListWithMode" object:nil];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential* cre=[NSURLCredential credentialWithUser:PUBLICAUTHENUSER password:PUBLICAUTHENPASSWORD persistence:NSURLCredentialPersistenceNone];
    [[challenge sender] useCredential:cre forAuthenticationChallenge:challenge];
}

-(void)readFromCache{
    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Events.json"];
//    NSString* jsoncontent=[[NSString alloc]initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSData* buffer=[[NSData alloc] initWithContentsOfFile:filepath];
    
    NSError* error;
    NSMutableArray* rawData=[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&error] ;
    if(error)
    {
        @throw [NSException exceptionWithName:@"Pharse Failed" reason:error.localizedDescription userInfo:nil];
    }
    eventList=rawData;
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

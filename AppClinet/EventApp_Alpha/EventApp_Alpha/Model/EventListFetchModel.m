//
//  EventListFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-01.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListFetchModel.h"
#import "DataTransferModel.h"
<<<<<<< HEAD
=======
#import "UserModel.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"

>>>>>>> Developing-Base-on-WS


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
<<<<<<< HEAD
        NSError* error=nil;
        NSData* buffer=nil;
        DataTransferModel* transfer=[[DataTransferModel alloc]init];
        //get the json of eventlist from webservice
//        NSData* buffer=[NSData dataWithContentsOfURL:[URLConstructModel constructFetchRequestWithResource:@"/event/" WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT] options:NSDataReadingMappedIfSafe error:&error];
        [transfer fetchDataWithUrl:[DataTransferModel constructFetchRequestWithResource:@"/event/" WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT]];
        if(!transfer.data)
        {
            @throw [NSException exceptionWithName:@"Fetching Failed" reason:error.localizedDescription userInfo:nil];
        }else
        {
            buffer=transfer.data;
        }
        //NSString* temp=[[NSString alloc]initWithData:buffer encoding:NSUTF8StringEncoding];
        //Pharse the data
        NSArray* rawData=[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&error] ;
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
=======
        NSURL* targeturl=[DataTransferModel constructFetchRequestWithResource:@"/event/" WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT];
        if ([mode isEqualToString:@"time"]) {
            targeturl=[NSURL URLWithString:[[targeturl absoluteString] stringByAppendingString:@"&order_by=-event_create_time"]];
        }
        else if ([mode isEqualToString:@"hot"]){
            targeturl=[NSURL URLWithString:[[targeturl absoluteString] stringByAppendingString:@"&order_by=-event_rsvp"]];
        }
        NSLog(@"%@",[targeturl absoluteString]);
        [self fetchDataWithUrl:targeturl];
        
>>>>>>> Developing-Base-on-WS

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchEventListWithMode:) name:@"didFinishLoadingData" object:nil];        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
    }
}

-(void) fetchNextPage:(id)table{
    if (![nextPage isEqual:[NSNull null]]) {
        AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
        NSString* targetURL=[[[URLConstructModel constructURLHeader] absoluteString] stringByAppendingString:nextPage];
        [manager GET:targetURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* jsonDict=responseObject;
            nextPage=[[jsonDict valueForKey:@"meta"] valueForKey:@"next"];
            [eventList addObjectsFromArray:[jsonDict valueForKey:@"objects"]];
            NSLog(@"Downloaded/");
            dispatch_async(dispatch_get_main_queue(), ^{
                EventListViewController* vc=table;
                vc.eventList=eventList;
                [vc.tableView reloadData];
                [ProgressHUD dismiss];
                NSLog(@"Updated;");
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"AFFAIL:%@",error);
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showError:@"No more events"];
        });
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


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
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

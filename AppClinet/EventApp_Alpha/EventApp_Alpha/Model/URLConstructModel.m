//
//  URLConstructModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 1/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "URLConstructModel.h"
#import "UserModel.h"

@implementation URLConstructModel

+(NSURL *)constructRequestWithResource: (NSString*)resource{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@",WEBSERVICEDOMAIN,API,resource];
    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL *)constructFetchRequestWithResource:(NSString*)resource WithConstrain:(NSString*)constrain WithFormat:(NSString*)format{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@%@%@",WEBSERVICEDOMAIN,API,resource,constrain,format];
    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL *)constructFetchRequest{
    return [self constructFetchRequestWithResource:@"event/" WithConstrain:@"?" WithFormat:JSONFORMAT];
}

+(NSMutableURLRequest*)constructPostRequestWithJsonData:(NSData*)postData{
    NSDictionary* dict=[[NSDictionary alloc]initWithObjects:@[@"",@"Washington",@"Event From IPhone",@"/app_project/api/v01/account/1/",@"2013-12-11",@"public"] forKeys:@[@"event_details",@"event_location",@"event_name",@"event_organizer_id",@"event_time",@"event_type"]];
    NSData* data=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    //    NSString* s=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //
    //    NSDictionary* d=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:[URLConstructModel constructRequestWithResource:@"event/"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    return request;
}

+(AFHTTPRequestOperationManager*)jsonManger{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return manager;
}

+(AFHTTPRequestOperationManager*)authorizedJsonManger{
    AFHTTPRequestOperationManager* manager=[URLConstructModel jsonManger];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"ApiKey %@:%@", [UserModel username], [UserModel userAPIKey]] forHTTPHeaderField:@"Authorization"];
    return manager;
}

@end

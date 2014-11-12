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
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,resource];
//    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL *)constructFetchRequestWithResource:(NSString*)resource WithConstrain:(NSString*)constrain WithFormat:(NSString*)format{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,resource,constrain,format];
//    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}
+(NSURL *)constructFetchRequestWithResourceV2:(NSString*)resource WithConstrain:(NSString*)constrain WithFormat:(NSString*)format{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,APIv2,resource,constrain,format];
    //    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL *)constructFetchRequest{
    return [self constructFetchRequestWithResource:@"event/" WithConstrain:@"?" WithFormat:JSONFORMAT];
}

+(NSURL *)constructEventPostURLwithUsername:(NSString*)username andKey:(NSString*) APIkey{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@%@%@", HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/event/?"];
    rawURL=[rawURL stringByAppendingFormat:@"username=%@&api_key=%@",username,APIkey];
//    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL*)constructURLHeader{
    NSString* header=[NSString stringWithFormat:@"%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME];
    return [NSURL URLWithString:header];
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

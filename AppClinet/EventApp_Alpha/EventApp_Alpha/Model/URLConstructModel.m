//
//  URLConstructModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 1/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "URLConstructModel.h"

@implementation URLConstructModel

+(NSURL *)constructRequestWithResource: (NSString*)resource{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@",WEBSERVICEDOMAIN,API,resource];
//    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL *)constructFetchRequestWithResource:(NSString*)resource WithConstrain:(NSString*)constrain WithFormat:(NSString*)format{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@%@%@",WEBSERVICEDOMAIN,API,resource,constrain,format];
//    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL *)constructFetchRequest{
    return [self constructFetchRequestWithResource:@"event/" WithConstrain:@"?" WithFormat:JSONFORMAT];
}

+(NSURL *)constructEventPostURLwithUsername:(NSString*)username andKey:(NSString*) APIkey{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@",WEBSERVICEDOMAIN,API,@"/event/?"];
    rawURL=[rawURL stringByAppendingFormat:@"username=%@&api_key=%@",username,APIkey];
    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

@end

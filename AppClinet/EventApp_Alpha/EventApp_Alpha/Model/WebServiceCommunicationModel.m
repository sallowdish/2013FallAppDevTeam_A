//
//  WebServiceCommunicationModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-19.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "WebServiceCommunicationModel.h"

@implementation WebServiceCommunicationModel

+(NSURL *)constructRequestWithConstrain: (NSString*)constrain{
    NSString* rawURL=[NSString stringWithFormat:@"%@%@%@%@",WEBSERVICEDOMAIN,API,constrain,FORMAT];
    NSLog(@"%@",rawURL);
    return [NSURL URLWithString:rawURL];
}

+(NSURL *)constructRequest{
    return [self constructRequestWithConstrain:@"event/?"];
}
@end


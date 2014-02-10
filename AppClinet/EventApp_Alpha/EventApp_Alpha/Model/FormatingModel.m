//
//  FormatingModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "FormatingModel.h"

@implementation FormatingModel

+(NSArray*)pythonDateTimeToStringArray:(NSString*)pythonDateTimeInfo
{
    NSMutableArray* datetimeInfo=[[NSMutableArray alloc] initWithArray:[pythonDateTimeInfo componentsSeparatedByString:@"T"]];
    datetimeInfo[1]=[datetimeInfo[1] substringToIndex:5];
    return datetimeInfo;
}

+(NSString*)addressDictionaryToStringL:(NSDictionary*)address
{
//    return [NSString stringWithFormat:@"%@,%@,%@,%@",[address objectForKey:@"address_detail"],[address objectForKey:@"address_city"],[address objectForKey:@"address_region"],[address objectForKey:@"address_country"]];
    return [address objectForKey:@"address_title"];
    
}

@end


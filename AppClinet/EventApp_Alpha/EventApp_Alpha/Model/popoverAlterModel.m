//
//  popoverAlterModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-05.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "popoverAlterModel.h"

@implementation popoverAlterModel
+(void)alterWithTitle:(NSString*)title Message:(NSString*)msg{
    UIAlertView* alter=[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
    [alter show];
}
@end

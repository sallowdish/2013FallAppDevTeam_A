//
//  popoverAlterModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-05.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface popoverAlterModel : NSObject
+(void)alterWithTitle:(NSString*)title Message:(NSString*)msg;
-(void) showWaitingHub;
-(void)dismissWaitingHub;
@end

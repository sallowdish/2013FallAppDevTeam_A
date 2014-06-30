//
//  FormatingModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateTableCell.h"

@interface FormatingModel : NSObject
+(NSArray*)pythonDateTimeToStringArray:(NSString*)pythonDateTimeInfo;
+(NSString*)addressDictionaryToStringL:(NSDictionary*)address;
+(TemplateTableCell*)modelToViewMatch:(id)sender ForRowAtIndexPath:(NSIndexPath *)indexPath eventInstance:(NSDictionary*)event;
@end

//
//  ColorStandarlizationModel.h
//  哪兒玩
//
//  Created by Rui Zheng on 2014-10-27.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorStandarlizationModel : NSObject

+(UIColor*)colorWithHexString:(NSString*)hex;
+(UIColor*)colorWithRGBString:(NSString *)rgb;

@end

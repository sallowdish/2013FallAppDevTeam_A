//
//  ColorStandarlizationModel.m
//  哪兒玩
//
//  Created by Rui Zheng on 2014-10-27.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "ColorStandarlizationModel.h"

@implementation ColorStandarlizationModel
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIColor*)colorWithRGBString:(NSString *)rgb{
    @try {
        NSArray* RGB=[rgb componentsSeparatedByString:@" "];
        CGFloat R=[RGB[0] floatValue];
        CGFloat G=[RGB[1] floatValue];
        CGFloat B=[RGB[2] floatValue];
        CGFloat alpha=1.0f;
        if (RGB.count==4) {
            alpha=[RGB[3] floatValue];
        }
        UIColor *color = [UIColor colorWithRed:(R/255.0) green:(G/255.0) blue:(B/255.0) alpha:(alpha)];
        return color;
        
    }
    @catch (NSException *exception) {
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return [UIColor clearColor];
    }
}

@end

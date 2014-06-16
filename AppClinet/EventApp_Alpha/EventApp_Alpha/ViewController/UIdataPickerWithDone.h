//
//  UIdataPickerWithDone.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-06-15.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIdataPickerWithDone : UIView
- (void) setDatePickerMode: (UIDatePickerMode) mode;
- (void) addTargetForDoneButton: (id) target action: (SEL) action;
@end

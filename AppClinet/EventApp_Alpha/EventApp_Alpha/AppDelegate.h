//
//  AppDelegate.h
//  EventApp_Alpha_1.1
//
//  Created by Rui Zheng on 2013-10-10.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingPageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *userToken;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong,retain) NSString* userToken;


- (NSURL *)applicationDocumentsDirectory;

@end

//
//  AppDelegate.h
//  EventApp_Alpha_1.1
//
//  Created by Rui Zheng on 2013-10-10.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* userUrl;
@property (strong, nonatomic) NSString* userApiKey;

- (NSURL *)applicationDocumentsDirectory;

@end

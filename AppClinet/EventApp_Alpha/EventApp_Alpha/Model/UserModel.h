//
//  UserModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "LoginModel.h"

@interface UserModel : LoginModel

@property (strong,nonatomic) NSDictionary* current_user;
@property BOOL isLogin;
+(NSString*)username;
+(NSString*)userAPIKey;
+(NSString*)userResourceURL;
+(NSDictionary*)current_user;
+(BOOL)isLogin;



+(UIImage*)getProfileImage;
+(UIImage*)getProfileImageWithUser:(NSDictionary*)user;
+(void)popupLoginViewToViewController:(UIViewController*) viewController;



+(void)turnOnDevelopmentMode;
+(void)turnOffDevelopmentMode;
@end

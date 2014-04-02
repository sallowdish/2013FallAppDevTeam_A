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
@property (strong,nonatomic) NSString *username,*userAPIKey,*userResourceURL;
@property BOOL isLogin;
-(void)logoutCurrentUser;
+(UserModel*)defaultModel;
-(UIImage*)getProfileImage;
-(UIImage*)getProfileImageWithUser:(NSDictionary*)user;
@end

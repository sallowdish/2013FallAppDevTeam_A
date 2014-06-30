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



+(void)getProfileImageWithUser:(NSDictionary*)user Sender:(UIImageView*)sender;
+(void)popupLoginViewToViewController:(UIViewController*) viewController;

+(void)getUserInfoofID:(NSInteger)userId complete:(void (^)(NSDictionary* userInfo))completeBlcok fail:(void(^)(NSError *error))failBlock;

+(void)turnOnDevelopmentMode;
+(void)turnOffDevelopmentMode;

-(void)logoutCurrentUser;
-(void)updateUserInfo;
@end

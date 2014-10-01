//
//  UserModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "UserModel.h"
#import "LoginViewController.h"
#import "CQMFloatingController.h"
#import "AppDelegate.h"
#import "ImageModel.h"

@implementation UserModel
//@synthesize current_user,username,userAPIKey,userResourceURL,isLogin;

static NSString *username,*userAPIKey,*userResourceURL;
static NSDictionary* current_user;
static bool isLogin,isDevelopment;
//static UIViewController* hostViewController;
-(id)init{
    self=[super init];
    if (self) {
        if (isLogin) {
            return self;
        }
        [self cleanUpUserInfo];
        isLogin=false;
    }
    return self;
}

+(void)turnOnDevelopmentMode{
    isDevelopment=true;
}

+(void)turnOffDevelopmentMode{
    isDevelopment=false;
}

+(void)getProfileImageWithUser:(NSDictionary*)user Sender:(UIImageView*)sender{
    if (![[user objectForKey:@"fk_user_image"] isEqual:[NSNull null]]) {
        [ImageModel downloadImageViaPath:[[user objectForKey:@"fk_user_image"] objectForKey:@"path"] For:@"user" WithPrefix:@"" :sender];
    }else{
        sender.image=[UIImage imageNamed:@"152_152icon.png"];
    }
}



//+(void)cleanUpUserInfo{
//    username=nil;
//    userResourceURL=nil;
//    userAPIKey=nil;
//    current_user=nil;
//}

-(void)cleanUpUserInfo{
    username=nil;
    userResourceURL=nil;
    userAPIKey=nil;
    current_user=nil;
    self.data=nil;
    self.jsonInfo=nil;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for ( NSHTTPCookie* cookie in [storage cookies])
//    {
//        [storage deleteCookie:cookie];
//    }
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    if(self.jsonInfo)
    {
        userAPIKey=[self.jsonInfo objectForKey:@"key"];
        current_user=[self.jsonInfo objectForKey:@"user"];
        username=[current_user objectForKey:@"username"];
        userResourceURL=[current_user objectForKey:@"resource_uri"];
        isLogin=true;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didLogin" object:nil];
    }
}

-(void)logoutCurrentUser{
    [self cleanUpUserInfo];
    isLogin=false;
}

+(NSString*)username{
    return username;
}
+(NSString*)userAPIKey{
    return userAPIKey;
}
+(NSString*)userResourceURL{
    return userResourceURL;
}
+(NSDictionary*)current_user{
    return current_user;
}

+(void)getUserInfo:(NSInteger)userId complete:(void (^)(NSDictionary* userInfo))completeBlcok fail:(void(^)(NSError *error))failBlock{
    NSString* targetURL=[[[URLConstructModel constructURLHeader] absoluteString] stringByAppendingFormat:@"%@%@%@%@%ld",API,@"/user/",@"?format=json",@"&id=",(long)userId];
    
    AFHTTPRequestOperationManager* manager=[URLConstructModel jsonManger];

    [manager GET:targetURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completeBlcok(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}

+(BOOL)isLogin{
    return  isLogin;
}

+(void)popupLoginViewToViewController:(UIViewController*) viewController complete:(void (^)(LoginViewController* loginview))completeBlock{
    LoginViewController* loginview=[viewController.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
    [viewController.navigationController pushViewController:loginview animated:NO];
    if (completeBlock) {
        completeBlock(loginview);
    }
}

+(UIViewController*)getCurrentViewController
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}


+(void)updateUserInfo{
    AFHTTPRequestOperationManager* manager=[URLConstructModel authorizedJsonManger];
    NSString* targetURL=[[[URLConstructModel constructURLHeader] absoluteString] stringByAppendingFormat:@"%@%@%@%@%@",API,@"/user/",@"?format=json",@"&id=",[UserModel current_user][@"id"]];
    [manager GET:targetURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* user=responseObject[@"objects"];
        current_user=user;
        [ProgressHUD showSuccess:@"User Info Updated."];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"Fail to update user info.%@",[error localizedDescription]]];
    }];

}
@end

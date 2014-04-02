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

@implementation UserModel
//@synthesize current_user,username,userAPIKey,userResourceURL,isLogin;

static NSString *username,*userAPIKey,*userResourceURL;
static NSDictionary* current_user;
static bool isLogin;
-(id)init{
    self=[super init];
    if (self) {
        [self cleanUpUserInfo];
        isLogin=false;
    }
    return self;
}

+(UIImage*)getProfileImage{
    if (isLogin) {
        return[self getProfileImageWithUser:current_user];
    }else{
        return [UIImage imageNamed:@"152_152icon.png"];;
    }
    
}
+(UIImage*)getProfileImageWithUser:(NSDictionary*)user{
    if (![[user objectForKey:@"fk_user_image"] isEqual:[NSNull null]]) {
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,[[user objectForKey:@"fk_user_image"] objectForKey:@"path"]]];
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }else{
        return [UIImage imageNamed:@"152_152icon.png"];
    }

}



-(void)cleanUpUserInfo{
    username=nil;
    userResourceURL=nil;
    userAPIKey=nil;
    current_user=nil;
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
+(BOOL)isLogin{
    return  isLogin;
}

+(void)popupLoginViewToViewController:(UIViewController*) viewController{
    LoginViewController* loginview=[viewController.storyboard instantiateViewControllerWithIdentifier:@"loginview"];
    //    UIViewController* loginview=[[UIViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    loginview.shareController=floatingController;
    [floatingController setFrameColor:[UIColor whiteColor]];
    [floatingController setLandscapeFrameSize:loginview.view.bounds.size];
    [floatingController setPortraitFrameSize:loginview.view.bounds.size];
    [floatingController showInView:viewController.view withContentViewController:loginview animated:YES];
}

+(UIViewController*)getCurrentViewController
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

@end

//
//  UserModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize current_user,username,userAPIKey,userResourceURL,isLogin;

static UserModel* defaultModel;
-(id)init{
    self=[super init];
    if (self) {
        current_user=[[NSDictionary alloc] init];
        username=@"";
        userAPIKey=@"";
        userResourceURL=@"";
        isLogin=false;
    }
    return self;
}

-(UIImage*)getProfileImage{
    if (isLogin) {
        return[self getProfileImageWithUser:current_user];
    }else{
        return [UIImage imageNamed:@"152_152icon.png"];;
    }
    
    
}
-(UIImage*)getProfileImageWithUser:(NSDictionary*)user{
    if (![[user objectForKey:@"fk_user_image"] isEqual:[NSNull null]]) {
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,[[user objectForKey:@"fk_user_image"] objectForKey:@"path"]]];
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }else{
        return [UIImage imageNamed:@"152_152icon.png"];
    }

}


-(NSString*)username{
    if (username==nil) {
        username=[[NSString alloc] init];
    }
    return username;
}

-(void)updateUserInfoWithUsername:(NSString*) newusername API_KEY:(NSString*)apikey Resource:(NSString*) resource{
    username=newusername;
    userResourceURL=resource;
    userAPIKey=apikey;
}

-(void)cleanUpUserInfo{
    username=nil;
    userResourceURL=nil;
    userAPIKey=nil;
    current_user=nil;
}


-(NSString*)userUrl{
    if (userResourceURL==nil) {
        userResourceURL=[[NSString alloc] init];
    }
    return userResourceURL;
}

-(NSString*)userApikey{
    if (userAPIKey==nil) {
        userAPIKey=[[NSString alloc] init];
    }
    return userAPIKey;
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

+(UserModel*)defaultModel{
    if (!defaultModel) {
        defaultModel=[[UserModel alloc] init];
    }
    return defaultModel;
}

@end

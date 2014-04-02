//
//  LoginModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface LoginModel : DataTransferModel
-(void)loginWithUsername:(NSString*)username AndPassword:(NSString*) password;
-(void)logoutCurrentUser;
@end

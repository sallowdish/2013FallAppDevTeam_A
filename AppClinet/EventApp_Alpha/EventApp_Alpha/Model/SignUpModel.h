//
//  SignUpModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-27.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface SignUpModel : DataTransferModel
-(void)signUp:(NSDictionary*)info;
@property (strong,nonatomic) NSMutableDictionary* jsonInfo;
@end

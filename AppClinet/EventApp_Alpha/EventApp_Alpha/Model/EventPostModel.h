//
//  EventPostModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/22/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface EventPostModel : DataTransferModel
-(void)postEventwithInfo:(NSMutableDictionary*)info;
@end

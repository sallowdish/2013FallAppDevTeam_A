//
//  EventDeleteModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-05-10.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface EventDeleteModel : DataTransferModel
-(void) deleteEvent:(NSDictionary*)event;
@end

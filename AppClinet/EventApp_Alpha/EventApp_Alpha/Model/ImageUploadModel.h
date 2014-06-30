//
//  ImageUploadModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface ImageUploadModel : DataTransferModel
-(void)uploadUserImage:(UIImage*)image Mode:(int)mode;
-(void)uploadEventImage:(UIImage*)image Event:(NSString *)fk_event;
//-(void)uploadImage:(UIImage*) image ForUser:(NSDictionary*)user;
@end

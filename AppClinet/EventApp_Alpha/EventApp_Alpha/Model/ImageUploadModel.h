//
//  ImageUploadModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "DataTransferModel.h"

@interface ImageUploadModel : DataTransferModel
-(void)uploadImage:(UIImage*)image User:(NSString*)username;
//-(void)uploadImage:(UIImage*) image ForUser:(NSDictionary*)user;
@end

//
//  ImageModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-27.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "ImageUploadModel.h"


@interface ImageModel : ImageUploadModel
+(UIImage*)downloadImage:(NSDictionary*)event;
+(UIImage*)downloadImageViaPath:(NSString *)path For:(NSString*)receiver WithPrefix:(NSString*)Prefix :(UIImageView*)sender;
@end

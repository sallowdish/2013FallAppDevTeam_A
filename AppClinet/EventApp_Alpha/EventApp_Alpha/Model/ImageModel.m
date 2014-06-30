//
//  ImageModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-27.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel
+(UIImage*)downloadImage:(NSDictionary*)event{
    UIImage* img=[UIImage imageNamed:@"event1.jpg"];
    if ([[event objectForKey:@"event_image"] count]>0) {
        NSURL *imageurl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,[[event objectForKey:@"event_image"][0] objectForKey:@"path"]]];
        
        NSData* imageContent=[NSData dataWithContentsOfURL:imageurl];
        if (imageContent) {
            img=[UIImage imageWithData:imageContent];
        }
    }
    return img;

}
+(UIImage*)downloadImageViaPath:(NSString *)path For:(NSString*)receiver WithPrefix:(NSString*)Prefix
{
    __block UIImage* img;
    NSURL* targetURL;
    if ([receiver isEqualToString:@"user"]) {
        img=[UIImage imageNamed:@"152_152icon.png"];
    }
    else if([receiver isEqualToString:@"event"])
    {
        img=[UIImage imageNamed:@"event1.jpg"];
    }
    else{
        img=[UIImage imageNamed:@"default_profile_5_bigger.png"];
    }
//    UIImage* img=[UIImage imageNamed:@"152_152icon.png"];
    if (path!=(id)[NSNull null]) {
        targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,Prefix,path]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:targetURL
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 img=image;
             }
         }];
    }
    return img;
    
}

@end

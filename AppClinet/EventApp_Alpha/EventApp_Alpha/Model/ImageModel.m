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
    if (![[event objectForKey:@"fk_event_image"] isEqual:[NSNull null]]) {
        NSURL *imageurl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,[[event objectForKey:@"fk_event_image"] objectForKey:@"path"]]];
        return[ UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
    }
    else if(![[event objectForKey:@"event_image_name"] isEqual:[NSNull null]]) {
        NSURL *imageurl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,@"/app_project/media/",[event objectForKey:@"event_image_name"]]];
        return [ UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
    }
    
    else{
        return [UIImage imageNamed:@"event3.jpg"];
    }

}
+(UIImage*)downloadImageViaPath:(NSString *)path For:(NSString*)receiver WithPrefix:(NSString*)Prefix{
    UIImage* img;
    if ([receiver isEqualToString:@"user"]) {
        img=[UIImage imageNamed:@"152_152icon.png"];
    }
    else if([receiver isEqualToString:@"event"])
    {
        img=[UIImage imageNamed:@"event1.jpg"];
    }
    else{
        img=[UIImage imageNamed:@"default_profile_5_bigger.png"];
        return img;
    }
//    UIImage* img=[UIImage imageNamed:@"152_152icon.png"];
    if (path!=(id)[NSNull null]) {
        NSURL* targetURL;
//        if ([receiver isEqualToString:@"user"]) {
//            targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,MEDIAPREFIX,path]];
//
//        }
//        else
//        {
//            targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,path]];
//
//        }
        targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,Prefix,path]];
//        NSLog(@"%@",[targetURL absoluteString]);
        NSData* imgContent=[NSData dataWithContentsOfURL:targetURL];
        if (imgContent) {
            img=[UIImage imageWithData:imgContent];
        }
        
    }
        return img;
    
}

@end

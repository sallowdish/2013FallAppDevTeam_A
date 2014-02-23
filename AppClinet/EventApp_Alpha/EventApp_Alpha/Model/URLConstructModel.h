//
//  URLConstructModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 1/11/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConstructModel : NSObject
//Return the URL to fetch specific resource
+(NSURL *)constructRequestWithResource: (NSString*)resource;
//Return the URL to fetch the event w/ conditions
+(NSURL *)constructFetchRequestWithResource:(NSString*)resource WithConstrain:(NSString*)constrain WithFormat:(NSString*)format;
//Return the URL to fetch the event list w/o any condition
+(NSURL *)constructFetchRequest;
//Construct the post request using the data from view
+(NSURL*)constructEventPostURLwithUsername:(NSString*)username andKey:(NSString*) APIkey;
@end

//
//  WebServiceCommunicationModel.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-19.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceCommunicationModel : NSObject
//Return the URL to fetch specific resource
+(NSURL *)constructRequestWithResource: (NSString*)resource;
//Return the URL to fetch the event w/ conditions
+(NSURL *)constructFetchRequestWithResource:(NSString*)resource WithConstrain:(NSString*)constrain WithFormat:(NSString*)format;
//Return the URL to fetch the event list w/o any condition
+(NSURL *)constructFetchRequest;
//Construct the post request using the data from view
+(NSMutableURLRequest*)constructPostRequestWithJsonData:(NSData*)postData;
@end

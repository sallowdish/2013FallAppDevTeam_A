//
//  ImageUploadModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "ImageUploadModel.h"
#import "UserModel.h"

@implementation ImageUploadModel
-(void)uploadUserImage:(UIImage*)image Mode:(int)mode{
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];

    NSString* FileParamConstant = @"path";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    
NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/userimage/"]];
    
//     requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",HTTPPREFIX,@"127.0.0.1:8000",WEBSERVICENAME,API,@"/userimage/"]];
    
    // create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    //set APIkey
    
    [request addValue:[NSString stringWithFormat:@"ApiKey %@:%@", [UserModel username],[UserModel userAPIKey]] forHTTPHeaderField:@"Authorization"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    

    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    
    //add parameters
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"mode"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", mode] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"fk_user"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [UserModel userResourceURL]] dataUsingEncoding:NSUTF8StringEncoding]];
    

    
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if (imageData) {
        //first bounder
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //last bounder
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection* conn=[NSURLConnection connectionWithRequest:request delegate:self];
    if (conn) {
        [self prepareForConnection];
        [conn start];
    }
}

-(void)uploadEventImage:(UIImage*)image Event:(NSString *)fk_event{
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];
    
    NSString* FileParamConstant = @"path";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/eventimage/"]];
    
//    requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",HTTPPREFIX,@"127.0.0.1:8000",WEBSERVICENAME,API,@"/eventimage/"]];
    
    
    // create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    //set APIkey
    
    [request addValue:[NSString stringWithFormat:@"ApiKey %@:%@", [UserModel username],[UserModel userAPIKey]] forHTTPHeaderField:@"Authorization"];

    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //add parameters
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"fk_event"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", fk_event] dataUsingEncoding:NSUTF8StringEncoding]];

    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if (imageData) {
        //first bounder
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //image info
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        //image data
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //last bounder
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection* conn=[NSURLConnection connectionWithRequest:request delegate:self];
    if (conn) {
        [self prepareForConnection];
        [conn start];
    }
}


-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if ([(NSHTTPURLResponse*) response statusCode]!=201&&[(NSHTTPURLResponse*) response statusCode]!=100) {
//        self.receivedData=nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailUploadImage" object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didUploadImage" object:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    NSString* feedback=[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",feedback);
}
@end

//
//  EventFetchModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-02.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventFetchModel.h"

@implementation EventFetchModel
-(void) fetchEventWithEventID:(NSInteger)eventID
{
//    NSError* error;
    NSURL* url=[[self class] constructFetchRequestWithResource:[NSString stringWithFormat:@"%@%ld/",@"/event/",(long)eventID] WithConstrain:NOCONSTRAIN WithFormat:JSONFORMAT];
    [self fetchDataWithUrl:url];
}

-(void) fetchRSVPWithEventID:(NSInteger)eventID{
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%ld",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/eventrsvp",@"/?format=json&fk_event=",(long)eventID]];
    [self fetchDataWithUrl:url];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    if (self.data) {
        NSError* error;
        [super connectionDidFinishLoading:connection];
        NSDictionary *rawData=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&error];
        if(error||[NSJSONSerialization isValidJSONObject:rawData]==NO)
        {
            @throw [NSException exceptionWithName:@"Failed" reason:@"Serializtion failed!" userInfo:nil];
        }
        self.event=rawData;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFetchDataWithEventID" object:nil];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailFetchDataWithEventID" object:nil];
    }
    
}



-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential* cre=[NSURLCredential credentialWithUser:PUBLICAUTHENUSER password:PUBLICAUTHENPASSWORD persistence:NSURLCredentialPersistenceNone];
    [[challenge sender] useCredential:cre forAuthenticationChallenge:challenge];
}

@end

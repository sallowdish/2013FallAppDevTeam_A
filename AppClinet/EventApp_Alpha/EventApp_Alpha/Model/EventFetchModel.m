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
    NSError* error;
    [super connectionDidFinishLoading:connection];
    NSDictionary *rawData=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&error];
    if(error||[NSJSONSerialization isValidJSONObject:rawData]==NO)
    {
        @throw [NSException exceptionWithName:@"Failed" reason:@"Serializtion failed!" userInfo:nil];
    }
    self.event=rawData;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFetchDataWithEventID" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential* cre=[NSURLCredential credentialWithUser:PUBLICAUTHENUSER password:PUBLICAUTHENPASSWORD persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:cre forAuthenticationChallenge:challenge];
}

@end

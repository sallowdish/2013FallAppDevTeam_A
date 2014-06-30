//
//  popoverAlterModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-05.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "popoverAlterModel.h"

@implementation popoverAlterModel
static UIAlertView* hub=nil;

+(void)alterWithTitle:(NSString*)title Message:(NSString*)msg{
    UIAlertView* alter=[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
    [alter show];
}

-(void) showWaitingHub{
    if (!hub) {
        hub=[[UIAlertView alloc] initWithTitle:@"Please wait..."
                                       message:nil delegate:self cancelButtonTitle:nil
                             otherButtonTitles: nil] ;
        [hub show];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGPoint center=CGPointMake(hub.frame.size.width / 2,
                                       hub.frame.size.height - 45);
        indicator.center = center;
        [indicator startAnimating];
        [hub addSubview:indicator];
    }
    else
        [hub show];
    
   
}

-(void)dismissWaitingHub{
    [hub dismissWithClickedButtonIndex:0 animated:YES];
}
@end

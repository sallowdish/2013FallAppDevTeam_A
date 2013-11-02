//
//  SettingPageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-30.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "SettingPageViewController.h"


@interface SettingPageViewController ()

@end

@implementation SettingPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)onclickLoginViaWeibo:(id)sender {
//    [self loginViaWeibo];
}

//- (void)loginViaWeibo
//{
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = appRedirectURI;
//    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SettingPageViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    if (request) {
//        [WeiboSDK sendRequest:request];
//        NSLog(@"Request has been sent.");
//    }
//    NSLog([WeiboSDK isWeiboAppInstalled]?@"1":@"0");
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  AddressInfoPageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "AddressInfoPageViewController.h"
#import "EventPostModel.h"

@interface AddressInfoPageViewController ()

@end

@implementation AddressInfoPageViewController

EventPostModel* model;

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
    
    //Visual Setup
    if (self.address) {
        [self displayInfo];
        self.comfirmButton.enabled=NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayInfo{
    self.addressDetail.text=[self.address objectForKey:@"address_detail"];
    self.addressCity.text=[self.address objectForKey:@"address_city"];
    self.addressRegion.text=[self.address objectForKey:@"address_region"];
    self.addressCountry.text=[self.address objectForKey:@"address_country"];
    self.addressPC.text=[self.address objectForKey:@"address_postal_code"];
    self.addressTitle.text=[self.address objectForKey:@"address_title"];
}

-(NSDictionary*)collectInfo
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:self.addressDetail.text forKey:@"address_detail"];
    [dic setObject:self.addressCity.text forKey:@"address_city"];
    [dic setObject:self.addressRegion.text forKey:@"address_region"];
    [dic setObject:self.addressCountry.text forKey:@"address_country"];
    [dic setObject:self.addressPC.text forKey:@"address_postal_code"];
    [dic setObject:self.addressTitle.text forKey:@"address_title"];
    return dic;
}

-(IBAction)comfirmTapped:(id)sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostNewAddress) name:@"didPostNewAddress" object:nil];
    if (!model) {
        model=[[EventPostModel alloc] init];
    }
    [model postAddresswithInfo:[self collectInfo]];
}

-(void)didPostNewAddress{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostNewAddress" object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

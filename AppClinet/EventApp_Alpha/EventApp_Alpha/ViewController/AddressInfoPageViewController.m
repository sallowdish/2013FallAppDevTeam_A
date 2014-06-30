//
//  AddressInfoPageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "AddressInfoPageViewController.h"
#import "EventPostModel.h"
#import "popoverAlterModel.h"
#import "ProgressHUD.h"

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
    
    
    //Fucntionality setup
    UITapGestureRecognizer* dismissKeyBoardTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    dismissKeyBoardTap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:dismissKeyBoardTap];

    
    //Visual Setup
    if (self.address) {
        [self displayInfo];
        self.comfirmButton.enabled=NO;
        for (UITextField* field in self.allAddressInfoField) {
            field.enabled=NO;
        }
    }
    
}

-(void)dismissKeyBoard{
    [self.view endEditing:YES];
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
    return (NSDictionary*)dic;
}

-(IBAction)comfirmTapped:(id)sender{
    if (![self.addressTitle.text isEqualToString:@""]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostNewAddress:) name:@"didPostNewAddress" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostNewAddressFailed) name:@"didPostNewAddressFailed" object:nil];
//        [ProgressHUD show:@"POSTing new Address"];
//        model=[[EventPostModel alloc] init];
//        [model postAddresswithInfo:[self collectInfo]];
        [self didPostNewAddress:nil];
    }
    else{
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Please fill up all required fields."];
    }
}

-(void)didPostNewAddress:(NSNotification*) notif{
//    NSString* location=(NSString*)[notif object];
//    NSDictionary* dic=[NSDictionary dictionaryWithObjects:@[self.addressTitle.text,location] forKeys:@[@"event_title",@"event_resourceurl"]];
    NSDictionary* dic=[self collectInfo];
    [ProgressHUD dismiss];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didCreateNewAddress" object:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didPostNewAddressFailed{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    [popoverAlterModel alterWithTitle:@"Failed" Message:@"Failed to POST new address."];
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

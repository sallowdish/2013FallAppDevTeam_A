//
//  AddressInfoPageViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-02.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressInfoPageViewController : UITableViewController
@property (weak,nonatomic) NSDictionary* address;
@property (strong,nonatomic)NSString* addressResource;
@property (weak, nonatomic) IBOutlet UITextField *addressTitle;
@property (weak, nonatomic) IBOutlet UITextField *addressDetail;
@property (weak, nonatomic) IBOutlet UITextField *addressCity;
@property (weak, nonatomic) IBOutlet UITextField *addressRegion;
@property (weak, nonatomic) IBOutlet UITextField *addressCountry;
@property (weak, nonatomic) IBOutlet UITextField *addressPC;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allAddressInfoField;
@end

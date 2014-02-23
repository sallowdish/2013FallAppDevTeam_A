//
//  EventEdittingViewController.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-19.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

//old implement, decarded
//#define DATEPICKER 100
//#define TIMEFROMPICKER 101
//#define TIMETOPICKER 102
//#define CAPACITYPICKER 103

#import <UIKit/UIKit.h>

@interface EventEdittingViewController : UITableViewController <NSURLConnectionDelegate,UITextFieldDelegate>
- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *dateInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeFromInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *capacityInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailInputTextField;

@end

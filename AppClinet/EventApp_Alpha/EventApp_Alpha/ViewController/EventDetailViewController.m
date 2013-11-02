//
//  EventDetailViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-11.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventDetailTableViewController.h"
#import "EventFetchModel.h"
@interface EventDetailViewController ()
@property (strong,nonatomic) NSDictionary* event;
@end

@implementation EventDetailViewController
@synthesize eventID,event,eventDescription;


- (id)init{
    self=[super init];
    if(self){
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSError* err;
    
    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EventDetails.json"];
    
    event=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filepath] options:NSJSONReadingAllowFragments error:&err];
    
    if(err)
        NSLog(@"%@",[err localizedDescription]);
    
    eventDescription.text=[event valueForKey:@"Description"];
    
//    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:777];
//    scrollView.scrollEnabled=YES;
//    [scrollView setContentSize:CGSizeMake(700,700)];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"tableDisplaySegue"])
        ((EventDetailTableViewController*)[segue destinationViewController]).eventID=eventID;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

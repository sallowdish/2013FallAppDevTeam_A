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
#import "FormatingModel.h"
#define MAXTAG 104
@interface EventDetailViewController ()
@property (strong,nonatomic) NSDictionary* event;
@end

@implementation EventDetailViewController
@synthesize eventID,event;


- (id)init{
    self=[super init];
    if(self){
    }
    return self;
}



- (void)viewDidLoad
{
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320,self.scrollView.frame.size.height*1.1)];
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    set the view frame to round conner
    for (int i=100; i<MAXTAG+1; i++) {
        UIView* subview=[self.view viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }

    NSError* err;
    
//    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EventDetails.json"];
    NSData* rawData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:8000/eventApp/api/v01/event/%ld/",(long)eventID]]];
    
    NSArray* jsonData=[NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&err];
    
    if(err)
        NSLog(@"%@",[err localizedDescription]);
    else{
        event=[jsonData[0] objectForKey:@"fields"];
        [self modelToViewMatch];
    }
    //matching
//    event=(NSDictionary*)[event objectForKey:@"fields"];
    
    
}

-(void)modelToViewMatch
{
    self.eventName.text=[NSString stringWithFormat:@"- %@ -",[event objectForKey:@"Event_Title"]];
    self.hoster.text=[[event objectForKey:@"EventPoster_Account_ID"] objectForKey:@"username"];
    NSArray* timeInfo=[[[FormatingModel alloc]init]pythonDateTimeToStringArray:[event objectForKey:@"Event_Time"]];
    self.dateTime.text=[NSString stringWithFormat:@"%@|%@",timeInfo[0],timeInfo[1]];
    self.location.text=[[event objectForKey:@"Address_ID"] objectForKey:@"address"];
    self.like.text=[NSString stringWithFormat:@"%@",[event objectForKey:@"Event_Like"]];
    self.RSVP.text=[NSString stringWithFormat:@"%@/%@",[event objectForKey:@"Event_RSVP"],[event objectForKey:@"Event_Capacity"]];
    self.images.image=[ UIImage imageNamed:@"Beach.png"];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"tableDisplaySegue"])
//        ((EventDetailTableViewController*)[segue destinationViewController]).eventID=eventID;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

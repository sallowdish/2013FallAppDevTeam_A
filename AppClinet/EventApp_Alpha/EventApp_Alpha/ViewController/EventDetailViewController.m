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
    for (int i=100; i<105; i++) {
        UIView* subview=[self.view viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }

    NSError* err;
    
//    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EventDetails.json"];
    NSData* rawData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:8000/api/v01/event/%ld/",(long)eventID]]];
    
    NSDictionary* jsonData=[NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&err];
    
    if(err)
        NSLog(@"%@",[err localizedDescription]);
    else{
        //event=[jsonData[0] objectForKey:@"fields"];
        event=jsonData;
        [self modelToViewMatch];
    }
    //matching
//    event=(NSDictionary*)[event objectForKey:@"fields"];
    
    
}

-(void)modelToViewMatch
{
    self.eventName.text=[NSString stringWithFormat:@"- %@ -",[event objectForKey:@"event_title"]];
    self.hoster.text=[[event objectForKey:@"fk_event_poster_user"] objectForKey:@"username"];
    NSArray* timeInfo=[[[FormatingModel alloc]init]pythonDateTimeToStringArray:[event objectForKey:@"event_time"]];
    self.dateTime.text=[NSString stringWithFormat:@"%@|%@",timeInfo[0],timeInfo[1]];
    self.location.text=[[event objectForKey:@"Address_ID"] objectForKey:@"address"];
    self.like.text=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_like"]];
    self.RSVP.text=[NSString stringWithFormat:@"%@/%@",[event objectForKey:@"event_rsvp"],[event objectForKey:@"event_capacity"]];
    NSString *description=[event objectForKey:@"event_detail"];
    if ([description isEqualToString:@""]) {
        self.description.text=@"This guy is really lazy. He didn't write anything in detail.";
        self.description.selectable=NO;
    }
    else{
        self.description.text=description;
        
    }
    self.images.image=[ UIImage imageNamed:@"Beach.png"];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"tableDisplaySegue"])
//        ((EventDetailTableViewController*)[segue destinationViewController]).eventID=eventID;
}

<<<<<<< HEAD
=======
- (IBAction)joinButtonPressed:(id)sender {
    if(isJoined==NO)
    {
        NSInteger currentNum=[(NSString*)[event objectForKey:@"event_rsvp"] integerValue];
        self.RSVP.text=[NSString stringWithFormat:@"%d/%@",currentNum+1,[event objectForKey:@"event_capacity"]];
        self.joinButton.enabled=NO;
        isJoined=!isJoined;
        [popoverAlterModel alterWithTitle:@"Congratulation" Message:@"You have joined the event successfully."];
    }else
    {
        self.joinButton.enabled=NO;
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"The event is full, sorry."];
    }
}
>>>>>>> Developing-Base-on-WS

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

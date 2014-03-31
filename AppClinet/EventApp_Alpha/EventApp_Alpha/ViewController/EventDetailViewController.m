//
//  EventDetailViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-11.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventDetailViewController.h"
//#import "EventDetailTableViewController.h"
#import "EventFetchModel.h"
#import "FormatingModel.h"
#import "popoverAlterModel.h"
#import "FullScreenImageController.h"
#define MAXTAG 104
@interface EventDetailViewController ()
@property (strong,nonatomic) NSDictionary* event;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ViewedPeopleIcons;
@end

@implementation EventDetailViewController
@synthesize eventID,event;

bool isJoined;


- (id)init{
    self=[super init];
    if(self){
    }
    return self;
}



- (void)viewDidLoad
{
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320,self.scrollView.frame.size.height*1.2)];
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

//    NSError* err;
    EventFetchModel* model=[[EventFetchModel alloc]init];
//    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EventDetails.json"];
//    NSData* rawData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:8000/api/v01/event/%ld/",(long)eventID]]];
//    
//    NSDictionary* jsonData=[NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&err];
    @try {
        [model fetchEventWithEventID:eventID];
    }
    @catch (NSException *exception) {
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Fetching event detail failed."];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @try{
        event=model.event;
        [self modelToViewMatch];
        isJoined=NO;
    }
    @catch (NSException *exception) {
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Display event detail failed."];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self viewedPeopleInitialize];
    
    //matching
//    event=(NSDictionary*)[event objectForKey:@"fields"];
}

-(void)viewedPeopleInitialize{
    
    for (int i = 0; i<[self.ViewedPeopleIcons count]; i++) {
        //UI initialization
        UIImageView* view=self.ViewedPeopleIcons[i];
        view.layer.borderWidth=2;
        view.layer.borderColor=[UIColor whiteColor].CGColor;
        view.layer.cornerRadius=25;
        view.layer.masksToBounds = NO;
        view.clipsToBounds = YES;
        //functionality initialization
        UITapGestureRecognizer* singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewedPeopleTapped:)];
        singleTap.numberOfTapsRequired=1;
        view.userInteractionEnabled=YES;
        [view addGestureRecognizer:singleTap];
    }
}

-(IBAction)viewedPeopleTapped:(id)sender{
    UITapGestureRecognizer* tap=(UITapGestureRecognizer*)sender;
    NSUInteger i=[self.ViewedPeopleIcons indexOfObject:tap.view];
    NSLog(@"%ld Tapped!",(long)i);
    [self performSegueWithIdentifier:@"seeUsersDetail" sender:self];
}

-(void)modelToViewMatch
{
    self.eventName.text=[NSString stringWithFormat:@"- %@ -",[event objectForKey:@"event_title"]];
    self.hoster.text=[[event objectForKey:@"fk_event_poster_user"] objectForKey:@"username"];
//    NSArray* timeInfo=[FormatingModel pythonDateTimeToStringArray:[event objectForKey:@"event_time"]];
    self.dateTime.text=[NSString stringWithFormat:@"%@|%@",[event objectForKey:@"event_date"],[event objectForKey:@"event_time"]];
    self.location.text=[FormatingModel addressDictionaryToStringL:[event objectForKey:@"fk_address"]];
    self.like.text=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_like"]];
    id capacity=[event objectForKey:@"event_capacity"];
    if (capacity!=[NSNull null]) {
        self.RSVP.text=[NSString stringWithFormat:@"%@/%ld",[event objectForKey:@"event_rsvp"],(long)[capacity integerValue]];
    }else{
        self.RSVP.text=@"Free to go";
        [self.joinButton removeFromSuperview];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sende
{
    if ([segue.identifier isEqualToString:@"toFullScreen"]) {
        FullScreenImageController* des=(FullScreenImageController*)segue.destinationViewController;
        des.image=self.images.image;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

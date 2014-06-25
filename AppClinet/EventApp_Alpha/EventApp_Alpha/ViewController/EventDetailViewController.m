//
//  EventDetailViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-11.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventJoinAndLikeModel.h"
#import "ProgressHUD.h"
#import "EventFetchModel.h"
#import "FormatingModel.h"
#import "popoverAlterModel.h"
#import "UserModel.h"
#import "FullScreenImageController.h"
#import "ProfilePageViewController.h"
#import "AddressInfoPageViewController.h"
#import "ImageModel.h"
#undef MAXTAG
#define MAXTAG 104
@interface EventDetailViewController ()
@property (strong,nonatomic) NSDictionary* event;
@property (strong,nonatomic) NSMutableArray* RSVPList;
@property (strong,nonatomic) NSMutableArray* likeList;
@property (strong, nonatomic) NSMutableArray *joinedPeopleIcons;
@property (weak, nonatomic) IBOutlet UIView *joinedPeopleSpanArea;
@property (weak, nonatomic) IBOutlet UILabel *joinedPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *descriptionTab;
@property (weak, nonatomic) IBOutlet UIButton *commentsTab;
@property (weak, nonatomic) IBOutlet UIView *detailSpanArea;
@property UITextField* noComments;
@end

@implementation EventDetailViewController
@synthesize eventID,event;

bool isJoined,isLiked;
EventFetchModel* model;
EventJoinAndLikeModel* jlmodel;

- (id)init{
    self=[super init];
    if(self){
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.hidden=YES;
    [self.scrollView setScrollEnabled:YES];
    float para=[[UIScreen mainScreen] bounds].size.height== 480?1.3:1.16;
    CGSize contentsize=CGSizeMake(320,self.containerView.frame.size.height*para+self.navigationController.navigationBar.frame.size.height);
    [self.scrollView setContentSize:contentsize];
    
    
    self.RSVPList=[NSMutableArray arrayWithCapacity:0];
    self.likeList=[NSMutableArray arrayWithCapacity:0];
    self.joinedPeopleIcons=[NSMutableArray arrayWithCapacity:0];
    self.descriptionTab.enabled=NO;
    model=[[EventFetchModel alloc]init];
    jlmodel=[[EventJoinAndLikeModel alloc]init];

 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    set the view frame to round conner
    for (int i=100; i<MAXTAG+1; i++) {
        UIView* subview=[self.view viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }

//    NSError* err;
    
    [ProgressHUD show:@"Loading event info..."];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchEvent) name:@"didFetchDataWithEventID" object:nil];
    @try {
        
        [model fetchEventWithEventID:eventID];
    }
    @catch (NSException *exception) {
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Fetching event detail failed."];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}


-(void)didFetchEvent{
    @try{
        event=model.event;
        [self modelToViewMatch];
    }
    @catch (NSException *exception) {
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Display event detail failed."];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //stop listen to fetching event data
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFetchDataWithEventID" object:nil];
    
    self.scrollView.hidden=NO;
    [ProgressHUD showSuccess:@"Loading Finish."];
    //post didLoadPage;

}











-(IBAction)viewedPeopleTapped:(id)sender{
    UITapGestureRecognizer* tap=(UITapGestureRecognizer*)sender;
    NSUInteger i=[self.joinedPeopleIcons indexOfObject:tap.view];
    NSLog(@"%ld Tapped!",(long)i);
    ProfilePageViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
    vc.targetUser=self.RSVPList[i];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)modelToViewMatch
{
    self.eventName.text=[NSString stringWithFormat:@"- %@ -",[event objectForKey:@"event_title"]];
    self.hoster.text=[event objectForKey:@"fk_event_poster_user_name"];
//    NSArray* timeInfo=[FormatingModel pythonDateTimeToStringArray:[event objectForKey:@"event_time"]];
    self.dateTime.text=[NSString stringWithFormat:@"%@|%@",[event objectForKey:@"event_date"],[event objectForKey:@"event_time"]];
    self.location.text=[event objectForKey:@"address_title"];
    self.like.text=[NSString stringWithFormat:@"%@",[event valueForKey:@"event_like_count"]];
    id capacity=[event valueForKey:@"event_capacity"];
    if ([capacity isEqual:[NSNull null]] || [capacity intValue]==0) {
        self.RSVP.text=@" ∞/∞";
//        [self.joinButton removeFromSuperview];
    }else{
        self.RSVP.text=[NSString stringWithFormat:@"%@/%@",[event objectForKey:@"event_rsvp_count"],[event objectForKey:@"event_capacity"]];
    }
    NSString *description=[event objectForKey:@"event_detail"];
    if ([description isEqualToString:@""]) {
        self.description.text=@"This guy is really lazy. He didn't write anything in detail.";
        self.description.selectable=NO;
    }
    else{
        self.description.text=description;
        
    }
    if (isLiked) {
        [self.likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
    }
    
    
    //load event image
    if ([[event objectForKey:@"event_image"] count]>0) {
        self.images.image=[ImageModel downloadImageViaPath:[[event objectForKey:@"event_image"][0] objectForKey:@"path"] For:@"event" WithPrefix:@""];
    }
    else{
        self.images.image=[UIImage imageNamed:@"event3.jpg"];
    }

}


-(IBAction)hostInfoTapped{
//    ProfilePageViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
//    vc.targetUser=[event objectForKey:@"fk_event_poster_user"];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)locationInfoTapped{
    AddressInfoPageViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"AddressInfoPage"];
    NSMutableDictionary* address=[NSMutableDictionary dictionaryWithCapacity:0];
    address[@"address_title"]=[event objectForKey:@"address_title"];
    address[@"address_region"]=[event objectForKey:@"address_region"];
    address[@"address_city"]=[event objectForKey:@"address_city"];
    address[@"address_country"]=[event objectForKey:@"address_country"];
    address[@"address_detail"]=[event objectForKey:@"address_detail"];
    address[@"address_postal_code"]=[event objectForKey:@"address_postal_code"];
    vc.address=address;
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)RSVPButtonTapped:(id)sender {
//    if (![UserModel isLogin]) {
//        [UserModel popupLoginViewToViewController:self];
//    }else{
//        if (![self hasRSVP]) {
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRSVPEvent) name:@"didRSVPEvent" object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRSVPEventFailed) name:@"didRSVPEventFailed" object:nil];
//            [ProgressHUD show:@"trying to RSVP the event..."];
//            [jlmodel rsvpEvent:event];
//        }
//        else{
//            self.joinButton.enabled=NO;
//            [popoverAlterModel alterWithTitle:@"Warning" Message:@"You have RSVPed this event already."];
//        }
//    }
}




- (IBAction)likeButtonTapped:(id)sender {
//    if (![UserModel isLogin]) {
//        [UserModel popupLoginViewToViewController:self];
//    }else{
//        if (![self hasLiked]) {
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLikeEvent) name:@"didLikeEvent" object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLikeEventFailed) name:@"didLikeEventFailed" object:nil];
//            [ProgressHUD show:@"trying to like the event..."];
//            [jlmodel likeEvent:event];
//        }
//        else{
//            self.likeButton.enabled=NO;
//            [popoverAlterModel alterWithTitle:@"Warning" Message:@"You have liked this event already."];
//        }
//    }
}


-(void)didLikeEvent{

}

-(void)didLikeEventFailed{

}


-(IBAction)commentTabTapped:(id)sender{
    

#pragma comment in developing

    self.descriptionTab.backgroundColor=[UIColor colorWithRed:0xCC/255.0 green:0xCC/255.0 blue:0xFF/255.0 alpha:1];
//    self.descriptionTab.layer.cornerRadius=3;
    self.commentsTab.backgroundColor=[UIColor clearColor];
    self.description.text=@"Comments feature will be added in next reversion.";
    
    //disable self&enable the other one
    self.commentsTab.enabled=NO;
    self.descriptionTab.enabled=YES;
}

-(IBAction)descriptionTabTapped:(id)sender{

#pragma comment in dev
    self.commentsTab.backgroundColor=[UIColor colorWithRed:0xCC/255.0 green:0xCC/255.0 blue:0xFF/255.0 alpha:1];
    self.descriptionTab.backgroundColor=[UIColor clearColor];
    NSString *description=[event objectForKey:@"event_detail"];
    if ([description isEqualToString:@""]) {
        self.description.text=@"This guy is really lazy. He didn't write anything in detail.";
    }else{
        self.description.text=description;
    }
    //disable self&enable the other one
    self.descriptionTab.enabled=NO;
    self.commentsTab.enabled=YES;
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

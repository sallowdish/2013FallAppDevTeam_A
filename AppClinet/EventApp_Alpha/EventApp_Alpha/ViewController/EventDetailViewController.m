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
    
    
    isJoined=NO;
    isLiked=NO;
    self.RSVPList=[NSMutableArray arrayWithCapacity:0];
    self.likeList=[NSMutableArray arrayWithCapacity:0];
    self.joinedPeopleIcons=[NSMutableArray arrayWithCapacity:0];
    self.descriptionTab.enabled=NO;
    model=[[EventFetchModel alloc]init];
    jlmodel=[[EventJoinAndLikeModel alloc]init];

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
    
    [ProgressHUD show:@"Loading event info..."];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchEvent) name:@"didFetchDataWithEventID" object:nil];
    @try {
        
        [model fetchEventWithEventID:eventID];
    }
    @catch (NSException *exception) {
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Fetching event detail failed."];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    //matching
//    event=(NSDictionary*)[event objectForKey:@"fields"];
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
    
    
//    [[ProgressHUD class] dismiss];
    //stop listen to fetching event data
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFetchDataWithEventID" object:nil];
    

    [self getRSVPInfo];
    //post didLoadPage;

}


-(void) getRSVPInfo{
    //start listen to fetching joined people
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetRSVPInfo) name:@"didFinishCountingRSVP" object:nil];
    [jlmodel countRSVP:event];
}

-(void)didGetRSVPInfo{
    //    NSLog(@"");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishCountingRSVP" object:nil];
    @try {
        NSArray* RSVP=[jlmodel.json objectForKey:@"objects"];
        [self.RSVPList removeAllObjects];
        for (int i = 0; i<RSVP.count; i++) {
            [self.RSVPList addObject:[(NSDictionary*)RSVP[i] objectForKey:@"fk_user"]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    
    //visual setup
    if (![[event objectForKey:@"event_capacity"] isEqual:[NSNull null]]) {
        self.RSVP.text=[NSString stringWithFormat:@"%lu/%@",(unsigned long)[self.RSVPList count],[event objectForKey:@"event_capacity"]];
    }
    else{
        self.RSVP.text=[NSString stringWithFormat:@"%lu/∞",(unsigned long)[self.RSVPList count]];
    }
    //Visual setup
    [[self.joinedPeopleSpanArea subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int basex=10;
    int basey=(self.joinedPeopleSpanArea.frame.size.height-50)/2;
    for (int i = 0; i<(self.RSVPList.count>5?5:self.RSVPList.count); i++) {
        //UI initialization
        //Get uiimage content
        NSDictionary* user=self.RSVPList[i];
        UIImage* img=[UserModel getProfileImageWithUser:user];
        
        //prepare the frame
        
        UIImageView* view=[[UIImageView alloc]initWithFrame:CGRectMake(basex, basey, 50, 50)];
        view.image=img;
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
        [self.joinedPeopleSpanArea addSubview:view];
        [self.joinedPeopleIcons addObject:view];
        basex+=55;
    }
    if (self.RSVPList.count<=5) {
        self.joinedPeopleLabel.text=@"已參與";
    }
    self.joinedPeopleLabel.frame=CGRectMake(basex, self.joinedPeopleLabel.frame.origin.y, self.joinedPeopleLabel.frame.size.width, self.joinedPeopleLabel.frame.size.height);
    [self.joinedPeopleSpanArea addSubview:self.joinedPeopleLabel];
    //stop listening to fetching joined people
    
    [self getLikeInfo];
}


-(void) getLikeInfo{
    //start listen to fetching joined people
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetLikeInfo) name:@"didFinishCountingLike" object:nil];
    [jlmodel countLike:event];
}

-(void) didGetLikeInfo{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishCountingLike" object:nil];
    @try {
        NSArray* like=[jlmodel.json objectForKey:@"objects"];
        [self.likeList removeAllObjects];
        for (int i = 0; i<like.count; i++) {
            [self.likeList addObject:[(NSDictionary*)like[i] objectForKey:@"fk_user"]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    //visual setup
    self.like.text=[NSString stringWithFormat:@"%lu",(unsigned long)[self.likeList count]];
    [ProgressHUD dismiss];
    self.scrollView.hidden=NO;
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
    self.like.text=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_like"]];
    id capacity=[event objectForKey:@"event_capacity"];
    if ([capacity isEqual:[NSNull null]]) {
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
    ProfilePageViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
    vc.targetUser=[event objectForKey:@"fk_event_poster_user"];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (![UserModel isLogin]) {
        [UserModel popupLoginViewToViewController:self];
    }else{
        if (![self hasRSVP]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRSVPEvent) name:@"didRSVPEvent" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRSVPEventFailed) name:@"didRSVPEventFailed" object:nil];
            [ProgressHUD show:@"trying to RSVP the event..."];
            [jlmodel rsvpEvent:event];
        }
        else{
            self.joinButton.enabled=NO;
            [popoverAlterModel alterWithTitle:@"Warning" Message:@"You have RSVPed this event already."];
        }
    }
}


-(void)didRSVPEvent{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
//    [self.view setNeedsDisplay];
    [self getRSVPInfo];
    [popoverAlterModel alterWithTitle:@"Succeed" Message:@"You have RSVP this event."];
    self.joinButton.enabled=NO;
}

-(void)didRSVPEventFailed{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    [popoverAlterModel alterWithTitle:@"Failed" Message:@"Please try again later."];
}

- (IBAction)likeButtonTapped:(id)sender {
    if (![UserModel isLogin]) {
        [UserModel popupLoginViewToViewController:self];
    }else{
        if (![self hasLiked]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLikeEvent) name:@"didLikeEvent" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLikeEventFailed) name:@"didLikeEventFailed" object:nil];
            [ProgressHUD show:@"trying to like the event..."];
            [jlmodel likeEvent:event];
        }
        else{
            self.likeButton.enabled=NO;
            [popoverAlterModel alterWithTitle:@"Warning" Message:@"You have liked this event already."];
        }
    }
}


-(void)didLikeEvent{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    //    [self.view setNeedsDisplay];
    [self getLikeInfo];
    [popoverAlterModel alterWithTitle:@"Succeed" Message:@"You have liked this event."];
    self.likeButton.enabled=NO;
}

-(void)didLikeEventFailed{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    [popoverAlterModel alterWithTitle:@"Failed" Message:@"Please try again later."];
}

-(BOOL)hasRSVP{
    NSInteger current_id=[[[UserModel current_user] objectForKey:@"id"] integerValue];
    for (NSDictionary* user in self.RSVPList) {
        NSInteger RSVP_id=[[user objectForKey:@"id"] integerValue];
        if (RSVP_id == current_id) {
            return YES;
        };
    }
    return  false;
}

-(BOOL)hasLiked{
    NSInteger current_id=[[[UserModel current_user] objectForKey:@"id"] integerValue];
    for (NSDictionary* user in self.likeList) {
        NSInteger RSVP_id=[[user objectForKey:@"id"] integerValue];
        if (RSVP_id == current_id) {
            return YES;
        };
    }
    return  false;
}


-(IBAction)commentTabTapped:(id)sender{
    

#pragma comment in developing

    self.commentsTab.backgroundColor=self.descriptionTab.backgroundColor;
    self.descriptionTab.backgroundColor=[UIColor clearColor];
    self.description.text=@"Comments feature will be added in next reversion.";
    
    //disable self&enable the other one
    self.commentsTab.enabled=NO;
    self.descriptionTab.enabled=YES;
}

-(IBAction)descriptionTabTapped:(id)sender{

#pragma comment in dev
    if (self.noComments) {
        self.noComments.hidden=YES;
    }
    self.descriptionTab.backgroundColor=self.commentsTab.backgroundColor;
    self.commentsTab.backgroundColor=[UIColor clearColor];
    NSString *description=[event objectForKey:@"event_detail"];
    if ([description isEqualToString:@""]) {
        self.description.text=@"This guy is really lazy. He didn't write anything in detail.";
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

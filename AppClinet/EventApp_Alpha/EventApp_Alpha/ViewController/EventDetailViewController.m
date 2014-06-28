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
#import "UIImageView+AFNetworking.h"
#undef MAXTAG
#define MAXTAG 104
@interface EventDetailViewController (){
    dispatch_queue_t queue;
    dispatch_semaphore_t semeaphore;
    
}
@property (strong,nonatomic) NSDictionary* event;
@property (strong,nonatomic) NSMutableArray* RSVPList;
@property (strong,nonatomic) NSMutableArray* likeList;
@property (strong,nonatomic) NSMutableArray* RSVPProfileIcons;

@property (weak, nonatomic) IBOutlet UIView *RSVPSpanArea;
@property (strong, nonatomic) IBOutlet UIImageView *RSVPProfileIconTemplate;
@property (strong, nonatomic) IBOutlet UILabel *RSVPProfileStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *descriptionTab;
@property (weak, nonatomic) IBOutlet UIButton *commentsTab;
@property (weak, nonatomic) IBOutlet UIView *detailSpanArea;
@property UITextField* noComments;
@property (weak, nonatomic) IBOutlet UIButton *RSVPbutton;
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
    [self cleanUpRSVPSpanArea];
    
    self.RSVPList=[NSMutableArray arrayWithCapacity:0];
    self.likeList=[NSMutableArray arrayWithCapacity:0];
    self.RSVPProfileIcons=[NSMutableArray arrayWithCapacity:0];
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

    
    [self fetchEvent];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)fetchEvent{
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
    
    [self getRSVPList];

}


-(void)getRSVPList{
    if (!queue) {
        queue=dispatch_queue_create("com.EventApp.EventDetailFetchModel", NULL);
    }
    //    if (!semeaphore) {
    //        semeaphore=dispatch_semaphore_create(0);
    //    }
    dispatch_async(queue, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetRSVPList) name:@"didGetRSVPList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailGetRSVPList) name:@"didFailGetRSVPList" object:nil];

        [jlmodel getRSVPList:event];
    });
}
-(void)didGetRSVPList{
    self.RSVPList=[EventJoinAndLikeModel RSVPList];
    [self updateRSVPProfileIcon];
    for (NSDictionary* record in self.RSVPList) {
        NSString* resourceURL=[[record valueForKey:@"fk_user"] valueForKey:@"resource_uri"];
        if ([[UserModel userResourceURL] isEqualToString:resourceURL]) {
            self.RSVPbutton.enabled=NO;
        }
    }
    
}
-(void)didFailGetRSVPList{
    self.RSVPProfileStateLabel.text=@"No RSVP";
    [self cleanUpRSVPSpanArea];
    [self.RSVPSpanArea addSubview:self.RSVPProfileStateLabel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD showError:@"Failed to get RSVPList"];
}

-(void)cleanUpRSVPSpanArea{
    for (UIView * view in [self.RSVPSpanArea subviews]) {
        [view removeFromSuperview];
    }
}

-(void)updateRSVPProfileIcon{
    if (self.RSVPList.count==0) {
        [self cleanUpRSVPSpanArea];
        self.RSVPProfileStateLabel.text=@"No RSVP.";
        [self.RSVPSpanArea addSubview:self.RSVPProfileStateLabel];
    }else{
        CGRect templateFrame=self.RSVPProfileIconTemplate.frame;
        [self cleanUpRSVPSpanArea];
        for (NSDictionary* RSVPRecord in self.RSVPList) {
            if ([self.RSVPList indexOfObject:RSVPRecord]<5) {
                UIImageView* RSVPProfileIcon=[[UIImageView alloc] initWithFrame:templateFrame];
                @try {
                    NSString* tragetURL=[[[URLConstructModel constructURLHeader] absoluteString] stringByAppendingFormat:@"%@",[[[RSVPRecord valueForKey:@"fk_user"] valueForKey:@"fk_user_image"] valueForKey:@"path"]];
                    [RSVPProfileIcon setImageWithURL:[NSURL URLWithString:tragetURL] placeholderImage:[UIImage imageNamed:@"152_152icon.png"]];
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"fail to get RSVP users' profile image");
                }
                RSVPProfileIcon.layer.cornerRadius=RSVPProfileIcon.bounds.size.width/2;
                RSVPProfileIcon.layer.masksToBounds=YES;
                [self.RSVPSpanArea addSubview:RSVPProfileIcon];
                templateFrame.origin.x=templateFrame.origin.x+templateFrame.size.width+10;
            }else{
                break;
            }
            
        }
        self.RSVPProfileStateLabel.text=@"RSVP";
        [self.RSVPSpanArea addSubview:self.RSVPProfileStateLabel];
    }
}

-(IBAction)RSVPEvent{
    [jlmodel rsvpEvent:event succeed:^(id message) {
        [self didRSVPEvent];
    } failed:^(id error) {
        [self didFailRSVPEvent:error];
    }];
}

-(void)didRSVPEvent{
    [self fetchEvent];
    [ProgressHUD showSuccess:@"RSVP succeed."];
}

-(void)didFailRSVPEvent:(id)error{
    [ProgressHUD showError:[error localizedDescription]];
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
        self.RSVP.text=@" ∞";
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
        [ImageModel downloadImageViaPath:[[event objectForKey:@"event_image"][0] objectForKey:@"path"] For:@"event" WithPrefix:@"" :self.images];
    }
    else{
        self.images.image=[UIImage imageNamed:@"event3.jpg"];
    }

}

-(IBAction)viewedPeopleTapped:(id)sender{
    UITapGestureRecognizer* tap=(UITapGestureRecognizer*)sender;
    NSUInteger i=[self.RSVPProfileIcons indexOfObject:tap.view];
    NSLog(@"%ld Tapped!",(long)i);
    ProfilePageViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"];
    vc.targetUser=self.RSVPList[i];
    [self.navigationController pushViewController:vc animated:YES];
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

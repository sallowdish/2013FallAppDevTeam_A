//
//  PageContentViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/10/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "PageContentViewController.h"
#import "ImageModel.h"
#import "EventDetailViewController.h"

#define MAXTAG 100

@interface PageContentViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UIImageView *genderSignImageView;

@end

@implementation PageContentViewController

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
//    UIScrollView* draftScrollView=self.scrollView;
    [self.scrollView removeFromSuperview];
    [self.scrollView setScrollEnabled:YES];
    
//    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height);
    if ([[UIScreen mainScreen] bounds].size.height==568) {
        CGSize size=CGSizeMake(self.scrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height-64-49);
        [self.scrollView setContentSize:size];
    }else{
        CGSize size=CGSizeMake(self.scrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
        [self.scrollView setContentSize:size];
    }
    
    //autoresize
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.scrollView.contentOffset=CGPointMake(0, -50);
    
    //model to view matching
    self.eventTitleLabel.text=self.eventTitle;
    self.eventDateLabel.text=self.eventDate;
    self.eventLocationLabel.text=self.eventLocation;
    self.eventLikeLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.eventLike];
    self.eventRSVPLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.eventRSVP];
    self.eventHosterLabel.text=[NSString stringWithFormat:@"%@",self.eventHoster];
    if (self.eventImage) {
        [ImageModel downloadImageViaPath:self.eventImage For:@"event" WithPrefix:@"" :self.eventImageView];
    }else{
        self.eventImageView.image=[UIImage imageNamed:@"event1.jpg"];
    }
    
    self.genderSignImageView.image=[self.event[@"fk_event_poster_user_gender"] isEqualToString:@"male"]?[UIImage imageNamed:@"MaleSign.png"]:[UIImage imageNamed:@"FemaleSign.png"];
    
    //polish
    [self setRoundConnerForViewWithMaxTag:MAXTAG];
    
//    self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.scrollView];
    
    self.pageController.currentPage=self.pageIndex;
    self.pageController.numberOfPages=self.pageTotalCount;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRoundConnerForViewWithMaxTag:(NSInteger)maxtag{
    for (int i=100; i<maxtag+1; i++) {
        UIView* subview=[self.view viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }
    
}
- (IBAction)evetImageTapped:(id)sender {
    [self performSegueWithIdentifier:@"RecToDetailPushSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"RecToDetailPushSegue"]) {
        EventDetailViewController* vc=(EventDetailViewController*)segue.destinationViewController;
        [vc setValue:self.event[@"id"] forKey:@"eventID"];
    }else{
        [super prepareForSegue:segue sender:sender];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
    
    
    //adjust the position of initial vc
    self.scrollView.contentInset=UIEdgeInsetsMake(64, 0, 49, 0);
    self.scrollView.contentOffset=CGPointMake(0, -50);
}

@end

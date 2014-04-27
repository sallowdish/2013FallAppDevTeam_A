//
//  PageContentViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/10/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "PageContentViewController.h"

#define MAXTAG 100

@interface PageContentViewController ()

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
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height*1.3)];
    //model to view matching
    self.eventTitleLabel.text=self.eventTitle;
    self.eventDateLabel.text=self.eventDate;
    self.eventLocationLabel.text=self.eventLocation;
    self.eventLikeLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.eventLike];
    self.eventRSVPLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.eventRSVP];
    self.eventHosterLabel.text=[NSString stringWithFormat:@"Hosted by %@",self.eventHoster];
    self.eventImageView.image=self.eventImage;
    //polish
    [self setRoundConnerForViewWithMaxTag:MAXTAG];
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

@end

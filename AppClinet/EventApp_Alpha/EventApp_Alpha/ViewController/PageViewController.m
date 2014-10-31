//
//  PageViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2/10/2014.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "PageViewController.h"
#import "EventListFetchModel.h"
#import "PageContentViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource>

@end

@implementation PageViewController

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
    EventListFetchModel* model=[[EventListFetchModel alloc] init];
    [model fetchRecommendEvents:^{
            [self setupInitialPage];
            
    }];
    self.view.backgroundColor=[UIColor whiteColor];
    [ProgressHUD show:@"Loading Recommend Event.."];
    
    
    
//    self.pageViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
}

-(void) setupInitialPage{
    self.eventList=[EventListFetchModel eventsList];
    self.dataSource=self;
    UIViewController* initialViewController=[self viewControllerAtIndex:0];
    if (initialViewController) {
        
        [self setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        //        [self.view addSubview:initialViewController.view];
        
    }else{
        UIViewController* alternativeViewController=[[UIViewController alloc]init];
        UILabel* msg=[[UILabel alloc] init];
        [msg setText:@"No Recommended Event for now."];
        msg.frame=CGRectMake(alternativeViewController.view.frame.size.width/2, alternativeViewController.view.frame.size.height/2, msg.frame.size.width, msg.frame.size.height);
        [alternativeViewController.view addSubview:msg];
        [self setViewControllers:@[] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    

    
    [ProgressHUD dismiss];

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.eventList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.eventList count] == 0) || (index >= [self.eventList count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    //    PageContentViewController *pageContentViewController = [[PageContentViewController alloc] init];
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    NSDictionary* event=(NSDictionary*)[self.eventList objectAtIndex:index];
    //TODO
    //match model to view
    pageContentViewController.event=event;
    pageContentViewController.eventTitle=[event objectForKey:@"event_title"];
    pageContentViewController.eventDate=[event objectForKey:@"event_date"];
    pageContentViewController.eventLocation=[event objectForKey:@"address_title"];
    pageContentViewController.eventHoster=[event objectForKey:@"fk_event_poster_user_name"];
    pageContentViewController.eventLike=[[event objectForKey:@"event_like"] integerValue];
    pageContentViewController.eventRSVP=[[event objectForKey:@"event_rsvp"] integerValue];
    NSArray* imageSet=[event objectForKey:@"event_image"];
    if (imageSet.count>0) {
        pageContentViewController.eventImage=[imageSet[0] objectForKey:@"path"];
    }else{
        pageContentViewController.eventImage=nil;
    }
    
    pageContentViewController.pageTotalCount=self.eventList.count;
    pageContentViewController.pageIndex = index;
    
    //    pageContentViewController.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    return pageContentViewController;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.eventList.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Page View Controller Data Source


@end

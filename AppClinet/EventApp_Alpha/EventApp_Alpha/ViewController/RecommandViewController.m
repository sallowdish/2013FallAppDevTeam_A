//
//  ViewController.m
//  BTGlassScrollViewExample
//
//  Created by Byte on 10/18/13.
//  Copyright (c) 2013 Byte. All rights reserved.
//

#define SIMPLE_SAMPLE NO


#import "RecommandViewController.h"
#import "EventListFetchModel.h"
#import "PageContentViewController.h"
#import "PageViewController.h"

@interface RecommandViewController ()

@end

@implementation RecommandViewController
{
    
}

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
    //TODO
    //Initial model
    EventListFetchModel* model=[[EventListFetchModel alloc] init];
    [model fetchEventList];
    self.eventList=[EventListFetchModel eventsList];
    
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    for (int i=1;i<5; i++) {
        [temp addObject:[UIImage imageNamed:[NSString stringWithFormat:@"event%d.jpg",i]]];
    }
    self.eventImages=[[NSArray alloc] initWithArray:temp];
    
    //Initial view
    self.pageViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource=self;
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //add page view controller to main page
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-45);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
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
    pageContentViewController.eventTitle=[event objectForKey:@"event_title"];
    pageContentViewController.eventDate=[event objectForKey:@"event_date"];
    pageContentViewController.eventLocation=[[event objectForKey:@"fk_address"] objectForKey:@"address_title"];
    pageContentViewController.eventHoster=[[event objectForKey:@"fk_event_poster_user"] objectForKey:@"username"];
    pageContentViewController.eventLike=[[event objectForKey:@"event_like"] integerValue];
    pageContentViewController.eventRSVP=[[event objectForKey:@"event_rsvp"] integerValue];
    pageContentViewController.eventImage=self.eventImages[index%4];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.eventList count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(IBAction)segementeationPressed:(id)sender{
    UISegmentedControl* seg=(UISegmentedControl*)sender;
    if ([seg selectedSegmentIndex]==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

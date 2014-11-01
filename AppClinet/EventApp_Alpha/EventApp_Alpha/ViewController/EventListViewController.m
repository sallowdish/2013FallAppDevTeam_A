	//
//  EventTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-10.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListViewController.h"
#import "EventListFetchModel.h"
#import "EventEdittingViewController.h"
#import "EventDetailViewController.h"
#import "TemplateTableCell.h"
#import "SegmentControllerCell.h"
#import "FormatingModel.h"
#import "ProgressHUD.h"
#import "UserModel.h"
#import "ColorStandarlizationModel.h"


@interface EventListViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (strong,nonatomic)EventListFetchModel* model;

@end

@implementation EventListViewController


@synthesize eventList,model;

bool isUpdated,isBasedOnTime;
NSString* placeHolder=@"Load More...";


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib{
    [[UINavigationBar appearance] setBarTintColor:[ColorStandarlizationModel colorWithHexString:@"1d77ef"]];
    [[UINavigationBar appearance] setAlpha:0.9];
    [[UITabBar appearance] setBarTintColor:[ColorStandarlizationModel colorWithHexString:@"1d77ef"]];
    [[UITabBar appearance] setAlpha:0.9];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isUpdated=false;
    isBasedOnTime=YES;
    eventList=nil;
    
    self.segmentController.selectedSegmentIndex=0;
    
    if(self.segmentController){
        self.segmentController.tintColor=[ColorStandarlizationModel colorWithHexString:@"1d77ef"];
        self.segmentController.alpha=0.75;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    model=[[EventListFetchModel alloc] init];
    [model fetchEventListFromFile];
    eventList=[EventListFetchModel eventsList];

    
    UIRefreshControl* f5=[[UIRefreshControl alloc] init];
    [f5 addTarget:self action:@selector(refreshEventList:) forControlEvents:UIControlEventValueChanged];
    f5.attributedTitle=[[NSAttributedString alloc]initWithString:@"再多一點點...(灬ºωº灬)"];
    
    self.refreshControl=f5;
    
    
    //to refresh the epage
    self.isNeedRefresh=1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToRefresh) name:@"needToRefreshList" object:nil];
    
}

-(void)needToRefresh{
    self.isNeedRefresh=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    self.tabBarController.tabBar.hidden=NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isNeedRefresh) {
        [self refreshEventList:self];
    }
}


-(void)fetchNewDataFromServer:(NSString*)mode :(void(^)(id para))completeBlock{
    [ProgressHUD show:@"Loading new events list..."];
    isUpdated=false;
    [self addFetchDataNotificationObserver];
    [model fetchEventListWithMode:mode];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(removeFromNSNotificationCenter) userInfo:nil repeats:NO];
    //    [self fetchNewDataFromServer];
    [[ProgressHUD class] performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
    
    if (completeBlock) {
        completeBlock(nil);
    }
}

-(void)didFetchNewDataFromServer:(NSNotification*) notif{
    if ([notif object]) {
        NSDictionary* result=(NSDictionary*)[notif object];
        eventList=result[@"eventList"];
        [self removeFetchDataNotifactionObserver];
        isUpdated=true;
        NSLog(@"%@",@"New List has fetched new data");
        if ([result[@"nextPage"] isEqual:[NSNull null]]) {
            placeHolder=@"No More Event";
        }
        if (self.isNeedRefresh) {
            self.isNeedRefresh=NO;
        }
        [self.refreshControl endRefreshing];
        [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"再多一點點...(灬ºωº灬)"]];
        [self.tableView reloadData];
    }else{
        [ProgressHUD showError:@"Failed to get event list"];
    }
    
}

-(void)didFailFetchNewDataFromServer:(id)notif{
    NSError* error=[notif object];
    [ProgressHUD showError:[error localizedDescription]];
    [self removeFetchDataNotifactionObserver];
}


-(void) removeFromNSNotificationCenter{
    if (isUpdated==false) {
        [self removeFetchDataNotifactionObserver];
    }
}

-(void)addFetchDataNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchNewDataFromServer:) name:@"didFetchEventListWithMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailFetchNewDataFromServer:) name:@"didFailFetchEventListWithMode" object:nil];
}

-(void)removeFetchDataNotifactionObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFetchEventListWithMode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFailFetchEventListWithMode" object:nil];
}

//-(void) dismissHub{
//    [ProgressHUD dismiss];
//}

//-(void)showHubwithMessage:(NSString*)msg{
//    [ProgressHUD show:msg];
//}
//
//-(void)showSucceedHUB{
//    [ProgressHUD showSuccess:@"Succeed."];
//}



- (IBAction)refreshEventList:(id)sender{
    //top indication
//    self.createButton.enabled=NO;
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"努力從四次元搬運中...才怪_(:з」∠)_"];
    
    //HUD indication
    //Functionality
    
    if (isBasedOnTime) {
        [self fetchNewDataFromServer:@"time" :nil];
    }
    else{
        [self fetchNewDataFromServer:@"hot" :nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [eventList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==[eventList count]) {
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIButton* button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        
        [button setTitle:[NSString stringWithFormat:@"%@",placeHolder] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loadNextPage:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:button];
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"cellTemplate";
        TemplateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        NSDictionary* event=[eventList objectAtIndex:indexPath.row];
        cell=[FormatingModel modelToViewMatch:cell ForRowAtIndexPath:indexPath eventInstance:event];
            return cell;
    }
}

-(IBAction)loadNextPage:(id)sender{
    [ProgressHUD show:@"Loading..."];

    [model fetchNextPage:nil complete:^{
        eventList=[EventListFetchModel eventsList];
        if ([[EventListFetchModel nextPage] isEqual:[NSNull null]]) {
            placeHolder=@"No More Event";
        }
        [self.tableView reloadData];
        [ProgressHUD showSuccess:@"Loading Finish."];
            } fail:^(NSError *error) {
        [ProgressHUD showError:[error localizedDescription]];
    }];
}

-(IBAction)segementationButtonPressed:(id)sender{
    UISegmentedControl* seg=(UISegmentedControl*)sender;
    if ([seg selectedSegmentIndex]==2) {
        seg.selectedSegmentIndex=2;
        [self performSegueWithIdentifier:@"eventListToEventRecommend" sender:nil];
    }else if ([seg selectedSegmentIndex]==1) {
        isBasedOnTime=false;
        [self refreshEventList:nil];
    }else if ([seg selectedSegmentIndex]==0)
    {
        isBasedOnTime=true;
        [self refreshEventList:nil];
    }
    placeHolder=@"Load More...";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [eventList count]) {
        return 65;
    }
    return 95;
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"EventLIstToEventDetail"]) {
        EventDetailViewController *destination=[segue destinationViewController];
        UITableViewCell* cell=sender;
        id obj=[eventList objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
        destination.eventID=[[obj valueForKey:@"id"] integerValue];
    }
}



-(IBAction)createButtonTapped:(id)sender{
    if ([UserModel isLogin]) {
        EventEdittingViewController* vc=(EventEdittingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventPage"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        LoginViewController* loginView=[[self.navigationController storyboard] instantiateViewControllerWithIdentifier:@"LoginPage"];
        [self.navigationController pushViewController:loginView animated:YES];
//    [self presentViewController:loginView animated:YES completion:nil];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

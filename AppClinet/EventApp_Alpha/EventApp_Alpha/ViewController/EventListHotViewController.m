//
//  EventTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-10.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListHotViewController.h"
#import "EventListFetchModel.h"
#import "EventEdittingViewController.h"
#import "TemplateTableCell.h"
#import "FormatingModel.h"
#import "ProgressHUD.h"
#import "UserModel.h"

@interface EventListHotViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;



@end

@implementation EventListHotViewController

@synthesize eventList,model;

bool isUpdated;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    isUpdated=false;
    eventList=nil;
    
    self.segmentController.selectedSegmentIndex=1;
    self.tabBarController.tabBar.hidden=NO;
    
    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //get the latest event list online
    
    model=[[EventListFetchModel alloc] init];
    [model fetchEventListFromFile];
    eventList=[EventListFetchModel eventsList];
    //    //no network or connection fails
    //    if (eventList.count==0) {
    //
    //        eventList=[EventListFetchModel eventsList];
    //        NSLog(@"%@",@"No Internet now.");
    //    }
    
    UIRefreshControl* f5=[[UIRefreshControl alloc] init];
    [f5 addTarget:self action:@selector(refreshEventList:) forControlEvents:UIControlEventValueChanged];
    f5.attributedTitle=[[NSAttributedString alloc]initWithString:@"再多一點點...(灬ºωº灬)"];
    
    self.refreshControl=f5;
    
    
    //start appearing
}


-(void)fetchNewDataFromServer:(NSString*)mode{
    [ProgressHUD show:@"Loading new events list..."];
    isUpdated=false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchNewDataFromServer:) name:@"didFetchEventListWithMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailFetchNewDataFromServer:) name:@"didFailFetchEventListWithMode" object:nil];
    [model fetchEventListWithMode:mode];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(removeFromNSNotificationCenter) userInfo:nil repeats:NO];
    //    [self fetchNewDataFromServer];
    [[ProgressHUD class] performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
}

-(void)didFetchNewDataFromServer:(NSNotification*) notif{
    if ([notif object]) {
        eventList=(NSArray*)[notif object];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        isUpdated=true;
        NSLog(@"%@",@"UPDATED");
    }
}

-(void)didFailFetchNewDataFromServer:(id)notif{
    NSError* error=[notif object];
    [ProgressHUD showError:[error localizedDescription]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    self.tabBarController.tabBar.hidden=NO;
}

-(void) removeFromNSNotificationCenter{
    if (isUpdated==false) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
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
    [self fetchNewDataFromServer:@"hot"];
    [self.tableView reloadData];
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
    //HUD dismiss
    [self.refreshControl performSelector:@selector(setAttributedTitle:) withObject:[[NSAttributedString alloc]initWithString:@"再多一點點...(灬ºωº灬)"] afterDelay:2.2];
    [[ProgressHUD class] performSelector:@selector(showSuccess:) withObject:@"Loading Finish" afterDelay:3];
    //    [self.createButton performSelector:@selector(setEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:5];
    
    
    //    [self performSelector:@selector(showHubwithMessage:) withObject:@"Loading Finsih" afterDelay:2];
    //    [self performSelector:@selector(dismissHub) withObject:nil afterDelay:3];
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
    return [eventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellTemplate";
    TemplateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* event=[eventList objectAtIndex:indexPath.row];
    cell=[FormatingModel modelToViewMatch:cell ForRowAtIndexPath:(NSIndexPath*)indexPath eventInstance:event];
    
    
    //    cell.hosterLabel.text=[NSString stringWithFormat:@"%@|%@|%@",
    //        [[event objectForKey:@"event_organizer_id"] objectForKey:@"account_user_name"],
    //        [(NSString*)[event objectForKey:@"event_time"] componentsSeparatedByString:@"T"][0],
    //        [event objectForKey:@"event_location"]];
    
    return cell;
}

-(IBAction)segementationButtonPressed:(id)sender{
    UISegmentedControl* seg=(UISegmentedControl*)sender;
    if ([seg selectedSegmentIndex]==2) {
//        seg.selectedSegmentIndex=2;
//        [self performSegueWithIdentifier:@"eventListToEventRecommend" sender:nil];
    }else if ([seg selectedSegmentIndex]==0) {
        seg.selectedSegmentIndex=0;
        UIViewController* vc=(UIViewController*)[self.navigationController presentedViewController];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [vc viewDidLoad];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"selectedSegue"]) {
        UIViewController *destination=[segue destinationViewController];
        UITableViewCell* cell=sender;
        id obj=[eventList objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
        [destination setValue:[obj valueForKey:@"id"] forKey:@"eventID"];
    }
}



-(IBAction)createButtonTapped:(id)sender{
    if ([UserModel isLogin]) {
        EventEdittingViewController* vc=(EventEdittingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventPage"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        LoginViewController* loginView=[[self.navigationController storyboard] instantiateViewControllerWithIdentifier:@"LoginPage"];
//        [self.navigationController pushViewController:loginView animated:YES];
        [self presentViewController:loginView animated:YES completion:nil];
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

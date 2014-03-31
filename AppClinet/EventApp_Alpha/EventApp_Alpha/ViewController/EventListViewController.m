	//
//  EventTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-10.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListViewController.h"
#import "EventListFetchModel.h"
#import "TemplateTableCell.h"
#import "FormatingModel.h"
#import "ProgressHUD.h"

@interface EventListViewController ()

@end

@implementation EventListViewController

@synthesize eventList;

bool isUpdated;
EventListFetchModel* model;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
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


-(void)fetchNewDataFromServer{
    [ProgressHUD show:@"Loading new events list..."];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchNewDataFromServer:) name:@"didFetchEventListWithMode" object:nil];
    [model fetchEventListWithMode:@"time"];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(removeFromNSNotificationCenter) userInfo:nil repeats:NO];
    //    [self fetchNewDataFromServer];
    [[ProgressHUD class] performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
}

-(void)didFetchNewDataFromServer:(NSNotification*) notif{
    if ([notif object]) {
        eventList=(NSArray*)[notif object];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        isUpdated=true;
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [self fetchNewDataFromServer];
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
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"努力從四次元搬運中...才怪_(:з」∠)_"];
    
    //HUD indication
    //Functionality
    [self fetchNewDataFromServer];
    [self.tableView reloadData];
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
    //HUD dismiss
    [self.refreshControl performSelector:@selector(setAttributedTitle:) withObject:[[NSAttributedString alloc]initWithString:@"再多一點點...(灬ºωº灬)"] afterDelay:2.2];
    [[ProgressHUD class] performSelector:@selector(showSuccess:) withObject:@"Loading Finish" afterDelay:2];
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
    cell=[self modelToViewMatch:cell eventInstance:event];
    cell.profileImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"event%d.jpg",(indexPath.row)%4+1]];

//    cell.hosterLabel.text=[NSString stringWithFormat:@"%@|%@|%@",
//        [[event objectForKey:@"event_organizer_id"] objectForKey:@"account_user_name"],
//        [(NSString*)[event objectForKey:@"event_time"] componentsSeparatedByString:@"T"][0],
//        [event objectForKey:@"event_location"]];
    
    return cell;
}

-(IBAction)segementationButtonPressed:(id)sender{
    UISegmentedControl* seg=(UISegmentedControl*)sender;
    if ([seg selectedSegmentIndex]==2) {
        seg.selectedSegmentIndex=0;
        [self performSegueWithIdentifier:@"eventListToEventRecommend" sender:nil];
    }
}

-(TemplateTableCell*)modelToViewMatch:(id)sender eventInstance:(NSDictionary*)event
{
    
    TemplateTableCell* cell=(TemplateTableCell*)sender;
    for (int i=101; i<MAXTAG+1; i++) {
        UIView* subview=[cell viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }
//    [cell.profileImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
//    [cell.profileImage.layer setBorderWidth: 2.0];
    cell.eventNameLabel.text=[event objectForKey:@"event_title"];
    cell.hosterLabel.text=[[event objectForKey:@"fk_event_poster_user"] objectForKey:@"username"];
    cell.dataLabel.text=[NSString stringWithFormat:@"%@ | %@",[event objectForKey:@"event_date"],[event objectForKey:@"event_time"]];
    cell.locationLabel.text=[FormatingModel addressDictionaryToStringL:[event objectForKey:@"fk_address"]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"selectedSegue"]) {
        UIViewController *destination=[segue destinationViewController];
        UITableViewCell* cell=sender;
        id obj=[eventList objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
        [destination setValue:[obj valueForKey:@"id"] forKey:@"eventID"];
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

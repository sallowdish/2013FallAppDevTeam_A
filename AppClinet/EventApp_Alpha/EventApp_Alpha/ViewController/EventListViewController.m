	//
//  EventTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-10-10.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventListViewController.h"
#import "EventListFetchModel.h"

@interface EventListViewController ()

@end

@implementation EventListViewController

@synthesize eventList;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //get the latest event list online
    EventListFetchModel* model=[[EventListFetchModel alloc] init];
    [model fetchEventList];
    
    
//    //Get the filepath for local json file
//    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Events.json"];
//    
//
//    
//    
//    //Load json string from the local file
//    if(error){
//        NSLog(@"Error loading json file:%@",[error localizedDescription]);
//    }
//    eventList=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filepath] options:NSJSONReadingMutableContainers error:&error];
//    if(error){
//        NSLog(@"Error loading json file:%@",[error localizedDescription]);
//    }
    eventList=[EventListFetchModel eventsList];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* event=[eventList objectAtIndex:indexPath.row];
    [cell.textLabel setText:[event objectForKey:@"event_name"]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@|%@|%@",
        [[event objectForKey:@"event_organizer_id"] objectForKey:@"account_user_name"],
        [(NSString*)[event objectForKey:@"event_time"] componentsSeparatedByString:@"T"][0],
        [event objectForKey:@"event_location"]];
    
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

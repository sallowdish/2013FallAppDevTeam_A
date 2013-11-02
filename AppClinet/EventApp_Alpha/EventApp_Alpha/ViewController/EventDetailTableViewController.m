//
//  EventDetailTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-02.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import "EventFetchModel.h"

@interface EventDetailTableViewController ()

@end

@implementation EventDetailTableViewController

@synthesize eventName,eventHoster,eventDate,eventPlace,eventCapcity,event,eventID;

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
    
    [EventFetchModel fetchEventWithEventID:eventID Error:nil];
    
    NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EventDetails.json"];
    
    event=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filepath] options:NSJSONReadingAllowFragments error:nil];
    
    
    
    eventName.text=[event valueForKey:@"Name"];
    eventHoster.text=[event valueForKey:@"Hoster"];
    eventDate.text=[event valueForKey:@"Time"];
    eventPlace.text=[event valueForKey:@"Location"];
    eventCapcity.text=[NSString stringWithFormat:@"%@",(NSNumber*)[event valueForKey:@"Capcity"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

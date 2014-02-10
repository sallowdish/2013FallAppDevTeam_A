//
//  EventEdittingViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-19.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventEdittingViewController.h"
//#import "EventPostModel.h"

@interface EventEdittingViewController ()
@property NSDate *time,*date;
@end

@implementation EventEdittingViewController

@synthesize time,date;

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
    UIDatePicker *datePicker=[[UIDatePicker alloc]init]
        ,*timePicker=[[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker addTarget:self action:@selector(datePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
    [timePicker addTarget:self action:@selector(timePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateInputTextField.inputView=datePicker;
    self.timeFromInputTextField.inputView=timePicker;
    self.timeToInputTextField.inputView=timePicker;
    [self.timeFromInputTextField addTarget:self action:@selector(didFinishTimeEditting:) forControlEvents:UIControlEventEditingDidEnd];
    [self.timeToInputTextField addTarget:self action:@selector(didFinishTimeEditting:) forControlEvents:UIControlEventEditingDidEnd];
    [self.dateInputTextField addTarget:self action:@selector(didFinishDateEditting:) forControlEvents:UIControlEventEditingDidEnd];
}


-(IBAction)datePickerDidChanged:(id)sender{
    date=[sender date];
}

-(IBAction)timePickerDidChanged:(id)sender{
    time=[sender date];
}

-(IBAction)didFinishTimeEditting:(id)sender{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
//    UITextField* tf=(UITextField*)sender;
//    sender.text=[formatter stringFromDate:time];
    [(UITextField*)sender setText:[formatter stringFromDate:time]];
}

-(IBAction)didFinishDateEditting:(id)sender{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    [(UITextField*)sender setText: [formatter stringFromDate:date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender{
//    [self constructRequest];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary*)packUpInfo{
    NSDictionary* info=[[NSDictionary alloc]init];
    [info setValue:self.titleInputTextField.text forKey:@"event_title"];
    [info setValue:self.dateInputTextField.text forKey:@"event_date"];
    [info setValue:self.timeFromInputTextField.text forKey:@"event_time"];
    [info setValue:self.detailInputTextField.text forKey:@"event_detail"];
    return info;
}

//- (void)constructRequest{
//    EventPostModel* model=[[EventPostModel alloc] init];
//    [model postEventWithRequest:[EventPostModel constructPostRequestWithJsonData:[[NSData alloc] init]]];
//}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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

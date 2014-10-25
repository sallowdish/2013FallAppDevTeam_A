//
//  MyEventTableViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-05-08.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "MyEventTableViewController.h"
#import "FormatingModel.h"
#import "EventListFetchModel.h"
#import "EventDeleteModel.h"
#import "ProgressHUD.h"
#import "popoverAlterModel.h"

@interface MyEventTableViewController ()

@end

@implementation MyEventTableViewController

NSArray* myEventList;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    model=[[EventListFetchModel alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchMyEventList) name:@"didFetchEventListWithMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailFetchMyEventList:) name:@"didFailFetchEventListWithMode" object:nil];

    [model fetchEventListWithUser];
}


-(void)didFetchMyEventList{
    myEventList= [EventListFetchModel eventsList];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)didFailFetchMyEventList:(NSNotification*)notif{
    NSError* error=[notif object];
    [ProgressHUD showError:[error localizedDescription]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return [myEventList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTemplate" forIndexPath:indexPath];
    NSDictionary* currEvent=[myEventList objectAtIndex:indexPath.row];
    cell=[FormatingModel modelToViewMatch:cell ForRowAtIndexPath:(NSIndexPath*) indexPath eventInstance:currEvent];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [ProgressHUD show:@"Deleteing.."];
        EventDeleteModel* model=[[EventDeleteModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteSelectedEvent) name:@"didDeleteEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailedDeleteEvent) name:@"didFailedDeleteEvent" object:nil];
        [model deleteEvent:myEventList[indexPath.row]];
    }
}

-(void) didDeleteSelectedEvent{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self viewDidLoad];
    [ProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"needToRefreshList" object:nil];

}

-(void) didFailedDeleteEvent{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [popoverAlterModel alterWithTitle:@"Failed" Message:@"Please try again later."];
    [ProgressHUD dismiss];
}

@end

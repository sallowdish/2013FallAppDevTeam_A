//
//  CommentsSpanArea.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-08-22.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "CommentsSpanArea.h"
#import "CommentsTableViewController.h"
#import "NewCommentTableViewCell.h"
#import "UserModel.h"
#import "ProgressHUD.h"

@interface CommentsSpanArea ()<UITextFieldDelegate>

@end

@implementation CommentsSpanArea

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
}

-(void)passCommentsToDisplay{
    CommentsTableViewController* vc=self.childViewControllers[0];
    vc.comments=self.comments;
    [self.tableView reloadData];
    [vc.tableView reloadData];
    
}


-(void)insertLocalTable:(NSMutableDictionary*)comment{
//make up the profile image for local usage
    comment[@"fk_comment_poster_user_profile_image"]=[UserModel current_user][@"fk_user_image"][@"path"];
    
    NSMutableArray *newList=[NSMutableArray arrayWithObject:comment];
    [newList addObjectsFromArray:self.comments];
    self.comments=newList;

    CommentsTableViewController* vc=self.childViewControllers[0];
    vc.comments=self.comments;
    [vc.tableView reloadData];
}

-(void)postToServer:(NSDictionary*)comment{
    AFHTTPRequestOperationManager* mgr=[URLConstructModel authorizedJsonManger];
    NSString* commentListURL=[NSString stringWithFormat:@"%@%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,API,@"/eventcomment/?format=json"];
    
    [mgr POST:commentListURL parameters:comment success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD showSuccess:@"Your comment has been posted."];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"Fail to post new comment, %@",[error localizedDescription]]];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (![UserModel isLogin]) {
        [UserModel popupLoginViewToViewController:self complete:^(UIViewController* vc){
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSMutableDictionary* comment=[NSMutableDictionary dictionaryWithDictionary:@{@"comment_detail":textField.text,@"fk_event":self.event[@"resource_uri"],@"fk_comment_poster_user":[UserModel userResourceURL]}];
    
    [self insertLocalTable:comment];
    
    [self postToServer:comment];
    return TRUE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld--%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.row==0) {
        return 60*self.comments.count;
    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

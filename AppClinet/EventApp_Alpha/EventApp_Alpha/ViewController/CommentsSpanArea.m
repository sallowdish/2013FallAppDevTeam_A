//
//  CommentsSpanArea.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-08-22.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "CommentsSpanArea.h"
#import "NewCommentTableViewCell.h"
#import "UserModel.h"
#import "ProgressHUD.h"
#import "EventDetailViewController.h"
#import "CommentsCellTableViewCell.h"
#import "IQKeyboardManager.h"
#import "ProfilePageViewController.h"


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
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    
}

-(void)passCommentsToDisplay{
//    CommentsTableViewController* vc=self.childViewControllers[0];
//    vc.comments=self.comments;
    [self.tableView reloadData];
//    [vc.tableView reloadData];
    
}


-(void)insertLocalTable:(NSMutableDictionary*)comment{
//make up the profile image for local usage
    comment[@"fk_comment_poster_user_profile_image"]=[UserModel current_user][@"fk_user_image"][@"path"];
    
    NSMutableArray *newList=[NSMutableArray arrayWithObject:comment];
    [newList addObjectsFromArray:self.comments];
    self.comments=newList;

//    CommentsTableViewController* vc=self.childViewControllers[0];
//    vc.comments=self.comments;
    [self.tableView reloadData];
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
    EventDetailViewController* vc= (EventDetailViewController*)self.parentViewController;
//    cgp=[textField convertPoint:textField.center toView:nil];
    
    [vc.scrollView setContentOffset:CGPointMake(0, 180)];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    textField.text=nil;
    return true;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSMutableDictionary* comment=[NSMutableDictionary dictionaryWithDictionary:@{@"comment_detail":textField.text,@"fk_event":self.event[@"resource_uri"],@"fk_comment_poster_user":[UserModel userResourceURL]}];
    
    textField.text=nil;
    
    [self insertLocalTable:comment];
    
    [self postToServer:comment];
    return TRUE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
    {
        return 50;
    }
    else if (indexPath.row>0) {
        return [self calculateDynamicCellHeight:indexPath];
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
    
    return [self.comments count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    if (indexPath.row>0) {
        cell= [self prepareCommentCell:self.comments[indexPath.row-1]];
    }
    else{
        cell= [self.tableView dequeueReusableCellWithIdentifier:@"MyCommentCell"];
    }
    return cell;
}

-(CGFloat)calculateDynamicCellHeight:(NSIndexPath*)indexPath{
    NSString* comment_detail=self.comments[indexPath.row-1][@"comment_detail"];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
    NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    CGSize stringSize=[comment_detail sizeWithAttributes:userAttributes];
    
    
    double numLine=(double)stringSize.width/185;
    
    numLine=ceil(numLine);
    CGFloat height=50+20*(numLine-1);
    return height;
}

-(UITableViewCell*)prepareCommentCell:(NSDictionary*)comment{
    CommentsCellTableViewCell *cell = (CommentsCellTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"CommentCell" ];
    
    [cell fillCommentContent:comment];
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"CommentToProfile"]) {
        ProfilePageViewController* vc=(ProfilePageViewController*)[segue destinationViewController];
        UIView *parent = [sender superview];
        while (parent && ![parent isKindOfClass:[UITableViewCell class]]) {
            parent = parent.superview;
        }
        
        CommentsCellTableViewCell *cell = (CommentsCellTableViewCell *)parent;
        
        
        vc.userID=cell.commentPosterID;
    }else{
        [super prepareForSegue:segue sender:sender];
    }
}


@end

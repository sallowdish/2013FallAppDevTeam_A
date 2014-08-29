//
//  CommentsCellTableViewCell.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-08-19.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsCellTableViewCell : UITableViewCell
-(void)fillCommentContent:(NSDictionary*) comment;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentPosterProfile;
@property NSInteger numofLines;


@end

//
//  NewCommentTableViewCell.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-08-22.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "NewCommentTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UserModel.h"

@interface NewCommentTableViewCell(){
}

@end

@implementation NewCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.myProfile.layer.cornerRadius=self.myProfile.frame.size.height/2;
    self.myProfile.layer.masksToBounds=YES;
    
    if ([UserModel isLogin]) {
        NSString* profileImagePath=[UserModel current_user][@"fk_user_image"][@"path"];
        NSString* fullPath=[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,profileImagePath];
        [self.myProfile setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:[UIImage imageNamed:@"152_152icon.png"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

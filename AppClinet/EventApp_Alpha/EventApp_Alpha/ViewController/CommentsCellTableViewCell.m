//
//  CommentsCellTableViewCell.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-08-19.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "CommentsCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"

#define COMMENTLABELLINEHEIGHT 20



@implementation CommentsCellTableViewCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillCommentContent:(NSDictionary*) comment{
    UILabel* label=self.commentLabel;
    
    UIImageView* imageView=self.commentPosterProfile;
    
    //set up for image view
    //set round conner
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
    
    //move to the middle of the line
    imageView.center=CGPointMake(imageView.center.x, 10+imageView.frame.size.height/2);
    
    //set up for label
    //set multiple line
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    

    
    //load data
    if (comment[@"fk_comment_poster_user_profile_image"]) {
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,WEBSERVICENAME,comment[@"fk_comment_poster_user_profile_image"]]]]; placeholderImage:[UIImage imageNamed:@"152_152icon.png"];
    }else{
        [imageView setImage:[UIImage imageNamed:@"152_152icon.png"]];
    }
    
    
    label.text=comment[@"comment_detail"];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
    NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    CGSize stringSize=[label.text sizeWithAttributes:userAttributes];
    
    
    double numLine=(double)stringSize.width/185;
    
    numLine=ceil(numLine);
    
    self.numofLines=numLine;
    
    NSInteger height=numLine*COMMENTLABELLINEHEIGHT;
    if (label.frame.size.height!=height) {
        label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
    }
    
}

@end

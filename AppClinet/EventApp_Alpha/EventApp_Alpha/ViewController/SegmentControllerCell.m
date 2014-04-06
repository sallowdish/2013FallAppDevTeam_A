//
//  SegmentControllerCell.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-04.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "SegmentControllerCell.h"

@implementation SegmentControllerCell

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

@end

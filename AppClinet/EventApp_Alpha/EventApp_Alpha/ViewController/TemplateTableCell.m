//
//  TemplateTableCell.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-12-15.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "TemplateTableCell.h"
#import "ColorStandarlizationModel.h"



@implementation TemplateTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)prepareApprence{
    [self setRoundCorners];
    [self setShadow];
}

-(void)setRoundCorners{
//    NSLog(@"%@",self);
    for (UIView* view in _needRoundCorner) {
        view.layer.cornerRadius=view.bounds.size.height*0.15;
    }
}

-(void)setShadow{
    //    NSLog(@"%@",self);
    for (UIView* view in _needShadow) {
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        view.layer.masksToBounds = NO;
        view.layer.shadowColor=[ColorStandarlizationModel colorWithHexString:@"B8C4CC"].CGColor;
//        view.layer.cornerRadius = 8; // if you like rounded corners
        view.layer.shadowOffset = CGSizeMake(20.0f, 0.0f);
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 0.5;
        
        
    }
}
@end

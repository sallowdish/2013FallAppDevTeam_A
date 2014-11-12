//
//  TemplateTableCell.h
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-12-15.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexagonUIImageView.h"

#define MAXTAG 101

@interface TemplateTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hosterLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet HexagonUIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *RSVPLabel;
@property (weak, nonatomic) IBOutlet UIImageView *EventPosterGenderSignImageView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *needRoundCorner;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *needShadow;
-(void)prepareApprence;
@end

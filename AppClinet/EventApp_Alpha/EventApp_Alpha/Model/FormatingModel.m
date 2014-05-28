//
//  FormatingModel.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-01-01.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "FormatingModel.h"
#import "ImageModel.h"


@implementation FormatingModel

+(NSArray*)pythonDateTimeToStringArray:(NSString*)pythonDateTimeInfo
{
    NSMutableArray* datetimeInfo=[[NSMutableArray alloc] initWithArray:[pythonDateTimeInfo componentsSeparatedByString:@"T"]];
    datetimeInfo[1]=[datetimeInfo[1] substringToIndex:5];
    return datetimeInfo;
}

+(NSString*)addressDictionaryToStringL:(NSDictionary*)address
{
//    return [NSString stringWithFormat:@"%@,%@,%@,%@",[address objectForKey:@"address_detail"],[address objectForKey:@"address_city"],[address objectForKey:@"address_region"],[address objectForKey:@"address_country"]];
    return [address objectForKey:@"address_title"];
    
}


+(TemplateTableCell*)modelToViewMatch:(id)sender ForRowAtIndexPath:(NSIndexPath *)indexPath eventInstance:(NSDictionary*)event
{
    
    TemplateTableCell* cell=(TemplateTableCell*)sender;
    for (int i=101; i<MAXTAG+1; i++) {
        UIView* subview=[cell viewWithTag:i];
        subview.layer.cornerRadius=6;
        subview.layer.masksToBounds=YES;
    }
    //    [cell.profileImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
    //    [cell.profileImage.layer setBorderWidth: 2.0];
    cell.eventNameLabel.text=[event objectForKey:@"event_title"];
    
//    cell.hosterLabel.text=[[event objectForKey:@"fk_event_poster_user"] objectForKey:@"username"];
    cell.dataLabel.text=[NSString stringWithFormat:@"%@ | %@",[event objectForKey:@"event_date"],[event objectForKey:@"event_time"]];
//    cell.locationLabel.text=[FormatingModel addressDictionaryToStringL:[event objectForKey:@"fk_address"]];
    cell.likeLabel.text=[NSString stringWithFormat: @"%@",[event objectForKey:@"event_like_count"] ];
    cell.RSVPLabel.text=[NSString stringWithFormat: @"%@",[event objectForKey:@"event_rsvp_count"] ];;
    
    
    //newer matching
    cell.hosterLabel.text=[event objectForKey:@"fk_event_poster_user_name"];
    cell.locationLabel.text=[event objectForKey:@"address_country"];
    
    UIImage* img=[ImageModel downloadImageViaPath:[event objectForKey:@"fk_event_poster_user_fk_user_image"]];
    cell.profileImage.image=img;
    return cell;
}

@end


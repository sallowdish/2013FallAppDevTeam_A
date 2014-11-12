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

    //    [cell.profileImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
    //    [cell.profileImage.layer setBorderWidth: 2.0];
    cell.eventNameLabel.text=[NSString stringWithFormat:@" %@",[event objectForKey:@"event_title"]];
    
    cell.dataLabel.text=[NSString stringWithFormat:@"%@ | %@",[event objectForKey:@"event_date"],[event objectForKey:@"event_time"]];

    cell.likeLabel.text=[NSString stringWithFormat: @"%@",[event objectForKey:@"event_like_count"] ];
    cell.RSVPLabel.text=[NSString stringWithFormat: @"%@",[event objectForKey:@"event_rsvp_count"] ];;
    
    
    //newer matching
    cell.hosterLabel.text=[event objectForKey:@"fk_event_poster_user_name"];
    cell.locationLabel.text=[event objectForKey:@"address_title"];
    
//    UIImage* img=[ImageModel downloadImageViaPath:[event objectForKey:@"fk_event_poster_user_fk_user_image"] For:@"user" WithPrefix:MEDIAPREFIX];
//    NSURL* targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",HTTPPREFIX,WEBSERVICEDOMAIN,MEDIAPREFIX,]];
    if ([event[@"fk_event_poster_user_gender"] isEqual:[NSNull null]]||([event[@"fk_event_poster_user_gender"] isEqualToString:@"female"]))
    {
        cell.EventPosterGenderSignImageView.image=[UIImage imageNamed:@"FemaleSign.png"];
    }else{
        cell.EventPosterGenderSignImageView.image=[UIImage imageNamed:@"MaleSign.png"];
    }
    
    
    //set profile image to hexagon
//    cell.profileImage.layer.cornerRadius=0;
    [cell.profileImage prepareApprence];
    
    [ImageModel downloadImageViaPath:[event valueForKey:@"fk_event_poster_user_fk_user_image"] For:@"user" WithPrefix:MEDIAPREFIX :cell.profileImage];
//    [cell.profileImage setImageWithURL:targetURL  placeholderImage:[UIImage imageNamed:@"152_152icon.png"]];
    return cell;
}

@end


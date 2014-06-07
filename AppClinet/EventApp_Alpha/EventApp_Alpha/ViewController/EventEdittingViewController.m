//
//  EventEdittingViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2013-11-19.
//  Copyright (c) 2013 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "EventEdittingViewController.h"
#import "EventPostModel.h"
#import "popoverAlterModel.h"
#import "ProgressHUD.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageUploadModel.h"
#import "EventListViewController.h"
#import "UserModel.h"

@interface EventEdittingViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (weak, nonatomic) IBOutlet UIButton *photoAddButton;
@property (weak, nonatomic) IBOutlet UIView *photoSpanView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *surfaceUnion;
@property (strong,nonatomic) NSDictionary* address;
@property GKImagePicker* imagePicker;
@end

@implementation EventEdittingViewController

static NSMutableData* responseData;

NSMutableArray* selectedPhoto,*selectedPhotoView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(IBAction)editLocation:(id)sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewAddress:) name:@"didCreateNewAddress" object:nil];
    id vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddressInfoPage"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didCreateNewAddress:(NSNotification*) notif{
    NSDictionary* dic=(NSDictionary*)[notif object];
    self.locationTextField.text=[dic objectForKey:@"address_title"];
//    self.locationResourceURL=[dic objectForKey:@"event_resourceurl"];
    self.address=dic;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //initialize class variable
    selectedPhoto=[[NSMutableArray alloc] init];
    selectedPhotoView=[[NSMutableArray alloc] init];
    
    
    //Functionality setup
    UIDatePicker *datePicker=[[UIDatePicker alloc]init]
        ,*timePicker=[[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [timePicker setDatePickerMode:UIDatePickerModeTime];

    
    self.dateInputTextField.inputView=datePicker;
    self.timeFromInputTextField.inputView=timePicker;

    [self.timeFromInputTextField addTarget:self action:@selector(didFinishTimeEditting:) forControlEvents:UIControlEventEditingDidEnd];

    [self.dateInputTextField addTarget:self action:@selector(didFinishDateEditting:) forControlEvents:UIControlEventEditingDidEnd];
    
    UITapGestureRecognizer* editLocationTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editLocation:)];
    editLocationTap.numberOfTapsRequired=1;
    [self.locationTextField addGestureRecognizer:editLocationTap];
    
    
    UITapGestureRecognizer* dismissKeyBoardTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    dismissKeyBoardTap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:dismissKeyBoardTap];
}


-(void)dismissKeyBoard{
    [self.view endEditing:YES];
}

-(IBAction)imagePickerPopup:(id)sender{
    self.imagePicker = [[GKImagePicker alloc] init];
//    self.imagePicker.cropSize = CGSizeMake(320, 90);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}



-(void)updateSelectedImage{
    int basex=self.photoAddButton.frame.origin.x;
//    for (UIImageView* i in selectedPhotoView) {
//        [i removeFromSuperview];
//    }
    [selectedPhotoView removeAllObjects];
    for (int i=0; i<selectedPhoto.count; i++) {
        UIImage* current_image=selectedPhoto[i];
        UIImageView* view=[[UIImageView alloc] initWithFrame:CGRectMake(basex, 5, 50, 50)];
        view.image=current_image;
        [self.photoSpanView addSubview:view];
        [selectedPhotoView addObject:view];
        basex+=55;
    }
//    [selectedPhoto removeAllObjects];
    
    if (selectedPhotoView.count<3) {
        CGRect newFrame=self.photoAddButton.frame;
        newFrame.origin.x=basex+5;
        self.photoAddButton.frame=newFrame;
    }
    else{
        [self.photoAddButton removeFromSuperview];
    }
}


//-(IBAction)datePickerDidChanged:(id)sender{
//    date=[sender date];
//}
//
//-(IBAction)timePickerDidChanged:(id)sender{
//    time=[sender date];
//}

-(IBAction)didFinishTimeEditting:(id)sender{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    UITextField* tf=(UITextField*)sender;
    UIDatePicker* picker=(UIDatePicker*)tf.inputView;
//    sender.text=[formatter stringFromDate:time];
    [(UITextField*)sender setText:[formatter stringFromDate:[picker date]]];
}

-(IBAction)didFinishDateEditting:(id)sender{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    UITextField* tf=(UITextField*)sender;
    UIDatePicker* picker=(UIDatePicker*)tf.inputView;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [(UITextField*)sender setText: [formatter stringFromDate:[picker date]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender{
    if ([self isAllRequiredFilled]) {
        [ProgressHUD show:@"Uploading..."];
        NSMutableDictionary* dic=[self packUpInfo];
        //    if (notif) {
        //        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didUploadImage" object:nil];
        //
        //        [dic setObject:[NSString stringWithFormat:@"%@",[notif object]] forKey:@"event_image_name"];
        //    }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewEvent:) name:@"didCreateNewEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewEventFailed) name:@"didCreateNewEventFailed" object:nil];
        EventPostModel* model=[[EventPostModel alloc] init];
        [ProgressHUD show:@"Submitting new event..."];
        [model postEventwithInfo:dic];
    }
    else{
        [popoverAlterModel alterWithTitle:@"Warning" Message:@"Please fill up all required fields."];
    }
}


-(void)didFinishUploadImage:(NSNotification*) notif{
//    NSMutableDictionary* dic=[self packUpInfo];
//    if (notif) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didUploadImage" object:nil];
//        
//        [dic setObject:[NSString stringWithFormat:@"%@",[notif object]] forKey:@"event_image_name"];
//    }
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewEvent) name:@"didCreateNewEvent" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewEventFailed) name:@"didCreateNewEventFailed" object:nil];
//    EventPostModel* model=[[EventPostModel alloc] init];
//    [ProgressHUD show:@"Submitting new event..."];
//    [model postEventwithInfo:dic];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    [(EventListViewController*)[self.navigationController presentedViewController] refreshEventList:nil];
    [popoverAlterModel alterWithTitle:@"Succeed" Message:@"You have created a new event, please reload the event list page."];
}

-(BOOL)isAllRequiredFilled{
    return !([self.titleInputTextField.text isEqualToString:@""]||[self.dateInputTextField.text isEqualToString:@""]||[self.timeFromInputTextField.text isEqualToString:@""]||[self.address isEqual:[NSNull null]]);
}

-(void)didCreateNewEvent:(NSNotification*)notif{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [ProgressHUD dismiss];
//    [self.navigationController popViewControllerAnimated:YES];
//    [(EventListViewController*)[self.navigationController presentedViewController] refreshEventList:nil];
//    [popoverAlterModel alterWithTitle:@"Succeed" Message:@"You have created a new event, please reload the event list page."];
    NSString* location=(NSString*)[notif object];
    NSString* fk_event=[[location stringByReplacingOccurrencesOfString:HTTPPREFIX withString:@""] stringByReplacingOccurrencesOfString:WEBSERVICEDOMAIN withString:@""];

    if (selectedPhoto.count>0) {
        [ProgressHUD show:@"Uploading Image..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishUploadImage:) name:@"didUploadImage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailUploadImage) name:@"didFailUploadImage" object:nil];
        ImageUploadModel* uploadModel=[[ImageUploadModel alloc] init];
        [uploadModel uploadEventImage:selectedPhoto[0] Event:fk_event];
//        [uploadModel uploadImage:selectedPhoto[0] User:[UserModel username]];
        return;
    }
    else{
        [self didFinishUploadImage:nil];
    }
}

-(void)didFailUploadImage{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    [popoverAlterModel alterWithTitle:@"Error" Message:@"Fail to upload the event image."];
    [self.navigationController popViewControllerAnimated:YES];
    [(EventListViewController*)[self.navigationController presentedViewController] refreshEventList:nil];

}

-(void)didCreateNewEventFailed{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    [popoverAlterModel alterWithTitle:@"Failed" Message:@"Failed to create new event, please try again."];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableDictionary*)packUpInfo{
    NSMutableDictionary* info=[[NSMutableDictionary alloc]init];
    [info setValue:self.titleInputTextField.text forKey:@"event_title"];
    [info setValue:self.dateInputTextField.text forKey:@"event_date"];
    [info setValue:self.timeFromInputTextField.text forKey:@"event_time"];
    [info setValue:self.detailInputTextField.text forKey:@"event_detail"];
    [info setValue:@([self.capacityInputTextField.text integerValue]) forKey:@"event_capacity"] ;
    [info setValue:[self.address objectForKey:@"address_city"] forKey:@"address_city"];
    [info setValue:[self.address objectForKey:@"address_country"] forKey:@"address_country"];
    [info setValue:[self.address objectForKey:@"address_detail"] forKey:@"address_detail"];
    [info setValue:[self.address objectForKey:@"address_postal_code"] forKey:@"address_postal_code"];
    [info setValue:[self.address objectForKey:@"address_region"] forKey:@"address_region"];
    [info setValue:[self.address objectForKey:@"address_title"] forKey:@"address_title"];
    return info;

}


- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    [selectedPhoto removeAllObjects];
    [selectedPhoto addObject:image];
    [self hideImagePicker];
    [self updateSelectedImage];
}

- (void)hideImagePicker{
    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [selectedPhoto addObject:image];
        
    [picker dismissViewControllerAnimated:YES completion:nil];
        
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

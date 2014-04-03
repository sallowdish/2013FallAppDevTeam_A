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
@interface EventEdittingViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (weak, nonatomic) IBOutlet UIButton *photoAddButton;
@property (weak, nonatomic) IBOutlet UIView *photoSpanView;
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
    self.locationTextField.text=[dic objectForKey:@"event_title"];
    self.locationResourceURL=[dic objectForKey:@"event_resourceurl"];
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
    
}


-(void)dismissKeyBoard{
    [self.view endEditing:YES];
}

-(IBAction)imagePickerPopup:(id)sender{
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = self;
    
    [self presentViewController: mediaUI animated: YES completion:nil];
//    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Code here to work with media
    [selectedPhoto removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        [selectedPhoto addObject:info[UIImagePickerControllerOriginalImage]];
        // Media is an image
        [self updateSelectedImage];
    }
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

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewEvent) name:@"didCreateNewEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewEventFailed) name:@"didCreateNewEventFailed" object:nil];
        EventPostModel* model=[[EventPostModel alloc] init];
        [ProgressHUD show:@"Submitting new event..."];
        [model postEventwithInfo:[self packUpInfo]];
        ImageUploadModel* uploadModel=[[ImageUploadModel alloc] init];
        if (selectedPhoto.count>0) {
            [uploadModel uploadImage:selectedPhoto[0]];
        }
    }else
    {
        [popoverAlterModel alterWithTitle:@"Failed" Message:@"Please fill up all required field"];
    }
}

-(BOOL)isAllRequiredFilled{
    return !([self.titleInputTextField.text isEqualToString:@""]||[self.dateInputTextField.text isEqualToString:@""]||[self.timeFromInputTextField.text isEqualToString:@""]||[self.locationResourceURL isEqual:[NSNull null]]);
}

-(void)didCreateNewEvent{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    [(EventListViewController*)[self.navigationController presentedViewController] refreshEventList:nil];
    [popoverAlterModel alterWithTitle:@"Succeed" Message:@"You have created a new event, please reload the event list page."];
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
    [info setValue:self.locationResourceURL forKey:@"fk_address"];
    return info;

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

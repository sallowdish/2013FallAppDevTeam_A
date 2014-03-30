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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIDatePicker *datePicker=[[UIDatePicker alloc]init]
        ,*timePicker=[[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
//    [datePicker addTarget:self action:@selector(datePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
//    [timePicker addTarget:self action:@selector(timePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateInputTextField.inputView=datePicker;
    self.timeFromInputTextField.inputView=timePicker;
//    self.timeToInputTextField.inputView=timePicker;
    [self.timeFromInputTextField addTarget:self action:@selector(didFinishTimeEditting:) forControlEvents:UIControlEventEditingDidEnd];
//    [self.timeToInputTextField addTarget:self action:@selector(didFinishTimeEditting:) forControlEvents:UIControlEventEditingDidEnd];
    [self.dateInputTextField addTarget:self action:@selector(didFinishDateEditting:) forControlEvents:UIControlEventEditingDidEnd];
    
    //initialize class variable
    selectedPhoto=[[NSMutableArray alloc] init];
    selectedPhotoView=[[NSMutableArray alloc] init];
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
//    [selectedPhotoView removeAllObjects];
    for (int i=0; i<selectedPhoto.count; i++) {
        UIImage* current_image=selectedPhoto[i];
        UIImageView* view=[[UIImageView alloc] initWithFrame:CGRectMake(basex, 5, 50, 50)];
        view.image=current_image;
        [self.photoSpanView addSubview:view];
        [selectedPhotoView addObject:view];
        basex+=55;
    }
    [selectedPhoto removeAllObjects];
    
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
    EventPostModel* model=[[EventPostModel alloc] init];
    model.externalDelegate=self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [ProgressHUD show:@"Submitting new event..."];
    [model postEventwithInfo:[self packUpInfo]];
    
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
    [info setValue:self.capacityInputTextField.text forKey:@"event_capacity"];
    return info;
}



-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//        NSLog(@"%@",response);
        NSHTTPURLResponse* resp=(NSHTTPURLResponse*)response;
        if ([resp statusCode]!=201) {
            //something wrong
            [[[popoverAlterModel alloc]init]dismissWaitingHub];
            [[[UIAlertView alloc] initWithTitle:@"Failed" message:@"Failed to pose the event, sorry." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            NSLog(@"%@",response);
        }
        else{
            [ProgressHUD dismiss];
            [self performSelector:@selector(showSucceedHUD) withObject:nil afterDelay:0.5];
//            [[[UIAlertView alloc] initWithTitle:@"Succeed" message:@"Your event has been posted. We will jump back to event list page." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            responseData=[[NSMutableData alloc] init];
        }
        
    }
}

-(void) showSucceedHUD{
    [ProgressHUD showSuccess:@"Your event has been posted. We will jump back to event list page."];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
    
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString* responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:@YES afterDelay:3];
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

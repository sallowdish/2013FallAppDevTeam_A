//
//  RecommandContainerViewController.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-04-28.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "RecommandContainerViewController.h"

@interface RecommandContainerViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;

@end

@implementation RecommandContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.segmentController.selectedSegmentIndex=self.selectedSegmentIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segementeationPressed:(id)sender{
    UISegmentedControl* seg=(UISegmentedControl*)sender;
    if ([seg selectedSegmentIndex]==0||[seg selectedSegmentIndex]==1) {
        [self.navigationController popViewControllerAnimated:YES];
        self.previousViewController.segmentController.selectedSegmentIndex=seg.selectedSegmentIndex;
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

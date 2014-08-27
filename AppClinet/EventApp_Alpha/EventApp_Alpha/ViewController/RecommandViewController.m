
#define SIMPLE_SAMPLE NO


#import "RecommandViewController.h"
#import "EventListFetchModel.h"
#import "PageContentViewController.h"
#import "PageViewController.h"
#import "ImageModel.h"

@interface RecommandViewController ()

@end

@implementation RecommandViewController
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO
    //Initial model
    //    NSMutableArray *temp=[[NSMutableArray alloc]init];
//    for (int i=1;i<5; i++) {
//        [temp addObject:[UIImage imageNamed:[NSString stringWithFormat:@"event%d.jpg",i]]];
//    }
//    self.eventImages=[[NSArray alloc] initWithArray:temp];
    
    //Initial view
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

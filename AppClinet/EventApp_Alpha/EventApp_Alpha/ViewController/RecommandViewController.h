
#import <UIKit/UIKit.h>

@interface RecommandViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *eventList;
//@property (strong, nonatomic) NSArray *eventImages;

@end

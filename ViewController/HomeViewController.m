#import "HomeViewController.h"
#import "CarbonKit.h"
#import "AllSpecialTableViewController.h"
#import "ExpiringSoonTableViewController.h"
#import "JustAddedTableViewController.h"
#import "MyProgressTableViewController.h"
#import "AvantiCommon.h"
#import "AMUtilities.h"



@interface HomeViewController () <CarbonTabSwipeNavigationDelegate>
{
	NSArray *items;
	CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
    AllSpecialTableViewController *allSpecialVc;
    JustAddedTableViewController *justAddedVc;
    MyProgressTableViewController *myProgressVc;
    ExpiringSoonTableViewController *expiringVc;
}
@end	

@implementation HomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.title = @"MY MARKET OFFERS";

    items = @[ @"ALL OFFERS", @"PROMOS",
               @"EXPIRING SOON", @"JUST ADDED"];

    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc]
                                initWithItems:items
                                rootViewController:self];
    carbonTabSwipeNavigation.delegate = self;
    allSpecialVc = [[AllSpecialTableViewController alloc]initWithNibName:@"AllSpecialTableViewController" bundle:nil];
    myProgressVc = [[MyProgressTableViewController alloc]initWithNibName:@"MyProgressTableViewController" bundle:nil];
    justAddedVc = [[JustAddedTableViewController alloc]initWithNibName:@"JustAddedTableViewController" bundle:nil];
    expiringVc = [[ExpiringSoonTableViewController alloc]initWithNibName:@"ExpiringSoonTableViewController" bundle:nil];

    
}

-(void)viewWillAppear:(BOOL)animated
{

}


- (void)viewDidDisappear:(BOOL)animated// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
{
    //[[AMUtilities sharedUtilities].allSpecialArray removeAllObjects];
    //[carbonTabSwipeNavigation setCurrentTabIndex:0];
    
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)style {
	
	UIColor *color = [UIColor colorWithRed:252.0/255 green:206.0/255 blue:4.0/255 alpha:1];
//	self.navigationController.navigationBar.translucent = NO;
//	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//	self.navigationController.navigationBar.barTintColor = color;
//	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	carbonTabSwipeNavigation.toolbar.translucent = NO;
	[carbonTabSwipeNavigation setIndicatorColor:color];
	[carbonTabSwipeNavigation setTabExtraWidth:0];
    [carbonTabSwipeNavigation setIndicatorHeight:4.0];
    carbonTabSwipeNavigation.carbonTabSwipeScrollView.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
//	[carbonTabSwipeNavigation.carbonSegmentedControl setWidth:80 forSegmentAtIndex:0];
//	[carbonTabSwipeNavigation.carbonSegmentedControl setWidth:80 forSegmentAtIndex:1];
//	[carbonTabSwipeNavigation.carbonSegmentedControl setWidth:80 forSegmentAtIndex:2];
	
	// Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[UIColor darkGrayColor]
				  font:[UIFont fontWithName:FONT_Avenir_LT_Std_Book size:14]];
	[carbonTabSwipeNavigation setSelectedColor:[UIColor darkTextColor]
				    font:[UIFont fontWithName:FONT_Avenir_LT_Std_Book size:14]];
}

# pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
				 viewControllerAtIndex:(NSUInteger)index {

	switch (index) {
		case 0:
			return allSpecialVc;
		case 1:
			return myProgressVc;
        case 2:
            return expiringVc;
			
		default:
			return justAddedVc;
	}

}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
		 willMoveAtIndex:(NSUInteger)index {

}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
		  didMoveAtIndex:(NSUInteger)index {
	NSLog(@"Did move at index: %ld", index);
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
	return UIBarPositionTop; // default UIBarPositionTop
}

@end





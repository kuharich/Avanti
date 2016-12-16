//
//  AMSideMenuViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 24/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMSideMenuViewController.h"
#import "AMHomeViewController.h"
#import "MFSideMenu.h"
#import "AAMixpanel.h"
#import "HomeViewController.h"
#import "DiscountsViewController.h"
#import "SideMenuTableViewCell.h"


@interface AMSideMenuViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerViewSection1;

@property (strong, nonatomic) IBOutlet UIView *footerViewSection2;

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuIcons;

@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;

@property (nonatomic, strong) UINavigationController *avantiHomeViewContoller;

- (IBAction)tapOnAvantiLogo:(id)sender;
- (IBAction)tapOnSignOut:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

- (PayViewController *)payViewController;
- (SupportViewController *)supportViewController;
- (ReloadViewController *)reloadViewController;

- (AccountHistoryViewController *)accountHistoryViewController;
- (MyAccountViewController *)myAccountViewController;
- (HomeViewController *)homeViewController;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, strong) AMHomeViewController *_avantiMarketsHomeViewController;
@property (nonatomic, strong) PayViewController *_payViewController;
@property (nonatomic, strong) SupportViewController *_supportViewController;
@property (nonatomic, strong) ReloadViewController *_reloadViewController;
@property (nonatomic, strong) AccountHistoryViewController *_accountHistoryViewController;
@property (nonatomic, strong) MyAccountViewController *_myAccountViewController;
@property (nonatomic, strong) HomeViewController *_homeViewController;
@property (nonatomic, strong) DiscountsViewController *_discountsViewController;

@end

@implementation AMSideMenuViewController
@synthesize backgroundImage;
@synthesize lineView;
@synthesize btnSignOut;
@synthesize versionLabel;

- (AMHomeViewController *)avantiMarketsHomeViewController {
    if (self._avantiMarketsHomeViewController == nil)
        self._avantiMarketsHomeViewController = [[AMHomeViewController alloc] initWithNibName:[XibHelper XibFileName:@"AMHomeViewController"] bundle:nil];
    return self._avantiMarketsHomeViewController;
}

- (DiscountsViewController *) discountsViewController {
    
    if (self._discountsViewController == nil)
        self._discountsViewController = [[DiscountsViewController alloc] initWithNibName:[XibHelper XibFileName:@"DiscountsViewController"] bundle:nil];
    return self._discountsViewController;
}


- (PayViewController *)payViewController {
    if (self._payViewController==nil)
        self._payViewController = [[PayViewController alloc] initWithNibName:[XibHelper XibFileName:@"PayViewController"] bundle:nil];
    
    return self._payViewController;
}


- (SupportViewController *)supportViewController {
    if (self._supportViewController == nil)
        self._supportViewController = [[SupportViewController alloc] initWithNibName:@"SupportViewController" bundle:nil];
    
    return self._supportViewController;
}

- (ReloadViewController *)reloadViewController {
    
    if (self._reloadViewController == nil && IS_IPHONE_4)
        self._reloadViewController = [[ReloadViewController alloc] initWithNibName:@"ReloadViewController-4s" bundle:nil];
    else if (self._reloadViewController == nil)
        self._reloadViewController = [[ReloadViewController alloc] initWithNibName:[XibHelper XibFileName:@"ReloadViewController"] bundle:nil];
    
    return self._reloadViewController;
}


- (AccountHistoryViewController *)accountHistoryViewController {
    if (self._accountHistoryViewController==nil)
        self._accountHistoryViewController = [[AccountHistoryViewController alloc] initWithNibName:@"AccountHistoryViewController" bundle:nil];
    
    return self._accountHistoryViewController;
}

- (MyAccountViewController *)myAccountViewController{
    if (self._myAccountViewController==nil)
        self._myAccountViewController = [[MyAccountViewController alloc] initWithNibName:[XibHelper XibFileName:@"MyAccountViewController"] bundle:nil];
    
    return self._myAccountViewController;
}




-(HomeViewController *)homeViewController
{
    self._homeViewController = [[HomeViewController alloc] init];
    
    return self._homeViewController;
}

- (void)viewDidLoad {
    self.avantiHomeViewContoller = self.menuContainerViewController.centerViewController;
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];

    //[self.versionLabel setText:[NSString stringWithFormat:@"v%@ (%@) - stage", [infoDict objectForKey:@"CFBundleShortVersionString"], [infoDict objectForKey:@"CFBundleVersion"]]  ];

    [self.versionLabel setText: [NSString stringWithFormat:@"v%@", [infoDict objectForKey:@"CFBundleShortVersionString"]]];
    [self setCustomBackgroundImage: backgroundImage];
    [self setCustomBackgroundGradient: self];
    [self setCustomViewColor: self.lineView];
    [self setCustomRegularButtonBackgroundColor:btnSignOut];
    [self setCustomRegularButtonTextColor: btnSignOut];
    // above was: [self setCustomButtonTextColor:btnSignOut key:@"regularTextColor"];
    [self setCustomLabelColor:versionLabel];

    self.lineView.hidden = IS_IPHONE_4;

    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSArray *) menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[ @"MY ACCOUNT", @"SUPPORT", @"PAY", @"OFFERS", @"RELOAD", @"ACCOUNT HISTORY"];
    
    return _menuItems;
}

-(NSArray *) menuIcons {
    if (_menuIcons) return _menuIcons;
    _menuIcons = @ [
        [UIImage imageNamed:@"account-menu-icon.png"],
                    [UIImage imageNamed:@"support-menu-icon.png"],
                    [UIImage imageNamed:@"pay-menu-icon.png"],
                    [UIImage imageNamed:@"offers-menu-icon.png"],
                    [UIImage imageNamed:@"reload-menu-icon.png"],
                    [UIImage imageNamed:@"history-menu-icon.png"]
    ];
    
    return _menuIcons;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.menuItems.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [XibHelper isIpad] ? 240.0 : (IS_IPHONE_4 ? 80.0f : 144.0f);
    }
    else {
        // TODO: why is this here?
        return IS_IPHONE_4 ? 35.0f : 41.0f;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerViewSection1;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [XibHelper isIpad] ? 94.0 : 54.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.footerViewSection2;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hideOffers && indexPath.row == MenuItemREWARDS) {
        return 0.0;
    }
    return [XibHelper isIpad] ? 80.0 : 42.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SideMenuViewCell";
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (self.hideOffers && indexPath.row == MenuItemREWARDS) {
        cell.hidden = YES;
    }
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[XibHelper XibFileName:@"SideMenuViewCell"] owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.menuItemText.text = self.menuItems[indexPath.row];
    [cell.menuItemIcon setImage: self.menuIcons[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    [self setCustomLabelColor:cell.menuItemText];
    [self setCustomMenuItemSelectedColor:cell];
    NSLog(@"%ld %ld", (long)indexPath.section, (long)indexPath.row);
    return cell;
}

-(void) pushViewController:(UIViewController *) viewController {
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    if (navigationController.visibleViewController != viewController) {
        [navigationController pushViewController:viewController animated:YES];
    }
}



#pragma mark - UITableViewDelegate
- (void)openControllerAtIndexPath:(NSIndexPath *)indexPath withBool:(BOOL)param{
    NSString *menuItem = nil;
    BOOL isImplemented = YES;
    
    if (indexPath.row == MenuItemSIGNOUT) {
        menuItem = @"Sign Out";
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_StoredEncryptedPass];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSStringFromClass([GetBalanceResponse class])];
        [[AppDelegate sharedDelegate] performSelector:@selector(launchLoginScreen) withObject:nil afterDelay:0.1];
        return;
    }

    if (indexPath.section == MenuItemSectionTopMenu) {//0
        menuItem = self.menuItems[indexPath.row];
        
        switch (indexPath.row) {
                
            case MenuItemPAY:{
                [self pushViewController:[self payViewController]];
                break;
            }
                
            case MenuItemREWARDS:{
                [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
#ifdef NOPROMOS
                [[AMUtilities sharedUtilities] getDiscounts: [[NSDate alloc] init] block: ^(id obj){
                    [MBProgressHUD hideHUDForView:[[AppDelegate sharedDelegate] window] animated:YES];
                    [self pushViewController:[self discountsViewController]];
                }];
#else
                [self pushViewController:[self homeViewController]];
#endif
                 break;
            }

                
            case MenuItemACCOUNT_HISTORY:{
                [self pushViewController:[self accountHistoryViewController]];
                break;
            }

            case MenuItemMyAccount:{
                    [self pushViewController:[self myAccountViewController]];
                break;
            }

                
            case MenuItemLOCATIONS:{
                isImplemented = NO;
                break;
            }

            case MenuItemRELOAD: {
                [self pushViewController:[self reloadViewController]];
                break;
            }
                
            case MenuItemSUPPORT:{
                [self pushViewController:[self supportViewController]];
                break;
            }

            default:
                break;
        }
    }

    
    if (menuItem) {
        NSLog(@"%@", menuItem);
    }
    
    if (isImplemented) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else {
        displayAlertWithMessage(@"COMING SOON!");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld %ld", indexPath.section, indexPath.row);
    if (indexPath.section==1)
    {
        if (indexPath.row==1)
        {
            return;
        }
    }
    [self openControllerAtIndexPath:indexPath withBool:false];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)tapOnAvantiLogo:(id)sender {
    [self openControllerAtIndexPath:[NSIndexPath indexPathForItem:MenuItemAVANTI_LOGO inSection:MenuItemSectionOthers]withBool:false];
}

- (IBAction)tapOnSignOut:(id)sender {
    //Mixpanel
    [AAMixpanel signOutSuccess];
    AppDelegate *a = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [AMUtilities sharedUtilities].balance=nil;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    a.localNoti = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMSignOutSuccessNotification object:nil];
    [self openControllerAtIndexPath:[NSIndexPath indexPathForItem:MenuItemSIGNOUT inSection:0] withBool:false];
    
}

@end

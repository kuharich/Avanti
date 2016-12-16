//
//  AMHomeViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 24/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMHomeViewController.h"
#import "AppDelegate.h"
#import "AMPINViewController.h"
#import "ReloadViewController.h"
#import "AddCardViewController.h"
#import "AMSideMenuViewController.h"


@interface AMHomeViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UILabel *lblWelcome;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPoints;
@property (weak, nonatomic) IBOutlet UILabel *lblHouseAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;

@property (weak, nonatomic) IBOutlet UIView *viewButtons;
- (IBAction)tapOnPay:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnWaysToPay;
- (IBAction)tapOnWaysToPay:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRewards;
- (IBAction)tapOnRewards:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;
- (IBAction)tapOnHistory:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblBalanceHeader;



@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UILabel *lblPointsHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblHouseAccountLabel;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *zeroWidthConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalWidthsConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *payTrailingConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *payAndRewardsDistanceConstraint;
@end

@implementation AMHomeViewController

@synthesize topBackgroundView;
@synthesize payTrailingConstraint;
@synthesize payAndRewardsDistanceConstraint;
@synthesize btnPay;
@synthesize btnRewards;
@synthesize btnHistory;
@synthesize btnWaysToPay;
@synthesize lblBalance;
@synthesize lblWelcome;
@synthesize lblUserName;

- (void)viewDidLoad {
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextAlignment: NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont fontWithName:[self quicksandFontName] size:19]];
    [title setAdjustsFontSizeToFitWidth:YES];
    title.text = @"MARKETAccount";
    [title setTextColor:[UIColor colorWithRed:255.0/255.0 green:252.0/255.0 blue:243/255.0 alpha:1.0] range:NSMakeRange(0, [title.text length])];
    
    [self setCustomTitleColor: title];
    [title setFont:[UIFont fontWithName:[self quicksandBoldFontName] size:19] range:NSMakeRange(0, 6)];
    
    self.navigationController.navigationBar.topItem.titleView = title;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lblBalance setHidden:YES];

    [[AMUtilities sharedUtilities] getUserbalance:^(id obj){
        [self showBalance];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];


    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBalanceNotification:)
                                                 name:AMGetBalanceSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDiscountsNotification:)
                                                 name:AMGetDiscountsSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getSignOutNotification)
                                                 name:AMSignOutSuccessNotification object:nil];

    [self.lblPointsHeader setHidden:YES];
    [self.lblPoints setHidden:YES];
    [self.lblHouseAccountLabel setHidden:YES];
    [self.lblHouseAccount setHidden:YES];
    
    [self showOffersTitle];
    
    if ([AMUtilities sharedUtilities].hasDiscounts) {
        [self showOffers];
        [AppDelegate sharedDelegate].menuController.hideOffers = NO;
    }
    else {
        [self hideOffers];
        [AppDelegate sharedDelegate].menuController.hideOffers = YES;
    }
    
    [self tweakButton:self.btnPay];
    [self tweakButton:self.btnRewards];
    [self tweakButton:self.btnHistory];
    [self tweakButton:self.btnWaysToPay];
    
    [super viewDidLoad];
    
    [self setCustomButtonTextColor:btnPay key:@"payTextColor"];
    [self setCustomButtonTextColor:btnHistory key:@"historyTextColor"];
    [self setCustomButtonTextColor:btnRewards key:@"offersTextColor"];
    [self setCustomButtonTextColor:btnWaysToPay key:@"reloadTextColor"];
    
    [self setCustomLabelColor: self.lblWelcome];
    [self setCustomLabelColor: self.lblUserName];
    [self setCustomLabelColor: self.lblPoints];
    [self setCustomLabelColor: self.lblBalance];
    [self setCustomLabelColor: self.lblBalanceHeader];
    if ([self brandHasLightBackgroundColor]) {
        [self setCustomLightBackgroundColor: self.backgroundView];
    }
}


-(void) tweakButton:(UIButton *) button {
    [button.layer setCornerRadius:4.0f];
    button.clipsToBounds = YES;
}


-(void) hideOffers {
     self.zeroWidthConstraint.priority = 999;
     self.equalWidthsConstraint.priority = 100;
     self.payTrailingConstraint.priority = 999;
     self.payAndRewardsDistanceConstraint.priority = 100;
     [self.btnRewards setHidden:YES];
}

-(void) showOffers {
    self.zeroWidthConstraint.priority = 100;
    self.equalWidthsConstraint.priority = 999;
    self.payTrailingConstraint.priority = 100;
    self.payAndRewardsDistanceConstraint.priority = 999;
    [self.btnRewards setHidden:NO];
}

-(void) showBalance {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[AMUtilities sharedUtilities].balance.userBalance];
    self.lblBalance.text = numberAsString; //[NSString stringWithFormat:@"Converted:%@",numberAsString];
    [self.lblBalance setHidden:NO];
}

-(void) showOffersTitle {
    [self.btnRewards setTitle:[NSString stringWithFormat:@"OFFERS (%lu)", (unsigned long)[AMUtilities sharedUtilities].discounts.count] forState:UIControlStateNormal];
}




-(void)tapGesturee
{
    [[AppDelegate sharedDelegate] openControllerAtIndexPath:[NSIndexPath indexPathForRow:MenuItemREWARDS inSection:MenuItemSectionTopMenu]withBool:false];
}


-(void)tapGesturee1
{
    [[AppDelegate sharedDelegate] openControllerAtIndexPath:[NSIndexPath indexPathForRow:MenuItemACCOUNT_HISTORY inSection:MenuItemSectionTopMenu]withBool:false];
    
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) getBalanceNotification:(id)noti{
    
    NSLog(@"getBalanceNotification");
    NSNumber *response = [noti object];
    if ([response boolValue]) {
        [self showBalance];
    }
}

- (void) getDiscountsNotification:(id)noti{
    
    NSLog(@"getDiscountsNotification");
    if (noti) {
        [self showOffersTitle];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)getSignOutNotification{
    [AMHomeViewController cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	NSData *decodedResp = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])];
	AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:decodedResp];
    [self.viewButtons setFrame:CGRectMake(10,  self.viewButtons.frame.origin.y,  self.viewButtons.frame.size.width, self.viewButtons.frame.size.height)];
    if (!IS_IPHONE_4)
    {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (self.lblUserName == con.firstItem && con.firstAttribute == NSLayoutAttributeTop &&con.constant ==3)
            {
                con.constant = 10;
                break;
            }
        }
    }
    
    self.lblUserName.text = [NSString stringWithFormat:@"%@", authResp.firstName];
    
    [self.btnHistory.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.btnHistory.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.btnHistory setTitle:@"ACCOUNT\nHISTORY" forState:UIControlStateNormal];
    [self tallerGreenGradient:self.topBackgroundView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self tallerCustomGradient:self.topBackgroundView];

}




- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

}
- (IBAction)tapOnPay:(id)sender {
    [[AppDelegate sharedDelegate] openControllerAtIndexPath:[NSIndexPath indexPathForRow:MenuItemPAY inSection:MenuItemSectionTopMenu]withBool:false];
}

- (IBAction)tapOnHistory:(id)sender {
	[[AppDelegate sharedDelegate] openControllerAtIndexPath:[NSIndexPath indexPathForRow:MenuItemACCOUNT_HISTORY inSection:MenuItemSectionTopMenu]withBool:false];
}

- (IBAction)tapOnWaysToPay:(id)sender {
    ReloadViewController *reload;
    if (IS_IPHONE_4) {
        reload = [[ReloadViewController alloc] initWithNibName:@"ReloadViewController-4s" bundle:nil];
    }
    else {
        reload = [[ReloadViewController alloc] initWithNibName:[XibHelper XibFileName:@"ReloadViewController"] bundle:nil];
    }
    
    [self.navigationController pushViewController:reload animated:YES];
}




- (IBAction)tapOnRewards:(id)sender {
    [[AppDelegate sharedDelegate] openControllerAtIndexPath:[NSIndexPath indexPathForRow:MenuItemREWARDS inSection:MenuItemSectionTopMenu]withBool:false];

}

@end

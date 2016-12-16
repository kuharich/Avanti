//
//  AMSideMenuViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 24/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMSideMenuViewController.h"
#import "AMPINViewController.h"

#import "AMHomeViewController.h"
#import "SupportViewController.h"
#import "PayViewController.h"
#import "ReloadViewController.h"
#import "AccountHistoryViewController.h"
#import "MyAccountViewController.h"
#import "AddCardViewController.h"


@interface AMSideMenuViewController : AMViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL hideOffers;

- (AMHomeViewController *)avantiMarketsHomeViewController;
- (void)openControllerAtIndexPath:(NSIndexPath *)indexPath withBool:(BOOL)param;

@end

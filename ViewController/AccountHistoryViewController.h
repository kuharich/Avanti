//
//  AccountHistoryViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 29/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViewController.h"

@interface AccountHistoryViewController : AMViewController

- (void)getHistoryTransaction;
- (void) combineBonusesToActualTransactions: (NSMutableArray **) historyItems;

@end

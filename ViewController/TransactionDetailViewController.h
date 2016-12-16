//
//  TransactionDetailViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 29/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionDetailViewController : AMViewController

@property (nonatomic, strong) GetHistoryResponse *history;
@property (nonatomic, strong) NSString *transactionID;

@end

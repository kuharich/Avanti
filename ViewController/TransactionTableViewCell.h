//
//  TransactionTableViewCell.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 01/05/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblSubTitle;

@end

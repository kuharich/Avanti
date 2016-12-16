//
//  TransactionBottomCell.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 01/05/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionBottomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblPointEarned;
@property (nonatomic, weak) IBOutlet UILabel *lblTextPointEarned;
@property (nonatomic, weak) IBOutlet UIButton *btnEmailReciept;

@end

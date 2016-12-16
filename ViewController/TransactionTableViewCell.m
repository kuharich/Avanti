//
//  TransactionTableViewCell.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 01/05/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "TransactionTableViewCell.h"

@implementation TransactionTableViewCell

@synthesize lblTitle;
@synthesize lblSubTitle;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

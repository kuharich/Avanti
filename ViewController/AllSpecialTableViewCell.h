//
//  AllSpecialTableViewCell.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 11/18/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllSpecialTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *lblText;
@property (nonatomic,strong) IBOutlet UILabel *lblDetailText;
@property (nonatomic,strong) IBOutlet UILabel *lblDate;

@property (nonatomic, strong) NSString *amountOff;
@property (nonatomic, strong) NSString *productGroups;
@property (nonatomic, assign) int discountTypeId;
@property (nonatomic, strong) NSDate *endDate;

@end

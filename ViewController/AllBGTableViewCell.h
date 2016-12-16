//
//  AllBGTableViewCell.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 1/4/16.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllBGTableViewCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *lblDetailText;
@property(nonatomic,strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) NSDate *endDate;

@end

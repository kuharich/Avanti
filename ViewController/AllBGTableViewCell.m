//
//  AllBGTableViewCell.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 1/4/16.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AllBGTableViewCell.h"

@implementation AllBGTableViewCell

@synthesize lblDetailText;
@synthesize endDate;
@synthesize lblDate;

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void) viewDidLoad {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    lblDate.text = [NSString stringWithFormat:@"Ends %@",[dateFormat stringFromDate:endDate]];

}
- (void)layoutSubviews {
    [super layoutSubviews];
    [lblDetailText sizeToFit];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

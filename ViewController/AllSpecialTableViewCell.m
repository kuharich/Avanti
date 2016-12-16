//
//  AllSpecialTableViewCell.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 11/18/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AllSpecialTableViewCell.h"


#define DOLLAR_AMOUNT   2

@implementation AllSpecialTableViewCell


@synthesize lblDetailText;
@synthesize amountOff;
@synthesize productGroups;
@synthesize discountTypeId;
@synthesize endDate;
@synthesize lblDate;
@synthesize lblText;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M/d/yyyy"];
    lblDate.text = [NSString stringWithFormat:@"Ends %@",[dateFormat stringFromDate:endDate]];
    if (self.amountOff) {
        NSString *prefix = @"";
        if (self.discountTypeId == DOLLAR_AMOUNT) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            prefix = [NSString stringWithFormat:@"%@ Off ", self.amountOff];
        }
        else {
            prefix = [NSString stringWithFormat:@"%@%% Off ", self.amountOff];
        }
        [self.lblDetailText setText:[prefix stringByAppendingString:self.productGroups]];

        [self setCustomLabelColor: self.lblDate key: @"bodyTextColor"];
        [self setCustomLabelColor: self.lblText key: @"secondaryTextColor"];
        [self setCustomLabelColor: self.lblDetailText key: @"bodyTextColor"];
        [self setCustomLabelColor: self.lblDetailText key: @"accentTextColor" range:NSMakeRange(0, [prefix length])];
        
        
        int width = [[UIScreen mainScreen] bounds].size.width;
        CGRect frame = self.lblDetailText.frame;
        frame.size.width = width;
        [self.lblDetailText setFrame:frame];
        frame = self.lblText.frame;
        frame.size.width = width;
        [self.lblText setFrame:frame];
        [self setCustomFont:self.lblText];
        [self setCustomFont:self.lblDetailText];
    }
    else {
        [self.lblDetailText setText:self.productGroups];
    }
    [self.lblDetailText sizeToFit];

}

// TODO: don't duplicate this here - refactor
-(void) setCustomFont:(UILabel *) label {
    
    if ([label.font.fontName isEqualToString:@"Quicksand-Bold"]) {
        label.font = [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:label.font.pointSize];
    }
    else if ([self.lblText.font.fontName isEqualToString:@"Quicksand-Regular"]) {
        label.font = [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandFontName"] size:label.font.pointSize];
    }
}

-(void) setCustomLabelColor: (UILabel *) label key: (NSString *) key {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor:[self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:key]] ];
    }
}

-(void) setCustomLabelColor: (UILabel *) label key: (NSString *) key range: (NSRange) range {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:key]] range:range];
    }
}

- (UIColor *) convertToColor:(NSString *)str {
    int red = 0;
    int green = 0;
    int blue = 0;
    sscanf([str UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    return  [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}
// end TODO

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

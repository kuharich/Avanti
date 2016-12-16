//
//  AMMarketCardInfo.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMMarketCardInfo.h"

@implementation AMMarketCardInfo


@synthesize mScanCode;

@synthesize cardName;

@synthesize color;
@synthesize primary;
@synthesize dummyCard;

+ (AMMarketCardInfo *)dummyMarketCard{
    AMMarketCardInfo *amCard = [[AMMarketCardInfo alloc] init];
    amCard.mScanCode = @"";
    amCard.cardName = @"";
    amCard.color = MarketCardColorGreen;
    amCard.dummyCard = YES;
    return amCard;
}

- (AMMarketCardInfo *)initWithStoredCardResponse:(ScanCodesResponse *)scResponse{
    if (self = [super init]) {
        
        self.mScanCode = scResponse.scanCode;
        int cardType = [scResponse.scanCode longLongValue]%3;
        switch (cardType) {
            case 1:
                self.cardName = @"Personal";
                self.color = MarketCardColorAqua;
                break;
            case 2:
                self.cardName = @"Corporate";
                self.color = MarketCardColorBlue;
                break;
            default:
                self.cardName = @"Business";
                self.color = MarketCardColorGreen;
                break;
        }
        
        self.primary = NO;
    }
    return self;

}

- (AMMarketCardInfo *)initWithScanCode:(NSString *)scanCode{
    
    if (self = [super init]) {
        self.mScanCode = scanCode;
    }
    return self;
}





@end

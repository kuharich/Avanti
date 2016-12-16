//
//  AMMarketCardInfo.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScanCodesResponse;

@interface AMMarketCardInfo : NSObject

@property (nonatomic, strong) NSString *mScanCode;

@property (nonatomic, strong) NSString *cardName;

@property (nonatomic, assign) NSInteger color;
@property (nonatomic, assign, getter=isPrimary) BOOL primary;

@property (nonatomic, assign, getter=isDummyCard) BOOL dummyCard;

+ (AMMarketCardInfo *)dummyMarketCard;

- (AMMarketCardInfo *)initWithStoredCardResponse:(ScanCodesResponse *)scResponse;
- (AMMarketCardInfo *)initWithScanCode:(NSString *)scanCode;



@end

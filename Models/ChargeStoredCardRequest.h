//
//  ChargeStoredCardRequest.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 16/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeStoredCardRequest : NSObject

@property (strong, nonatomic) NSString *cardID;

@property (assign, nonatomic) float reloadAmount;

@end

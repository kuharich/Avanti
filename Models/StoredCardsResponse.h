//
//  StoredCardsResponse.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 15/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>
//[{"cardID":"1","cardType":"AMEX","lastFour":"1234","expDate":"1116"},{"cardID":"2","cardType":"VISA","lastFour":"1255","expDate":"0617"},{"cardID":"3","cardType":"MC","lastFour":"4522","expDate":"0417"}]
@interface StoredCardsResponse : NSObject

@property (strong, nonatomic) NSString *cardID;
@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSString *lastFour;
@property (strong, nonatomic) NSString *expDate;
@property (assign, nonatomic) BOOL isAutoChargeCard;

@end

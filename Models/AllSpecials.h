//
//  AllSpecials.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 11/18/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllSpecials : NSObject
@property (strong, nonatomic) NSString *ProdName;
@property (strong, nonatomic) NSString *OfferDesc;
@property (strong, nonatomic) NSString *StartDate;
@property (strong, nonatomic) NSString *EndDate;
@property (nonatomic) float CurrentAmount;
@property ( nonatomic) float RequiredAmount;
@property (strong, nonatomic) NSString *pID;
@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) NSDate *dateEnd;
@property (strong, nonatomic) NSDate *dateStart;

@property ( nonatomic) BOOL isExpired;

@property (strong, nonatomic) NSString *category;//today or 7 day or 30 day

@property (strong, nonatomic) NSString *category1;//today or 7 day or 30 day


@end

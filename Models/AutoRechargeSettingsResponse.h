//
//  AutoRechargeSettingsResponse.h
//  AvantiMarket
//
//  Created by Vivek Bayalusime on 14/07/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoRechargeSettingsResponse : NSObject

@property (strong, nonatomic) NSString *autoRechargeEnabled;
@property (strong, nonatomic) NSString *cardID;
@property (strong, nonatomic) NSString *reloadAmount;
@property (strong, nonatomic) NSString *reloadThreshold;

@end

//
//  Discount.h
//  AvantiMarket
//
//  Created by Mark Kuharich on 2/18/16.
//  Copyright © Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discount : NSObject

@property (assign, nonatomic) int productId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *productGroups;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) int startHour;
@property (nonatomic) int startMin;
@property (nonatomic) int endHour;
@property (nonatomic) int endMin;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSString *amount;
@property (assign, nonatomic) int buyQuantity;
@property (assign, nonatomic) int getQuantity;
@property (assign, nonatomic) int operatorId;
@property (strong, nonatomic) NSString *category1;
@property (strong, nonatomic) NSString *category2;
@property (strong, nonatomic) NSString *category3;
@property (assign, nonatomic) int discountTypeId; // 9 is %, 8 is $

@end

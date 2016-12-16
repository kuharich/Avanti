//
//  GetHistoryResponse.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 29/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransactionType) {
    TransactionTypeNone         = 0,
    
    TransactionTypeCreateCard   = 1,
    TransactionTypeCreditBonus  = 2,
    TransactionTypePurchase     = 3,
    TransactionTypeReload       = 4,
    TransactionTypeRewardEarned = 5,
    TransactionTypeStartBalance = 6

};


@interface TransactionItem :  NSObject <NSCoding>
{
    NSString *productName;
    NSNumber *productPrice;
}

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSNumber *productPrice;

+ (TransactionItem *)getTransactionItemWithData:(NSData *)data;
- (NSData *)data;

@end


@interface GetHistoryResponse :  NSObject <NSCoding>
{
    NSString *transactionID;
    NSString  *transactionDate;
    NSNumber *transactionAmount;
    NSNumber *balance;
    NSString *transactionType;
    NSString *location;
    NSString *kiosk;
    NSString *marketCard;
    NSNumber *pointsEarned;
    NSNumber *totalTax;
    
    NSString *cardType;
    NSString *cardName;
    
    NSNumber* transactionsCount;
    NSArray  *transactionItems;
}

@property (strong, nonatomic) NSString *transactionID;
@property (strong, nonatomic) NSString *transactionDate;
@property (strong, nonatomic) NSNumber *transactionAmount;
@property (strong, nonatomic) NSNumber *balance;
@property (strong, nonatomic) NSString *transactionType;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *kiosk;
@property (strong, nonatomic) NSString *marketCard;
@property (strong, nonatomic) NSNumber *pointsEarned;
@property (strong, nonatomic) NSNumber *totalTax;
@property (strong, nonatomic) NSString *cardType;
@property (nonatomic, nonatomic) NSString *cardName;

@property (nonatomic, retain) NSNumber  *transactionsCount;
@property (strong, nonatomic) NSArray   *transactionItems;


@property (nonatomic, readonly) NSString *navigationTitle;
@property (nonatomic, readonly) NSString *tableCellTitle;
@property (nonatomic, readonly) TransactionType  getTransactionType;

+ (GetHistoryResponse *)getHistoryResponseWithData:(NSData *)data;
- (NSData *)data;

@end

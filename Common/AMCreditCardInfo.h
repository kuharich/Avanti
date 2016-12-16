//
//  AMCreditCardInfo.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>
//CARD.IO DISABLED#import <CardIO/CardIO.h>

/// CardIOCreditCardType Identifies type of card.
typedef NS_ENUM (NSInteger, CardIOCreditCardType) {
    CardIOCreditCardTypeUnrecognized = 0,
    CardIOCreditCardTypeAmbiguous = 1,
    CardIOCreditCardTypeAmex = '3',
    CardIOCreditCardTypeJCB = 'J',
    CardIOCreditCardTypeVisa = '4',
    CardIOCreditCardTypeMastercard = '5',
    CardIOCreditCardTypeDiscover = '6'
};


/// Container for the information about a card.
@interface CardIOCreditCardInfo : NSObject

@property(nonatomic, copy, readwrite) NSString *cardNumber;
@property(nonatomic, copy, readonly) NSString *redactedCardNumber;
@property(nonatomic, copy, readwrite) NSString* expiryMonth;
@property(nonatomic, copy, readwrite) NSString* expiryYear;
@property(nonatomic, copy, readwrite) NSString *cvv;
@property(nonatomic, copy, readwrite) NSString *cardTypeOne;

@property(nonatomic, assign, readonly) CardIOCreditCardType cardType;
@end
//CARD.IO DISABLED::END


@class StoredCardsResponse;

@interface AMCreditCardInfo : NSObject <NSCopying>

@property (nonatomic, strong) NSString *cardID;

@property (nonatomic, readonly) NSString *lastFourDigit;

@property (nonatomic, strong) NSString *expiryDate;

@property (nonatomic, assign, getter=isPrimary) BOOL primary;

@property (nonatomic, strong) NSString *userCardType;//Bussiness/personal/traval

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, strong) CardIOCreditCardInfo *creditCardInfo;

+ (AMCreditCardInfo *)dummyCreditCard;
+ (UIImage *)logoForCardType:(CardIOCreditCardType)cardType;

- (AMCreditCardInfo *)initWithStoredCardResponse:(StoredCardsResponse *)scResponse;
- (AMCreditCardInfo *)initWithCardID:(NSString *)cardId creditCardInfo:(CardIOCreditCardInfo *)ccInfo;

@end

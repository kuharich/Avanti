//
//  AMCreditCardInfo.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMCreditCardInfo.h"

@implementation CardIOCreditCardInfo

@synthesize cardNumber;
@synthesize redactedCardNumber;
@synthesize expiryMonth;
@synthesize expiryYear;
@synthesize cvv;
@synthesize cardTypeOne;

- (NSString *)redactedCardNumber{
    return [NSString stringWithFormat:@"**** **** **** %@", [self.cardNumber substringFromIndex:self.cardNumber.length-4]];
}

- (CardIOCreditCardType )cardType{
    if ([self.cardNumber hasPrefix:@"6"]) {
        return CardIOCreditCardTypeDiscover;
    }
    else if ([self.cardNumber hasPrefix:@"5"]) {
        return CardIOCreditCardTypeMastercard;
    }
    else if ([self.cardNumber hasPrefix:@"4"]) {
        return CardIOCreditCardTypeVisa;
    }
    else if ([self.cardNumber hasPrefix:@"3"]) {
        return CardIOCreditCardTypeAmex;
    }
    else if ([self.cardNumber hasPrefix:@"J"]) {
        return CardIOCreditCardTypeJCB;
    }
    else if ([self.cardNumber hasPrefix:@"1"]) {
        return CardIOCreditCardTypeAmbiguous;
    }
    else {//0
        return CardIOCreditCardTypeUnrecognized;
    }
}

@end;

@implementation AMCreditCardInfo

@synthesize cardID;

@synthesize lastFourDigit;

@synthesize expiryDate;

@synthesize primary;

@synthesize userCardType;

@synthesize firstName;
@synthesize lastName;

@synthesize creditCardInfo;

+ (AMCreditCardInfo *)dummyCreditCard{
    CardIOCreditCardInfo *cardIO = [[CardIOCreditCardInfo alloc] init];
    cardIO.cardNumber = @"4893444455550000";
    cardIO.expiryMonth = 00;
    cardIO.expiryYear = 00;
    cardIO.cardTypeOne = @"VISA";
    cardIO.cvv = @"121";
    
    AMCreditCardInfo *am = [[AMCreditCardInfo alloc] initWithCardID:@"1" creditCardInfo:cardIO];
    am.firstName = @"user";
    am.lastName = @"one";
    am.userCardType = @"Business";
    am.primary = YES;
    
    return am;
}

+ (UIImage *)logoForCardType:(CardIOCreditCardType)cardType{
    NSString *logoImageName;
    switch (cardType) {
        case CardIOCreditCardTypeAmex:
            logoImageName = @"AMEX-logo.png";
            break;
        case CardIOCreditCardTypeMastercard:
            logoImageName = @"mastercard-logo.png";
            break;
        case CardIOCreditCardTypeVisa:
            logoImageName = @"visa-logo.png";
            break;
        case CardIOCreditCardTypeDiscover:
            logoImageName = @"discover-logo.png";
            break;
        default:
            
            break;
    }
    return [UIImage imageNamed:logoImageName];
}
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
//        // Copy NSObject subclasses
//        [copy setVendorID:[[self.vendorID copyWithZone:zone] autorelease]];
//        [copy setAvailableCars:[[self.availableCars copyWithZone:zone] autorelease]];
//        
        // Set primitives
        [copy setCreditCardInfo:self.creditCardInfo];
    }
    
    return copy;
}

-(NSString *)lastFourDigit{
    return [self.creditCardInfo.cardNumber substringFromIndex:self.creditCardInfo.cardNumber.length-4];
}

-(NSString *)expiryDate{
    return [NSString stringWithFormat:@"%@/%@", self.creditCardInfo.expiryMonth,self.creditCardInfo.expiryYear];
}

- (AMCreditCardInfo *)initWithStoredCardResponse:(StoredCardsResponse *)scResponse{

    if (self = [super init]) {
        self.cardID = scResponse.cardID;
        
        CardIOCreditCardInfo *cardIO = [[CardIOCreditCardInfo alloc] init];
        
        //CardIOCreditCardTypeAmbiguous
        if ([scResponse.cardType isEqualToString:@"AMEX"] || [scResponse.cardType isEqualToString:@"AMERICAN EXPRESS"]) {
            cardIO.cardNumber = [NSString stringWithFormat:@"34944445555%@",  scResponse.lastFour];
        }
        else if ([scResponse.cardType isEqualToString:@"VISA"]) {
            cardIO.cardNumber = [NSString stringWithFormat:@"489344445555%@",  scResponse.lastFour];
        }
        else if ([scResponse.cardType isEqualToString:@"MC"] || [scResponse.cardType isEqualToString:@"MASTERCARD"]) {
            cardIO.cardNumber = [NSString stringWithFormat:@"529344445555%@",  scResponse.lastFour];
        }
        //6011 discover
        else if ([scResponse.cardType isEqualToString:@"DISCOVER"] || [scResponse.cardType isEqualToString:@"DIS"]) {
            cardIO.cardNumber = [NSString stringWithFormat:@"601114445555%@",  scResponse.lastFour];
        }
        else{
            cardIO.cardNumber = [NSString stringWithFormat:@"1289344445555%@",  scResponse.lastFour];
        }
        
        if ([scResponse.expDate length]==5)
        {
             cardIO.expiryMonth = [NSString stringWithFormat:@"0%@",[scResponse.expDate substringWithRange:NSMakeRange(0, 1)] ];
            cardIO.expiryYear = [scResponse.expDate substringWithRange:NSMakeRange(3, 2)] ;
        }
        else {cardIO.expiryMonth = [scResponse.expDate substringWithRange:NSMakeRange(0, 2)] ;

            cardIO.expiryYear = scResponse.expDate.length == 6 ? [scResponse.expDate substringWithRange:NSMakeRange(4, 2)] : [scResponse.expDate substringWithRange:NSMakeRange(2, 2)];}
        cardIO.cardTypeOne = scResponse.cardType;
        cardIO.cvv = [scResponse.expDate substringWithRange:NSMakeRange(0, 3)];

        self.firstName = @"User";
        self.lastName = scResponse.cardID;

        self.primary = scResponse.isAutoChargeCard;
        
        self.userCardType = scResponse.cardType;
        
        self.creditCardInfo = cardIO;
    }
    return self;
}

- (AMCreditCardInfo *)initWithCardID:(NSString *)cardId creditCardInfo:(CardIOCreditCardInfo *)ccInfo
{
    if (self = [super init]) {
        self.cardID = cardId;
        self.creditCardInfo = ccInfo;
    }
    return self;
}



@end

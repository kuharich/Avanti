//
//  GetHistoryResponse.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 29/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "GetHistoryResponse.h"

@implementation TransactionItem

@synthesize productName;
@synthesize productPrice;

+ (TransactionItem *)getTransactionItemWithData:(NSData *)data{
    return (TransactionItem *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)data{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.productName forKey:@"productName"];
    [encoder encodeObject:self.productPrice forKey:@"productPrice"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.productName = [decoder decodeObjectForKey:@"productName"];
        self.productPrice = [decoder decodeObjectForKey:@"productPrice"];
    }
    return self;
}

@end

@implementation GetHistoryResponse

@synthesize transactionID;
@synthesize transactionDate;
@synthesize transactionAmount;
@synthesize balance;
@synthesize transactionType;
@synthesize location;
@synthesize kiosk;
@synthesize marketCard;
@synthesize pointsEarned;
@synthesize totalTax;
@synthesize cardType;
@synthesize cardName;

@synthesize transactionsCount;
@synthesize transactionItems;

- (NSString *)navigationTitle{
    
    if ([self.transactionType isEqualToString:@"MMCCreditCardRecharge"]) {
            return [NSString stringWithFormat:@"Reload: %@", displayTransactionAmount(self.transactionAmount)];
    }
    else if ([self.transactionType isEqualToString:@"CreateCard"]) {
        return [NSString stringWithFormat:@"Create Card"];
    }
    
    else if ([self.transactionType isEqualToString:@"RewardEarned"]) {
        return [NSString stringWithFormat:@"RewardEarned"];
    }
    
    else if ([self.transactionType isEqualToString:@"CreditBonus"]) {
        return [NSString stringWithFormat:@"CreditBonus: %@", displayTransactionAmount(self.transactionAmount)];
    }
    else if ([self.transactionType isEqualToString:@"Consume"]) {
        return [NSString stringWithFormat:@"Purchase: %@", displayTransactionAmount(self.transactionAmount)];
    }
    else if ([self.transactionType isEqualToString:@"StartBalance"]) {
        return [NSString stringWithFormat:@"StartBalance"];
    }
    else{
        return [NSString stringWithFormat:@"%@: %@",self.transactionType, displayTransactionAmount(self.transactionAmount)];

    }

}



- (TransactionType)getTransactionType{
    if ([self.transactionType isEqualToString:@"MMCCreditCardRecharge"]) {
        return TransactionTypeReload;
    }
    else if ([self.transactionType isEqualToString:@"CreateCard"]) {
        return TransactionTypeCreateCard;
    }
    else if ([self.transactionType isEqualToString:@"RewardEarned"]) {
        return TransactionTypeRewardEarned;
    }
    else if ([self.transactionType isEqualToString:@"CreditBonus"]) {
        return TransactionTypeCreditBonus;
    }
    else if ([self.transactionType isEqualToString:@"Consume"]) {
        return TransactionTypePurchase;
    }
    else if ([self.transactionType isEqualToString:@"StartBalance"]) {
        return TransactionTypeStartBalance;
    }
    return TransactionTypeNone;
}

//- (NSString *)cardName{
//    return self.cardName;
//}

- (NSString *)tableCellTitle{

    if ([self.transactionType isEqualToString:@"MMCCreditCardRecharge"]) {
         return [NSString stringWithFormat:@"%@: Reload %@", displayTransactionDate(self.transactionDate), displayTransactionAmount(self.transactionAmount)];
//        if ([self.transactionAmount intValue] == 10) {//self.pointsEarned
//            return [NSString stringWithFormat:@"%@ Reload: %@", displayTransactionDate(self.transactionDate), displayTransactionAmountInAbs(self.transactionAmount)];
//        }
//        return [NSString stringWithFormat:@"%@ Reload: %@ (+%d bonus)", displayTransactionDate(self.transactionDate),
//                                                displayTransactionAmountInAbs(self.transactionAmount),
//                [self.transactionAmount intValue] == 20 ?  1 : 3];
    }
    else if ([self.transactionType isEqualToString:@"CreateCard"]) {
        return [NSString stringWithFormat:@"%@:  Create Card", displayTransactionDate(self.transactionDate)];
    }
    
    else if ([self.transactionType isEqualToString:@"RewardEarned"]) {
        return [NSString stringWithFormat:@"%@:  RewardEarned", displayTransactionDate(self.transactionDate)];
    }
    
    else if ([self.transactionType isEqualToString:@"CreditBonus"]) {
        return [NSString stringWithFormat:@"%@: Bonus %@", displayTransactionDate(self.transactionDate), displayTransactionAmount(self.transactionAmount)];
    }
    
    else if ([self.transactionType isEqualToString:@"Consume"]) {
        return [NSString stringWithFormat:@"%@:  Purchase: %@", displayTransactionDate(self.transactionDate), displayTransactionAmount(self.transactionAmount)];
    }
    else if ([self.transactionType isEqualToString:@"StartBalance"]) {
        return [NSString stringWithFormat:@"%@:  StartBalance: %@", displayTransactionDate(self.transactionDate), displayTransactionAmount(self.transactionAmount)];
    }
    return [NSString stringWithFormat:@"%@: %@ %@", displayTransactionDate(self.transactionDate),self.transactionType,displayTransactionAmount(self.transactionAmount)];;
}

+ (GetHistoryResponse *)getHistoryResponseWithData:(NSData *)data{
    return (GetHistoryResponse *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)data{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.transactionID forKey:@"transactionID"];
	[encoder encodeObject:self.transactionDate forKey:@"transactionDate"];
	[encoder encodeObject:self.transactionAmount forKey:@"transactionAmount"];
    [encoder encodeObject:self.balance forKey:@"balance"];
	[encoder encodeObject:self.transactionType forKey:@"transactionType"];
	[encoder encodeObject:self.location forKey:@"location"];
	[encoder encodeObject:self.kiosk forKey:@"kiosk"];
	[encoder encodeObject:self.marketCard forKey:@"marketCard"];
	[encoder encodeObject:self.pointsEarned forKey:@"pointsEarned"];
	[encoder encodeObject:self.totalTax forKey:@"totalTax"];
	[encoder encodeObject:self.transactionItems forKey:@"transactionItems"];
    [encoder encodeObject:self.cardName forKey:@"cardName"];
    [encoder encodeObject:self.cardType forKey:@"cardType"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.transactionID = [decoder decodeObjectForKey:@"transactionID"];
		self.transactionDate = [decoder decodeObjectForKey:@"transactionDate"];
		self.transactionAmount = [decoder decodeObjectForKey:@"transactionAmount"];
        self.balance = [decoder decodeObjectForKey:@"balance"];
		self.transactionType = [decoder decodeObjectForKey:@"transactionType"];
		self.location = [decoder decodeObjectForKey:@"location"];
		self.kiosk = [decoder decodeObjectForKey:@"kiosk"];
		self.marketCard = [decoder decodeObjectForKey:@"marketCard"];
		self.pointsEarned = [decoder decodeObjectForKey:@"pointsEarned"];
		self.totalTax = [decoder decodeObjectForKey:@"totalTax"];
		self.transactionItems = [decoder decodeObjectForKey:@"transactionItems"];
        self.cardType = [decoder decodeObjectForKey:@"cardType"];
        self.cardName = [decoder decodeObjectForKey:@"cardName"];
	}
	return self;
}

@end

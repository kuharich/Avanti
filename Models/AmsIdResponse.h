//
//  AmsIdResponse.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 7/1/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmsIdResponse : NSObject <NSCoding>

@property (strong, nonatomic) NSString *idSfdc;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *AMS_Contact_ID__c;
@property (strong, nonatomic) NSString *AccountId;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *mobilePhoneNo;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *Contact_Relationship__c;

+ (AmsIdResponse *)authenticateResponseWithData:(NSData *)data;
- (NSData *)data;

@end

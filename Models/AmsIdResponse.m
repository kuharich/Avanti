//
//  AmsIdResponse.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 7/1/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AmsIdResponse.h"

@implementation AmsIdResponse
+ (AmsIdResponse *)authenticateResponseWithData:(NSData *)data {
    return (AmsIdResponse *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)data {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:self.idSfdc forKey:@"idSfdc"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.AMS_Contact_ID__c forKey:@"AMS_Contact_ID__c"];
    [encoder encodeObject:self.AccountId forKey:@"AccountId"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:self.mobilePhoneNo forKey:@"mobilePhoneNo"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.Contact_Relationship__c forKey:@"Contact_Relationship__c"];
  
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.idSfdc = [decoder decodeObjectForKey:@"idSfdc"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.AMS_Contact_ID__c = [decoder decodeObjectForKey:@"AMS_Contact_ID__c"];
        self.AccountId = [decoder decodeObjectForKey:@"AccountId"];
        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        self.mobilePhoneNo = [decoder decodeObjectForKey:@"mobilePhoneNo"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.Contact_Relationship__c = [decoder decodeObjectForKey:@"Contact_Relationship__c"];
        
    }
    return self;
}


@end

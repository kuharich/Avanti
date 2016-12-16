//
//  AuthenticateResponse.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 23/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AuthenticateResponse.h"

@implementation AuthenticateResponse

@synthesize requestPhoneNumber;
@synthesize requestPIN;
@synthesize firstName;
@synthesize lastName;
@synthesize phoneNumber;
@synthesize email;
@synthesize amsId;
@synthesize operatorId;
@synthesize pin;
@synthesize locationId;

+ (AuthenticateResponse *)authenticateResponseWithData:(NSData *)data {
	return (AuthenticateResponse *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)data {
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeBool:self.requestPhoneNumber forKey:@"requestPhoneNumber"];
	[encoder encodeBool:self.requestPIN forKey:@"requestPIN"];

	[encoder encodeObject:self.firstName forKey:@"firstName"];
	[encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.pin forKey:@"pin"];
    [encoder encodeObject:self.amsId forKey:@"ams_id"];
    [encoder encodeObject:self.operatorId forKey:@"operatorId"];
    [encoder encodeObject:self.locationId forKey:@"locationId"];

}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.requestPhoneNumber = [decoder decodeBoolForKey:@"requestPhoneNumber"];
		self.requestPIN = [decoder decodeBoolForKey:@"requestPIN"];

		self.firstName = [decoder decodeObjectForKey:@"firstName"];
		self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.pin = [decoder decodeObjectForKey:@"pin"];
        self.amsId = [decoder decodeObjectForKey:@"ams_id"];
        self.operatorId = [decoder decodeObjectForKey:@"operatorId"];
        self.locationId = [decoder decodeObjectForKey:@"locationId"];

	}
	return self;
}

@end

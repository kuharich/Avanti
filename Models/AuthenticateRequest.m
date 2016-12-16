//
//  AuthenticateRequest.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 23/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AuthenticateRequest.h"

@implementation AuthenticateRequest

@synthesize userName;
@synthesize userPassword;

+ (AuthenticateRequest *)authenticateResuestWithData:(NSData *)data {
	return (AuthenticateRequest *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)data {
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)emailId {
	return self.userName;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.userName forKey:@"userName"];
	[encoder encodeObject:self.userPassword forKey:@"userPassword"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.userName = [decoder decodeObjectForKey:@"userName"];
		self.userPassword = [decoder decodeObjectForKey:@"userPassword"];
	}
	return self;
}

@end

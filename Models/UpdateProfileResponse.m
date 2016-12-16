//
//  UpdateProfileResponse.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/20/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "UpdateProfileResponse.h"

@implementation UpdateProfileResponse
+ (UpdateProfileResponse *)authenticateResponseWithData:(NSData *)data {
    return (UpdateProfileResponse *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)data {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:self.email forKey:@"contactEmail"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        self.email = [decoder decodeObjectForKey:@"contactEmail"];
    }
    return self;
}

@end

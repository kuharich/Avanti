//
//  AuthenticateResponse.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 23/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticateResponse : NSObject <NSCoding>
{
	BOOL    requestPhoneNumber;
	BOOL    requestPIN;
	NSString *firstName;
	NSString *lastName;
    NSString *phoneNumber;
    NSString *email;
    
    NSString *pin;
    NSString *amsId;
    NSString *operatorId;
    NSString *locationId;
}

@property (nonatomic, assign) BOOL  requestPhoneNumber;
@property (nonatomic, assign) BOOL  requestPIN;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) NSString *pin;
@property (strong, nonatomic) NSString *amsId;
@property (strong, nonatomic) NSString *operatorId;
@property (strong, nonatomic) NSString *locationId;

+ (AuthenticateResponse *)authenticateResponseWithData:(NSData *)data;
- (NSData *)data;
@end

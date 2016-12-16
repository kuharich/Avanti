//
//  AuthenticateRequest.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 23/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticateRequest : NSObject <NSCoding>

//user name
@property (strong, nonatomic) NSString *userName;

//password
@property (strong, nonatomic) NSString *userPassword;//will


@property (strong, nonatomic, readonly) NSString *emailId;

+ (AuthenticateRequest *)authenticateResuestWithData:(NSData *)data;
- (NSData *)data;
@end

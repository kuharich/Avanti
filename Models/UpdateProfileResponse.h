//
//  UpdateProfileResponse.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/20/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateProfileResponse : NSObject
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
+ (UpdateProfileResponse *)authenticateResponseWithData:(NSData *)data;
- (NSData *)data;
@end

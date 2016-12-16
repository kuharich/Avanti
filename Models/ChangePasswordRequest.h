//
//  ChangePasswordRequest.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/26/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangePasswordRequest : NSObject
@property (strong, nonatomic) NSString *oldpassword;
@property (strong, nonatomic) NSString *newpassword;

@end

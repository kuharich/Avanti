//
//  Feedback.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/22/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject<NSCoding>
@property (strong, nonatomic) NSString *feedBackType;

+ (Feedback *)authenticateResponseWithData:(NSData *)data;
- (NSData *)data ;


@end

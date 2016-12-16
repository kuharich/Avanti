//
//  FeedBackRequest.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/22/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackRequest : NSObject
@property (strong, nonatomic) NSString *consumerAmsId;
@property (strong, nonatomic) NSString *feedbackCategory;
@property (strong, nonatomic) NSString *feedbackDetails;
+ (FeedBackRequest *)authenticateResponseWithData:(NSData *)data;
- (NSData *)data ;@end

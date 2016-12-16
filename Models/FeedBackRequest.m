//
//  FeedBackRequest.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/22/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "FeedBackRequest.h"

@implementation FeedBackRequest
+ (FeedBackRequest *)authenticateResponseWithData:(NSData *)data {
    return (FeedBackRequest *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}
- (NSData *)data {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.consumerAmsId forKey:@"consumerAmsId"];
    [encoder encodeObject:self.feedbackCategory forKey:@"feedbackCategory"];
    [encoder encodeObject:self.feedbackDetails forKey:@"feedbackDetails"];

    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        self.feedbackDetails = [decoder decodeObjectForKey:@"feedbackDetails"];
        self.feedbackCategory = [decoder decodeObjectForKey:@"feedbackCategory"];
        self.consumerAmsId = [decoder decodeObjectForKey:@"consumerAmsId"];

        
    }
    return self;
}
@end

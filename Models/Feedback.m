//
//  Feedback.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/22/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "Feedback.h"

@implementation Feedback
+ (Feedback *)authenticateResponseWithData:(NSData *)data {
    return (Feedback *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)data {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.feedBackType forKey:@"feedBackType"];
   
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        self.feedBackType = [decoder decodeObjectForKey:@"feedBackType"];
       
    }
    return self;
}

@end

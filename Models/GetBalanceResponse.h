//
//  GetBalanceResponse.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 31/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetBalanceResponse : NSObject 
{
	NSNumber *userBalance;
}

@property (strong, nonatomic) NSNumber *userBalance;



@end

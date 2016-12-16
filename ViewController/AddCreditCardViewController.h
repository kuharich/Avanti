//
//  AddCreditCardViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCreditCardInfo.h"

@interface AddCreditCardViewController : AMViewController

@property (nonatomic, assign) BOOL isUpdateCard;

- (void)loadCreditCardDetail:(AMCreditCardInfo *)cardInfo;
@end

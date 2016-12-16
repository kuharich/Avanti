//
//  AddMarketCardViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 10/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMarketCardViewController : AMViewController

@property (nonatomic, strong) NSString *scanedMMCardBarCode;

@property (nonatomic, assign) BOOL isUpdateCard;


- (void)loadMyMarketCardDetail:(AMMarketCardInfo *)cardInfo;

@end

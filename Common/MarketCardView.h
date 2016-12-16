//
//  MarketCardView.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 08/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMMarketCardInfo.h"

@protocol MarketCardViewDelegate;

@interface MarketCardView : UIViewController

@property (nonatomic, strong) NSString  *mScanCode;
@property (nonatomic, weak) id<MarketCardViewDelegate> delegate;

//- (void)setCardID:(int)cardID cardName:(NSString *)cardName balance:(NSNumber *)balance cardcolor:(NSInteger )cardColor;
- (void)loadMarketCardDetail:(AMMarketCardInfo *)cardInfo balance:(NSNumber *) balance;
@end


@protocol MarketCardViewDelegate <NSObject>

@required

- (void)deleteButtonPressed:(MarketCardView *)cardView;


@end
//
//  AddCreditCardViewViewController.h
//  AvantiMarket
//
//  Created by Mark Kuharich on 3/2/16.
//  Copyright © 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCreditCardViewViewController : AMViewController

@property (nonatomic, weak) id<CreditCardViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnCardArea;
@end

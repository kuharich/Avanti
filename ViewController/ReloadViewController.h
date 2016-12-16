//
//  ReloadViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 31/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardViewController.h"

@interface ReloadViewController : AMViewController<CreditCardViewDelegate>
-(void)showAlertviewToSaveCard;
@property(nonatomic,strong)UIAlertView *alert;
-(IBAction)deleteButtonPressed:(id)sender;
-(IBAction) cardTapped:(id) sender;
@end

//
//  CreditCardView.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCreditCardInfo.h"

@protocol CreditCardViewDelegate;


@interface CreditCardViewController : UIViewController

@property (nonatomic, weak) id<CreditCardViewDelegate> delegate;

@property (nonatomic,copy, readonly) NSString *cardID;
@property (weak, nonatomic) IBOutlet UIImageView *borderImage;

- (void)loadCreditCardDetail:(AMCreditCardInfo *)cardInfo;
- (void) selectCard;
- (void) deselectCard;
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle selected: (BOOL) selected;

@end



@protocol CreditCardViewDelegate <NSObject>

@required

- (void)deleteButtonPressed:(CreditCardViewController *)cardView;
- (void) cardTapped:(CreditCardViewController *) cardView;

@end

//
//  AMViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 07/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "CreditCardViewController.h"

@class AmountButton;

typedef enum {
    LeftMenuBarButtonItemSideMenu   = 0,
    LeftMenuBarButtonItemBackItem   = 1,
    LeftMenuBarButtonItemNone       = 2
} LeftMenuBarButtonItem;

@interface AMViewController : UIViewController

- (void)resignView:(UIView *)v;

- (void)setupMenuBarButtonItemsShow:(LeftMenuBarButtonItem )itemToDisplay;
- (void)leftSideMenuButtonPressed:(id)sender;
- (void)backSideMenuButtonPressed:(id)sender;
- (UIStatusBarStyle)preferredStatusBarStyle;
- (UIImage *)imageFromLayer:(CALayer *)layer;
-(void) orangeGradient;
-(void) greenGradient;
-(void) tallerGreenGradient:(UIView *) view;
-(void) markTextFieldWithError: (UITextField *) view;
-(void) setPlaceholderColor: (UITextField *) view text:(NSString *) text;
-(void) setSubmitButtonColor: (UIButton *) button;
-(void) setCancelButtonColor: (UIButton *) button;
-(void) setButtonColor: (UIButton *) button R: (int) red G: (int) green B: (int) blue;
-(void) setForgotButtonColor: (UIButton *) button;
-(void) solidGradient: (UIColor *) color;
-(void) setCustomBackgroundImage:(UIImageView *) image;
-(void) setCustomBackgroundColor:(UIImageView *) image;
-(void) setCustomViewColor:(UIView *) view;
-(void) setCustomRegularButtonTextColor: (UIButton *) button;
-(void) setCustomPlaceholderColor: (UITextField *) view text:(NSString *) text;
-(void) setCustomTextFieldColor:(UITextField *) field;
-(BOOL) brandHasLightBackgroundColor;
-(void) setCustomLightBackgroundColor:(UIView *) view;
-(void) tallerCustomGradient:(UIView *) view;
-(void) setCustomButtonTextColor: (UIButton *) button key: (NSString *) key;
-(void) setCustomLabelColor:(UILabel *) field;
-(void) setCustomTitleColor:(UILabel *) field;
-(void) setCustomTitleTextColorAttribute: (UINavigationBar *) navigationBar;
-(void) setCustomReloadAmountHeaderLabelColor:(UILabel *) label;
-(void) setCustomAmountButtonColors: (AmountButton *) button;
-(void) customGradient;
-(void) setCustomBackgroundGradient: (AMViewController *) viewController;
-(void) setCustomRegularButtonBackgroundColor: (UIButton *) button;
-(NSString *) getCustomPath: (NSString *) path;
-(void) setCustomLabelText: (UILabel *) label key: (NSString *) key;
-(void) setCustomMenuItemSelectedColor: (UITableViewCell *) cell;
-(void) setCustomTextViewFont:(UITextView *) textView;
-(void) setCustomTextViewColor:(UITextView *) textView;
-(NSString *) quicksandFontName;
-(NSString *) quicksandBoldFontName;
-(NSString *) getCustomSupportUrl: (NSString *) path;
-(void) setCustomButtonSecondaryTextColor:(UIButton *) button;
-(void) setInfoBoxLabelColor:(UILabel *) label;
-(void) setCustomBodyTextColor:(UILabel *) label;
-(void) setCustomSecondaryLabelColor:(UILabel *) label;
-(void) setCustomCancelButtonTextColor: (UIButton *) button;
-(void) setCustomCancelButtonBackgroundColor:(UIView *) view;
-(void) setCustomLoginButtonBackgroundColor: (UIButton *) button;

@end

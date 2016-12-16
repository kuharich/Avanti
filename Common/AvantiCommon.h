//
//  AvantiCommon.h
//  AvantiMarkets
//
//  Created by Deepak Sahu on 17/03/15.
//  Copyright (c) 2015 BYNDL. All rights reserved.
//

#ifndef AvantiMarkets_AvantiCommon_h
#define AvantiMarkets_AvantiCommon_h

#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AMUtilities.h"
#import "StringEncryption.h"
#import "WSLAlertViewAutoDismiss.h"
#import "AuthenticateRequest.h"
#import "AuthenticateResponse.h"
#import "GetBalanceResponse.h"
#import "StoredCardsResponse.h"
#import "ScanCodesResponse.h"
#import "ChargeStoredCardRequest.h"
#import "ResultResponse.h"
#import "GetHistoryResponse.h"

#import "MFSideMenu.h"

#import "AMSideMenuViewController.h"
#import "AMPINViewController.h"

#import "AMHomeViewController.h"
#import "SupportViewController.h"
#import "PayViewController.h"

#import "SMPageControl.h"



#define AVANTI_FORGET_PASSWORD      @"https://www.mykioskcard.com/Account/LostPassword"
#define AVANTI_SERVER_API_LOCAL     @"http://localhost/"
#define AVANTI_SF_API_URL           @"https://byndlsfapi.byndl.com"
#define AVANTI_SF_URL_LOCAL         @"http://localhost/"


#define AVANTI_SERVER_API_PROD_URL  @"https://mobileapi.mykioskworld.com/"
#define AVANTI_SERVER_API_STAGING_URL @"https://az-stage-003-mobile.mykioskworld.com/"
#define AVANTI_SERVER_API_TEST_URL  @"http://azure.test.mobile.blueintel.com/"

#define SUPPORT_BASE_PROD_URL       @"https://mobilesupport.mykioskworld.com/content/support.html"
#define SUPPORT_BASE_STAGING_URL    @"https://av-preprod-mobilesupport-stage.mykioskworld.com/content/support.html"
#define SUPPORT_BASE_TEST_URL       @"https://av-preprod-mobilesupport-test.mykioskworld.com/content/support.html"

#define MIXPANEL_PROD_TOKEN         @"ccc4231ffdc1624f7591999faabdf22f"
#define MIXPANEL_STAGING_TOKEN      @"8b221ec6c5e9723b39cfc9032001e98c"
#define MIXPANEL_TEST_TOKEN         @"1555dfae6a8496d0b95a6c96fdb68aab"



#ifdef STAGING
#define AVANTI_SERVER_API_URL       AVANTI_SERVER_API_STAGING_URL
#define SUPPORT_BASE_URL            SUPPORT_BASE_STAGING_URL
#define MIXPANEL_TOKEN              MIXPANEL_STAGING_TOKEN
#elif TEST
#define AVANTI_SERVER_API_URL       AVANTI_SERVER_API_TEST_URL
#define SUPPORT_BASE_URL            SUPPORT_BASE_TEST_URL
#define MIXPANEL_TOKEN              MIXPANEL_TEST_TOKEN
#else
#define AVANTI_SERVER_API_URL       AVANTI_SERVER_API_PROD_URL
#define SUPPORT_BASE_URL            SUPPORT_BASE_PROD_URL
#define MIXPANEL_TOKEN              MIXPANEL_PROD_TOKEN
#endif


#define SDFC_SERVER_URL             AVANTI_SF_API_URL






#define AVANTI_SERVER_API_RUN       true
#define SDFC_SERVER                 true

static NSString* const kMethodGet     = @"GET";
static NSString* const kMethodPost    = @"POST";
static NSString* const kMethodPut     = @"PUT";
static NSString* const kMethodDelete  = @"DELETE";

static NSString* const kPathAuthenticate            = @"api/v1/authenticate";
static NSString* const kPathGetBalance              = @"api/v1/getBalance";
static NSString* const kPathGetScanCodes            = @"api/v1/getScanCodes";
static NSString* const kPathGetStoredCards          = @"api/v1/getStoredCards";
static NSString* const kPathGetHistory              = @"api/v1/getHistory";
static NSString* const kPathAddStoredCard           = @"api/v1/addStoredCard";
static NSString* const kPathGetHistoryByPage        = @"api/v1/getHistory/120/";
static NSString* const kPathGetDiscounts            = @"api/v1/getdiscounts";
static NSString* const kPathGetHasDiscounts            = @"api/v1/hasdiscounts";

static NSString* const kPathGetHistoryDetailsByID            = @"api/v1/getHistoryDetails/";

static NSString* const kPathChargeStoredCard        = @"api/v1/chargeStoredCard";
static NSString* const kPathGetGlobalGetWay         = @"/api/v1/GetGGE4Params";
static NSString* const kPathDeleteLastSavedStoredCard       = @"api/v1/deleteLastSavedStoredCard";
static NSString* const kPathDeleteStoredCard       = @"/api/v1/deleteStoredCard";

static NSString* const kPathGetReloadDenominations  = @"api/v1/getReloadDenominations";
static NSString* const kPathGetUserPin              = @"api/v1/getUserPin";
static NSString* const kPathSetUserPin              = @"api/v1/setUserPin";
static NSString* const kPathRestPassword            = @"api/v1/resetPassword";
static NSString* const kPathChangePassword          = @"api/v1/changePassword";
static NSString* const kPathGetAutoReloadSettings          = @"api/v1/getAutoRechargeSettings";
static NSString* const kPathUpdateProfile           = @"api/v1/updateProfile";
static NSString* const kGetFeedbackList             = @"api/v1_0/Picklist/Case_FeedbackCategory";
static NSString* const kPathPostFeedback            = @"api/v1_0/Case/CreateFeedback";
static NSString* const kGetIssueType                = @"api/v1_0/Picklist/Case_ConsumerRequestCategory";
static NSString* const kGetSubIssueType             = @"api/v1_0/Picklist/Case_ConsumerIssueType";
static NSString* const kPathCreateIssue             = @"api/v1_0/Case/Create";
static NSString * const KPathGetArticle              = @"api/v1_0/Article/List";
static NSString * const KPathGetArticleDescription              = @"/api/v1_0/Article";
static NSString * const KPathAMSid             = @"/api/v1_0/Consumer";
static NSString * const KPathCreateSFDC             = @"api/v1_0/Consumer/Create";
static NSString * const KPathGetShowContactUs       =@"api/v1_0/Operator/ContactUs";
static NSString * const KPathGetSalesForceToken       =@"api/v1/getSalesForceToken";

#define CHARACTER_LIMIT_CARD_NAME       30
#define CHARACTER_LIMIT_EMAIL           50
#define CHARACTER_LIMIT_PASSWORD        30
#define CHARACTER_LIMIT_ZIP_CODE        5
#define CHARACTER_LIMIT_CVC_CODE        3

#define NSUSERDEFAULT_SET_PASSWORD_LOCK         @"PASSWORD_LOCK"
#define NSUSERDEFAULT_SET_NOTI_MESSAGES         @"PUSHNOTI_MESSAGES"
#define NSUSERDEFAULT_SET_NOTI_RECEIPTS         @"PUSHNOTI_RECEIPTS"

#define NSUSERDEFAULT_StoredEncryptedPass       @"StoredEncryptedPass"


#define NSUSERDEFAULT_CREDIT_CARDS          @"CreditCards"
#define NSUSERDEFAULT_MARKET_CARDS          @"MarketCards"

#define NSUSERDEFAULT_PRIMARY_CREDIT_CARD          @"CreditCardPrimary"
#define NSUSERDEFAULT_PRIMARY_MARKET_CARD          @"MarketCardPrimary"

#define HIDE_ADD_CARD_VIEW          false
#define HIDE_ADD_CARD_VIEW1          true

#define FONT_Avenir_LT_Std_Light            @"AvenirLTStd-Light"//@"Avenir LT Std 35 Light"
#define FONT_Avenir_LT_Std_Light_Oblique    @"AvenirLTStd-LightOblique"//@"Avenir LT Std 35 Light Oblique"

#define FONT_Avenir_LT_Std_Book             @"AvenirLTStd-Book"//@"Avenir LT Std 45 Book"
#define FONT_Avenir_LT_Std_Book_Oblique     @"AvenirLTStd-BookOblique"//@"Avenir LT Std 45 Book Oblique"

#define FONT_Avenir_LT_Std_Roman            @"AvenirLTStd-Roman"//@"Avenir LT Std 55 Roman"
#define FONT_Avenir_LT_Std_Roman_Oblique    @"AvenirLTStd-Oblique"//@"Avenir LT Std 55 Oblique"

#define FONT_Avenir_LT_Std_Medium           @"AvenirLTStd-Medium"//@"Avenir LT Std 65 Medium"
#define FONT_Avenir_LT_Std_Medium_Oblique   @"AvenirLTStd-MediumOblique"//@"Avenir LT Std 65 Medium Oblique"

#define FONT_Avenir_LT_Std_Heavy            @"AvenirLTStd-Heavy"//@"Avenir LT Std 85 Heavy"
#define FONT_Avenir_LT_Std_Heavy_Oblique    @"AvenirLTStd-HeavyOblique"//@"Avenir LT Std 85 Heavy Oblique"

#define FONT_Avenir_LT_Std_Black            @"AvenirLTStd-Black"//@"Avenir LT Std 95 Black"
#define FONT_Avenir_LT_Std_Black_Oblique    @"AvenirLTStd-BlackOblique"//@"Avenir LT Std 95 Black Oblique"

#define DEFAULT_FONT_NAME           FONT_Avenir_LT_Std_Roman    //@"Heiti TC"//@"Heiti TC Light/Medium"//STHeitiK-Medium

#define DEFAULT_COLOR_THEME_DARK_YELLOW     [UIColor colorWithRed:255.0f/255.0f green:212.0f/255.0f blue:52.0f/255.0f alpha:1.0f]
#define DEFAULT_COLOR_THEME_DARK_GREEN      [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:64.0f/255.0f alpha:1.0f] //rgb(0,128,64)
#define DEFAULT_COLOR_THEME_DARK_ORANGE     [UIColor colorWithRed:255.0f/255.0f green:128.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
#define DEFAULT_COLOR_THEME_LIGHT_ORANGE     [UIColor colorWithRed:255.0f/255.0f green:128.0f/255.0f blue:0.0f/255.0f alpha:0.7f]
#define DEFAULT_COLOR_THEME_DARK_BLUE       [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]

#define DEFAULT_COLOR_THEME_TEXT_GRAY       [UIColor colorWithRed:94.0f/255.0f green:94.0f/255.0f blue:94.0f/255.0f alpha:1.0f]
#define DEFAULT_COLOR_THEME_NAVIGATION      [UIColor colorWithRed:86.0f/255.0f green:86.0f/255.0f blue:86.0f/255.0f alpha:1.0f]

#define DEFAULT_COLOR_THEME_GREEN       [UIColor colorWithRed:119.0f/255.0f green:195.0f/255.0f blue:79.0f/255.0f alpha:1.0f]
#define DEFAULT_COLOR_THEME_WHITE       [UIColor whiteColor]
#define DEFAULT_COLOR_THEME_GRAY        [UIColor lightGrayColor]//[UIColor colorWithRed:197.0f/255.0f green:198.0f/255.0f blue:200.0f/255.0f alpha:1.0f]

#define DEFAULT_COLOR_THEME_LBLUE       [UIColor colorWithRed:74.0f/255.0f green:126.0f/255.0f blue:187.0f/255.0f alpha:1.0f]

#define LOGIN_ERROR_ALERT_TITLE         @"Log-in Error"
#define LOGIN_ERROR_ALERT_MESSAGE       @"Please check your sign-in information and try again."

#define NETWORK_ERROR_ALERT_TITLE       @"Network Error"
#define NETWORK_ERROR_ALERT_MESSAGE     @"Please check your internet connection and try again."

#define SERVER_ERROR_ALERT_TITLE        @"Server Error"
#define SERVER_ERROR_ALERT_MESSAGE      @"Our server is currently busy. Please try again later."

#define HISTORY_NO_RECORD_ALERT_TITLE   @"Account History"
#define HISTORY_NO_RECORD_ALERT_MESSAGE @"No transaction history in records."
#define NO_AUTO_RELOAD_SETTINGS_MSG @"Go to MyMarketCard.com to set up your auto-reload preferences.  Funds will automatically be added to your account based on rules you set!"


#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height < 568.0f)
#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height > 568.0f)

typedef enum
{
    MenuItemSectionTopMenu      = 0,
    MenuItemSectionBottomMenu   = 1,
    MenuItemSectionOthers       = 2,


    MenuItemMyAccount       = 0,
    MenuItemSUPPORT         = 1,
    MenuItemPAY             = 2,
    MenuItemREWARDS         = 3,
    MenuItemRELOAD          = 4,
    MenuItemACCOUNT_HISTORY = 5,
    MenuItemLOCATIONS       = 6,


    MenuItemAVANTI_LOGO     = 100,
    MenuItemSIGNOUT         = 102
} MenuItem;


//typedef enum {
//    MarketCardColorAqua     = 0,
//    MarketCardColorBlue     = 1,
//    MarketCardColorGreen    = 2,
//}MarketCardColor;

typedef NS_ENUM(NSInteger, MarketCardColor) {
    MarketCardColorAqua     = 0,
    MarketCardColorBlue     = 1,
    MarketCardColorGreen    = 2
};

typedef NS_ENUM(NSInteger, UIAlertViewTag) {
    UIAlertViewTagIncorrectPin     = 200,
    UIAlertViewTagLoginError,
    UIAlertViewTagProfileUpdate,
    UIAlertViewTagFirstLoginCancel,
    UIAlertViewTagDeleteConfirmation,
    UIAlertViewTagUpdateConfirmation,
    UIAlertViewTagPinChangeSuccess,
};


extern NSString *const AMCreditCardSaveSuccessNotification;
extern NSString *const AMMarketCardSaveSuccessNotification;
extern NSString *const AMGetBalanceSuccessNotification;
extern NSString *const AMSignOutSuccessNotification;
extern NSString*const AMGetDiscountsSuccessNotification;

inline static NSString *displayBalance(NSNumber *payValue){
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
   return [numberFormatter stringFromNumber:[AMUtilities sharedUtilities].balance.userBalance];
}

inline static NSString *displayTransactionAmountInAbs(NSNumber *amount){
    return [NSString stringWithFormat:@"$%ld",labs([amount integerValue])];
}

inline static NSString *displayTransactionAmount(NSNumber *amount){
    return [NSString stringWithFormat:@"$%.2f",fabsf([amount floatValue])];
}

inline static NSString *displayTotalAmount(NSNumber *amount){
    return [NSString stringWithFormat:@"$%.2f",fabsf([amount floatValue])];
}

inline static NSString *displayTransactionDate(NSString *transDate){
    NSArray *arr = [transDate componentsSeparatedByString:@" "];
    return arr.count == 0 ? @"" : [arr objectAtIndex:0];
}

inline static UIAlertView *displayAlert(NSString *title, NSString *message , id delegate, NSString *cancelButtonTitle)
{
    if (cancelButtonTitle==nil) {
        cancelButtonTitle = @"OK";
    }
    
    WSLAlertViewAutoDismiss *uiAlert = [[WSLAlertViewAutoDismiss alloc] initWithTitle:title
                                                      message:message delegate:delegate
                                            cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [uiAlert show];
    return uiAlert;
}

inline static void displayAlertWithMessage(NSString *message)
{
    displayAlert(nil, message, nil, nil);
}

inline static void displayAlertWithTitleMessage(NSString *title, NSString *message)
{
    displayAlert(title, message, nil, nil);
}

inline static BOOL validateEmail (NSString *email)  {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

inline static BOOL validateZipCode (NSString *zipCode)  {
    
    bool returnValue = false;
    NSString *zipcodeExpression = @"^[0-9]{5}(-/d{4})?$"; //U.S Zip ONLY!!!
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:zipcodeExpression options:0 error:NULL];
    
    NSTextCheckingResult *match = [regex firstMatchInString:zipCode options:0 range:NSMakeRange(0, [zipCode length])];
    if (match)
    {
        returnValue = true;
    }
    return returnValue;
}

inline static void addBorderInViewWithValue(UIView *myView,UIColor *textColor, UIColor *backgroudColor, CGFloat cornerRadius, CGFloat borderWidth)  {
    myView.layer.cornerRadius = cornerRadius;
    myView.layer.borderColor = [textColor CGColor];
    myView.layer.borderWidth = borderWidth;
    myView.layer.masksToBounds = YES;
    myView.layer.backgroundColor = [backgroudColor CGColor];
}

inline static void addBorderInView (UIView *myView)  {
    addBorderInViewWithValue(myView,[UIColor clearColor], DEFAULT_COLOR_THEME_GREEN, 5.0, 1.0);
}

inline static void addBorderInTextField (UITextField *txtField)  {
    txtField.text = @"";
    txtField.placeholder = @"";
    txtField.layer.cornerRadius = 2.0;
    txtField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtField.layer.borderWidth=1.0;
}

inline static void formatButtonWithBorder(UIButton *btn, UIColor *textColor, UIColor *backgroudColor, BOOL isDisabled)  {
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn.titleLabel setNumberOfLines:2];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn setEnabled:!isDisabled];
    addBorderInViewWithValue(btn, textColor,backgroudColor, 1.0f, 2.0f);
}

inline static void formatButtonWithoutBorder(UIButton *btn, UIColor *textColor, UIColor *backgroudColor, BOOL isDisabled)  {
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn.titleLabel setNumberOfLines:2];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn setEnabled:!isDisabled];
    [[btn titleLabel] setFont:[UIFont fontWithName:FONT_Avenir_LT_Std_Heavy size:17]];
    addBorderInViewWithValue(btn, textColor, backgroudColor, 1.0f, 0.0f);
}

inline static void formatDisbaledButton(UIButton *btn){
    formatButtonWithoutBorder(btn, DEFAULT_COLOR_THEME_WHITE, DEFAULT_COLOR_THEME_GRAY, YES);
}

inline static void formattedButtonText(UIButton *btn, NSString *plainTextBegin, NSString *formattedText, NSString *plainTextEnd ){
    // underline Terms and condidtions
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", plainTextBegin, formattedText, plainTextEnd]];

    [tncString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_Avenir_LT_Std_Heavy size:12] range:NSMakeRange(0,tncString.length)];
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,tncString.length)];
    
    // workaround for bug in UIButton - first char needs to be underlined for some reason!
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:119.0f/255.0f green:195.0f/255.0f blue:79.0f/255.0f alpha:1.0f]
                      range:NSMakeRange(plainTextBegin.length, formattedText.length)];
    
    // For underline
    //[tncString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){5,[tncString length] - 5}];
    
    [btn setAttributedTitle:tncString forState:UIControlStateNormal];
    
}

inline static NSAttributedString *formattedText(NSString *text2format, CGFloat fontSize){
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:text2format];
    [tncString addAttribute:NSFontAttributeName value:[UIFont fontWithName:DEFAULT_FONT_NAME size:fontSize] range:NSMakeRange(0,tncString.length)];
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,tncString.length)];
    //[tncString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){0,[tncString length]}];
    /*NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:fontSize*0.1];
    [tncString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,tncString.length)];*/
    return tncString;
}

inline static NSAttributedString *formattedTt(NSString *text2format, CGFloat fontSize){
    // underline Terms and condidtions
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:text2format];
    
    [tncString addAttribute:NSFontAttributeName value:[UIFont fontWithName:DEFAULT_FONT_NAME size:fontSize] range:NSMakeRange(0,tncString.length)];
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,tncString.length)];
    return tncString;
    
}


//inline static NSAttributedString *formattedTextWithMultiColot(NSString *plainText, NSString *formatText, UIFont *normalFont, UIFont *formatFont, UIColor *plainColor, UIColor *formatColor){
//    
//    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@", plainText, formatText]];
//    
//    [attributedText addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0,attributedText.length)];
//    [attributedText addAttribute:NSFontAttributeName value:formatFont range:NSMakeRange(plainText.length,formatText.length)];
//  
//    [attributedText addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0,attributedText.length)];
//    [attributedText addAttribute:NSFontAttributeName value:formatFont range:NSMakeRange(plainText.length,formatText.length)];
//    
//    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,attributedText.length)];
//    
//    [attributedText addAttribute:NSForegroundColorAttributeName value:DEFAULT_COLOR_THEME_DARK_YELLOW range:NSMakeRange(attributedText.length-2, 2)];
//    
//    return attributedText;
//}

#endif

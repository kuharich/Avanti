//
//  AAMixpanel.h
//  AvantiMarket
//
//  Created by Vivek Bayalusime on 03/07/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *sessionId;

@interface AAMixpanel : NSObject
//Get current timestamp
+ (NSString *) getTimestamp;
//Page View
+ (void)pageView:(NSString *)pageName;

//Login/logout
+ (void)loginSuccess:(NSString *)idnt operatorid:(NSString *)operatorId locationid:(NSString *)locationId;
+ (void)loginFailure:(NSString *)errorType witherrorCode:(NSString *)errorCode;
+ (void)signOutSuccess;

//Profile setup
+ (void)profileSetupSuccess;
+ (void)profileSetupFailure:(NSString *)errorType witherrorCode:(NSString *)errorCode;

//pin login
+ (void)pinLoginSuccess:(NSString *)idnt operatorid:(NSString *)operatorId locationid:(NSString *)locationId;
//+ (void)pinLoginFailure:(NSString *)errorMessage;
+ (void)pinRetry:(NSString *)cnt;

//Forgot password
+ (void)forgotPasswordSuccess;
+ (void)forgotPasswordFailure:(NSString *)errorType witherrorCode:(NSString *)errorCode;

//Reload
+ (void)reloadSuccess:(NSString *)reloadType amount:(NSString *)amount;
+ (void)reloadFailure:(NSString *)reloadType amount:(NSString *)amount errortype:(NSString *)errorType witherrorCode:(NSString *)errorCode;


//Support->Feedback
+ (void)submitFeedbackSuccess:(NSString *)feedbackCategory;
+ (void)submitFeedbackFailure:(NSString *)feedbackCategory errortype:(NSString *)errorType witherrorCode:(NSString *)errorCode;

//Support->article (did you see/using the market/using the app)
+ (void)articleSuccess:(NSString *)section category:(NSString *)category;
+ (void)aerticleFailure:(NSString *)section category:(NSString *)category anderrortype:(NSString *)errorType errorCode:(NSString *)errorCode;

//Case creation (ContactUs)
+ (void)caseSuccess:(NSString *)category andissuetype:(NSString *)issueType;
+ (void)caseFailure:(NSString *)category andissuetype:(NSString *)issueType anderrortype:(NSString *)errorType errorCode:(NSString *)errorCode;

//Support->ContactUs(DidUSee article details)
//Support->Helpful howto's-> Usin the market/using the app(article details)
+ (void)articleDetailsSuccess:(NSString *)section withArticleid:(NSString *)articleId articlename:(NSString *)articleName;
+ (void)articleDetailsFailure:(NSString *)section withArticleid:(NSString *)articleId articlename:(NSString *)articleName errortype:(NSString *)errorType errorCode:(NSString *)errorCode;

//Search
//Support->article (did you see/using the market/using the app)
+ (void)searchSuccess:(NSString *)section searchterm:(NSString *)searchTerm;
+ (void)searchFailure:(NSString *)section searchterm:(NSString *)searchTerm errortype:(NSString *)errorType errorcode:(NSString *)errorCode;

//App installed
+ (void)appInstalled;

//Session

+ (void)sessionEnd;

+ (void)notRegisteredDisplayed;
+ (void)discountSuccess;
+ (void)supportSectionViewed;

@end

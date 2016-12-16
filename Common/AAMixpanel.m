//
//  AAMixpanel.m
//  AvantiMarket
//
//  Created by Vivek Bayalusime on 03/07/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AAMixpanel.h"
#import "Mixpanel.h"
#import "SFToken.h"
#import <sys/utsname.h>

@implementation AAMixpanel

+ (NSString *) getTimestamp
{
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    [dateFormat setTimeZone:timeZone];
    [timeFormat setTimeZone:timeZone];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    return [NSString stringWithFormat:@"%@ %@",theDate,theTime];
}

+ (void)appInstalled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"appinstalled"]) {
        //don't do anything
    } else {
        [[Mixpanel sharedInstance] track:@"Application Installed"
                              properties:@{@"Timestamp": [self getTimestamp]}];
        [[Mixpanel sharedInstance] flush];
        
        [userDefaults setBool:YES forKey:@"appinstalled"];
        [userDefaults synchronize];
    }
}

+ (NSString*)getDeviceType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //MARK: More official list is at
    //http://theiphonewiki.com/wiki/Models
    //MARK: You may just return machineName. Following is for convenience
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"iPhone Simulator",
      @"x86_64":   @"iPhone Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+ (GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6 (GSM+CDMA)",
      
      @"iPhone8,1":    @"iPhone 6S (GSM+CDMA)",
      @"iPhone8,2":    @"iPhone 6S+ (GSM+CDMA)",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad5,3":  @"iPad Air 2 (WiFi)",
      @"iPad5,4":  @"iPad Air 2 (GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPad4,7":  @"iPad Mini 3G (WiFi)",
      @"iPad4,8":  @"iPad Mini 3G (GSM)",
      @"iPad4,9":  @"iPad Mini 3G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      @"iPod7,1":  @"iPod 6th Gen",
      };
//    NSString *myString = @"hello bla bla";
//    NSRange rangeValue = [myString rangeOfString:@"hello" options:NSCaseInsensitiveSearch];
//    
    NSString *deviceName = commonNamesDictionary[machineName];
    NSRange rangeValue = [deviceName rangeOfString:@"iPod" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0){
        deviceName = @"iPod";
        return deviceName;
    }
    
    rangeValue = [deviceName rangeOfString:@"iPad" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0){
        deviceName = @"iPad";
        return deviceName;
    }
    rangeValue = [deviceName rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0){
        deviceName = @"iPhone";
        return deviceName;
    }
   
   
    return deviceName =machineName;
}
+ (NSString*)getDeviceClass {
    
    NSString *deviceType = [self getDeviceType];
    
    NSRange rangeValue = [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0){
       return @"Tablet";
    }
    else return @"Phone";
}

+ (void)loginSuccess:(NSString *)idnt operatorid:(NSString *)operatorId locationid:(NSString *)locationId
{
    [[Mixpanel sharedInstance] identify : idnt];
    //Session track
    
    [[Mixpanel sharedInstance]registerSuperProperties:@{@"AMS Id": idnt,
                                                        @"Operator ID": operatorId,
                                                        @"Location ID": locationId, @"Device Type": [self getDeviceType], @"Device Class": [self getDeviceClass]}];
    
    [self sessionStart:idnt];
    //Sign-in success
    [[Mixpanel sharedInstance] track:@"Sign In Success"
                          properties:@{@"Timestamp": [self getTimestamp]}];

    [[Mixpanel sharedInstance] flush];
    
}

+ (void)supportSectionViewed {
    [[Mixpanel sharedInstance] track:@"Support section viewed"
                          properties:@{@"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)sessionStart:(NSString *)idnt
{
    sessionId = [NSString stringWithFormat:@"%@%@",@"Session: ",idnt];
    [[Mixpanel sharedInstance] timeEvent:sessionId];
//    [[Mixpanel sharedInstance] timeEvent:@"App Close"];

    
}

+ (void)sessionEnd
{
    if(sessionId) {
        
        [[Mixpanel sharedInstance] track:sessionId properties:@{@"Timestamp": [self getTimestamp]}];
        sessionId = nil;
    }
    [[Mixpanel sharedInstance]clearSuperProperties];
}

+ (void)loginFailure:(NSString *)errorType witherrorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Sign In Fail"
                              properties:@{@"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp],@"Device Type": [self getDeviceType], @"Device Class": [self getDeviceClass]}];
        
    } else {
        [[Mixpanel sharedInstance] track:@"Sign In Fail"
                              properties:@{@"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp],@"Device Type": [self getDeviceType], @"Device Class": [self getDeviceClass]}];
    }
    [[Mixpanel sharedInstance] flush];
   
}

+ (void)profileSetupSuccess
{
    [[Mixpanel sharedInstance] track:@"Account Setup Success"
                          properties:@{@"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];

}

+ (void)discountSuccess
{
    [[Mixpanel sharedInstance] track:@"Discount Success"
                          properties:@{@"View Discounts": @"true", @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
    
}


+ (void)profileSetupFailure:(NSString *)errorType witherrorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Account Setup Fail"
                              properties:@{@"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp]}];
    } else {
        
        [[Mixpanel sharedInstance] track:@"Account Setup Fail"
                              properties:@{@"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp]}];
    }
    [[Mixpanel sharedInstance] flush];

}

+ (void)pinLoginSuccess:(NSString *)idnt operatorid:(NSString *)operatorId locationid:(NSString *)locationId
{
    [[Mixpanel sharedInstance] identify : idnt];
    [[Mixpanel sharedInstance]registerSuperProperties:@{@"AMS Id": idnt,
                                                        @"Operator ID": operatorId,
                                                        @"Location ID": locationId, @"Device Type": [self getDeviceType], @"Device Class": [self getDeviceClass]}];
    
    if (!sessionId) {
        [self sessionStart:idnt];
    }
    
    [[Mixpanel sharedInstance] track:@"Pin Login Success"
                          properties:@{@"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

//+ (void)pinLoginFailure:(NSString *)errorMessage
//{
//    [[Mixpanel sharedInstance] track:@"Pin login fail"
//                          properties:@{@"Error Message": errorMessage,
//                                       @"Timestamp": [self getTimestamp]}];
//    [[Mixpanel sharedInstance] flush];
//    
//}
+ (void)pinRetry:(NSString *)cnt
{
    [[Mixpanel sharedInstance] track:@"Pin Retry"
                          properties:@{@"Error Message": @"Pin Mismatch",
                                       @"Attempt": cnt,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)forgotPasswordSuccess
{
    [[Mixpanel sharedInstance] track:@"Forgot Password(Send Email) Success"
                          properties:@{@"Timestamp": [self getTimestamp],@"Device Type": [self getDeviceType], @"Device Class": [self getDeviceClass]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)forgotPasswordFailure:(NSString *)errorType witherrorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Forgot Password(Send Email) Fail"
                              properties:@{@"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp],@"Device Type": [self getDeviceType], @"Device Class": [self getDeviceClass]}];
    } else {
        [[Mixpanel sharedInstance] track:@"Forgot Password(Send Email) Fail"
                              properties:@{@"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp],@"Device Type": [self getDeviceType], @"Device Class": [self getDeviceClass]}];
    }
    [[Mixpanel sharedInstance] flush];

}

+ (void)signOutSuccess
{
    
    [[Mixpanel sharedInstance] track:@"Signout Success"
                          properties:@{@"Timestamp": [self getTimestamp]}];
    
    [self sessionEnd];
    [[Mixpanel sharedInstance] flush];
    
}

+ (void)notRegisteredDisplayed
{
    
    [[Mixpanel sharedInstance] track:@"Not registered page"
                          properties:@{@"Timestamp": [self getTimestamp]}];
    
    [self sessionEnd];
    [[Mixpanel sharedInstance] flush];
    
}

+ (void)pageView:(NSString *)pageName
{
    [[Mixpanel sharedInstance] track:@"Page View"
                          properties:@{@"Page Name": pageName,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}


//Support->Feedback
+ (void)submitFeedbackSuccess:(NSString *)feedbackCategory
{
    [[Mixpanel sharedInstance] track:@"Submit Feedback Success"
                          properties:@{@"Category Type": feedbackCategory,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)submitFeedbackFailure:(NSString *)feedbackCategory errortype:(NSString *)errorType witherrorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Submit Feedback Fail"
                              properties:@{/*@"Category Type": feedbackCategory,*/
                                           @"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp]}];
    } else {
        [[Mixpanel sharedInstance] track:@"Submit Feedback Fail"
                              properties:@{/*@"Category Type": feedbackCategory,*/
                                           @"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp]}];
    }
    [[Mixpanel sharedInstance] flush];
}

//Support->article (did you see/using the market/using the app)
+ (void)articleSuccess:(NSString *)section category:(NSString *)category
{
    [[Mixpanel sharedInstance] track:@"Article Success"
                          properties:@{@"Section": section,
                                       @"Issue Category": category,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)aerticleFailure:(NSString *)section category:(NSString *)category anderrortype:(NSString *)errorType errorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Article Fail"
                              properties:@{@"Section": section,
                                           @"Issue Category": category,
                                           @"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp]}];
    } else {
        [[Mixpanel sharedInstance] track:@"Article Fail"
                              properties:@{@"Section": section,
                                           @"Issue Category": category,
                                           @"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp]}];
    }
    [[Mixpanel sharedInstance] flush];
    
}

//Case creation (ContactUs)
+ (void)caseSuccess:(NSString *)category andissuetype:(NSString *)issueType
{
    [[Mixpanel sharedInstance] track:@"ContactUs Case Register Success"
                          properties:@{@"Category Type": category,
                                       @"Issue Type": issueType,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)caseFailure:(NSString *)category andissuetype:(NSString *)issueType anderrortype:(NSString *)errorType errorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"ContactUs Case Register Fail"
                              properties:@{/*@"Category Type": category,
                                           @"Issue Type": issueType,*/
                                           @"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp]}];
    } else {
        [[Mixpanel sharedInstance] track:@"Case Register Fail"
                              properties:@{/*@"Category Type": category,
                                           @"Issue Type": issueType,*/
                                           @"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp]}];
    }
    [[Mixpanel sharedInstance] flush];
}

//Support->ContactUs(DidUSee article details)
//Support->Helpful howto's-> Usin the market/using the app(article details)
+ (void)articleDetailsSuccess:(NSString *)section withArticleid:(NSString *)articleId articlename:(NSString *)articleName
{
    [[Mixpanel sharedInstance] track:@"Article Details Success"
                          properties:@{@"Section": section,
                                       @"Id": articleId,
                                       @"Name": articleName,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)articleDetailsFailure:(NSString *)section withArticleid:(NSString *)articleId articlename:(NSString *)articleName errortype:(NSString *)errorType errorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Article Details Fail"
                              properties:@{@"Section": section,
                                           @"Id": articleId,
                                           @"Name": articleName,
                                           @"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp]}];
    } else {
        [[Mixpanel sharedInstance] track:@"Article Details Fail"
                              properties:@{@"Section": section,
                                           @"Id": articleId,
                                           @"Name": articleName,
                                           @"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp]}];
    }
    [[Mixpanel sharedInstance] flush];
}

+ (void)searchSuccess:(NSString *)section searchterm:(NSString *)searchTerm
{
    [[Mixpanel sharedInstance] track:@"Article Search Success"
                          properties:@{@"Section": section,
                                       @"Search Term": searchTerm,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}

+ (void)searchFailure:(NSString *)section searchterm:(NSString *)searchTerm errortype:(NSString *)errorType errorcode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Article Search Fail"
                              properties:@{/*@"Section": section,
                                           @"Search Term": searchTerm,*/
                                           @"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp]}];
    } else {
        [[Mixpanel sharedInstance] track:@"Article Search Fail"
                              properties:@{/*@"Section": section,
                                           @"Search Term": searchTerm,*/
                                           @"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp]}];
    }
    [[Mixpanel sharedInstance] flush];
}

//Reload
+ (void)reloadSuccess:(NSString *)reloadType amount:(NSString *)amount
{
    [[Mixpanel sharedInstance] track:@"Reload Success"
                          properties:@{@"Reload Type": reloadType,
                                       @"Reload Amount": amount,
                                       @"Timestamp": [self getTimestamp]}];
    [[Mixpanel sharedInstance] flush];
}
+ (void)reloadFailure:(NSString *)reloadType amount:(NSString *)amount errortype:(NSString *)errorType witherrorCode:(NSString *)errorCode
{
    if (errorCode) {
        [[Mixpanel sharedInstance] track:@"Reload Fail"
                              properties:@{/*@"Reload Type": reloadType,
                                           @"Reload Amount": amount,*/
                                           @"Error Type": errorType,
                                           @"Error Code": errorCode,
                                           @"Timestamp": [self getTimestamp]}];
    } else {
        [[Mixpanel sharedInstance] track:@"Reload Fail"
                              properties:@{/*@"Reload Type": reloadType,
                                           @"Amount": amount,*/
                                           @"Error Type": errorType,
                                           @"Timestamp": [self getTimestamp]}];
    }
    [[Mixpanel sharedInstance] flush];
}



@end

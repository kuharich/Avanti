//
//  LoginViewController.m
//  AvantiMarkets
//
//  Created by Deepak Sahu on 16/03/15.
//  Copyright (c) 2015 BYNDL. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AvantiCommon.h"
#import "FirstLoginProfileViewController.h"
#import <RestKit/RestKit.h>
#import "ForgotPasswordViewController.h"
#import "AAMixpanel.h"
#import "LGAlertView.h"
#import "SignUpViewController.h"



@interface LoginViewController ()
{
    AuthenticateResponse *authResponse;
    AuthenticateRequest *authRequest;
    NSString *emailid;
}

-(void) addEmailIcon;
-(void) addPasswordIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewbackground;
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundAlpha;

@property (weak, nonatomic) IBOutlet UILabel *lblWelcomeTExt;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnTermConditions;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@property (weak, nonatomic) IBOutlet UITextField *txtEmailUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UILabel *poweredByLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnNotRegistered;

@property (weak, nonatomic) IBOutlet UIView *separatorLine1;
@property (weak, nonatomic) IBOutlet UIView *separatorLine2;
- (IBAction)switchToFirstLoginView:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *termsAndConditionsText;

#pragma UIActions
- (IBAction)tapOnTermConditions:(id)sender;
- (IBAction)tapOnLogin:(id)sender;
- (IBAction)tapOnCancel:(id)sender;
- (IBAction)tapOnForgotPassword:(id)sender;
- (IBAction)tapOnSignUp:(id)sender;
@end

@implementation LoginViewController

@synthesize lblWelcomeTExt;
@synthesize lblSubTitle;
@synthesize poweredByLabel;
@synthesize btnForgotPassword;
@synthesize btnNotRegistered;
@synthesize imgViewbackground;


- (void)viewDidLoad{
    [AAMixpanel appInstalled];
    formattedButtonText(self.btnTermConditions, @"I agree with the ", @"Terms of Service", @".");
    
    formattedButtonText(self.btnSignUp, @"Or", @" Register and Sign Up", @"");
    formatButtonWithoutBorder(self.btnLogin, DEFAULT_COLOR_THEME_WHITE, DEFAULT_COLOR_THEME_GREEN, NO);
    
    [self.txtEmailUserID setFont:[UIFont fontWithName:[self quicksandFontName] size:self.txtEmailUserID.font.pointSize]];
    [self.txtPassword setFont:[UIFont fontWithName:[self quicksandFontName] size:self.txtPassword.font.pointSize]];

    [self setPlaceholderColor:self.txtEmailUserID text:@"EMAIL"];
    [self setPlaceholderColor:self.txtPassword text:@"PASSWORD"];
    
    
    [self.btnLogin.layer setCornerRadius:4.0f];
    self.btnLogin.clipsToBounds = YES;
    
    [self setCustomBackgroundImage: self.imgViewbackground];
    [self setCustomLabelText: self.lblWelcomeTExt key:@"welcomeText"];
    [self setCustomLabelColor: self.lblWelcomeTExt];
    [self setCustomLabelColor: self.lblSubTitle];
    [self setCustomLabelColor: poweredByLabel];
    [self setCustomTextFieldColor:self.txtEmailUserID];
    [self setCustomTextFieldColor:self.txtPassword];
    
    [self setCustomRegularButtonTextColor: btnForgotPassword];
    [self setCustomRegularButtonTextColor: btnNotRegistered];
    [self setCustomViewColor: self.separatorLine1];
    [self setCustomViewColor: self.separatorLine2];
    [self setCustomPlaceholderColor:self.txtEmailUserID text:@"EMAIL"];
    [self setCustomPlaceholderColor:self.txtPassword text:@"PASSWORD"];

    [self setCustomLoginButtonBackgroundColor: self.btnLogin];
    [self setCustomRegularButtonTextColor: self.btnLogin];
    [super viewDidLoad];
    
}



#pragma Touch handle for UI
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.txtEmailUserID resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.view becomeFirstResponder];
    [self.view setFrame:[UIScreen mainScreen].bounds];
}

#pragma UITextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,3}$" options:0 error:nil];
    //    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    
    
    if (textField == self.txtEmailUserID) {
        
        return updateString.length <= CHARACTER_LIMIT_EMAIL;
    }
    else if (textField == self.txtPassword) {
        return updateString.length <= CHARACTER_LIMIT_PASSWORD;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtEmailUserID) {
        [self.txtPassword becomeFirstResponder];
    }
    else{
        [self.txtPassword resignFirstResponder];
        // go for login code
    }
    return YES;
}

- (IBAction)switchToFirstLoginView:(id)sender {
    FirstLoginProfileViewController *first = [[FirstLoginProfileViewController alloc] initWithNibName:@"FirstLoginProfileViewController" bundle:nil];
    [self.navigationController pushViewController:first animated:YES];
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
}

#pragma UIActions
- (IBAction)tapOnTermConditions:(id)sender {
    [self.btnTermConditions setSelected:!self.btnTermConditions.isSelected];
    //TODO:: save this for next use of open term and conditions popup for agreement
    
}
- (void)autoDismissAlertContoller:(UIAlertController *)alert{
    if (alert) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)tapOnLogin:(id)sender
{

    
    @try{
        //TODO:: send API call to server for validation and remove hard code app launch
        [self.txtEmailUserID resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        
        if ([self.txtEmailUserID.text length] > 0 && self.txtPassword.text.length > 0)
        {
            if (!validateEmail(self.txtEmailUserID.text)) {
                displayAlert(nil, @"Please enter valid email id.", nil, @"OK");
                return;
            }
            
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
            hud.labelText = @"Signing in..."    ;
            if (AVANTI_SERVER_API_RUN) {
                [AMUtilities saveUsernameAndPassword:@"" password:@""];
                authRequest = [[AuthenticateRequest alloc] init];
                authRequest.userName = self.txtEmailUserID.text ? self.txtEmailUserID.text : @"";
                authRequest.userPassword = self.txtPassword.text ? self.txtPassword.text : @"";
                
                // Request
                RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
                [requestMapping addAttributeMappingsFromArray:@[@"userName", @"userPassword"]];
                RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                               objectClass:[AuthenticateRequest class]
                                                                                               rootKeyPath:nil
                                                                                                    method:RKRequestMethodAny];
                
                // Response
                RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[AuthenticateResponse class]];
                [authMapping addAttributeMappingsFromDictionary:@{
                                                                  @"phoneNumber" : @"phoneNumber",
                                                                  @"requestPIN" : @"requestPIN",
                                                                  @"firstName" : @"firstName",
                                                                  @"lastName" : @"lastName" ,
                                                                  @"requestPhoneNumber" : @"requestPhoneNumber" ,
                                                                  @"pin" : @"pin" ,
                                                                  @"email" : @"email" ,
                                                                  @"ams_id" : @"amsId" ,
                                                                  @"operatorId" : @"operatorId" ,
                                                                  @"locationId" : @"locationId" ,
                                                                  }];
                
                RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                                        method:RKRequestMethodAny
                                                                                                   pathPattern:nil keyPath:nil
                                                                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
                // RESTManager
                [RKObjectManager setSharedManager:nil];
                RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
                [manager.HTTPClient setAuthorizationHeaderWithUsername:authRequest.userName password:authRequest.userPassword];
                
                [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
                [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
                
                [manager addRequestDescriptor:requestDescriptor];
                [manager addResponseDescriptor:responseDescriptor];
                
                //        [manager postObject:authRequest path:kServerAPIAuthenticate parameters:nil
                [manager getObject:nil path:kPathAuthenticate
                        parameters:@{@"userName": @"", @"userPassword": @""}
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               
                               authResponse = [mappingResult firstObject];
                               if (authResponse) {
                                   //Mixpanel Login success
                                   emailid = self.txtEmailUserID.text;
                                   //                               [AAMixpanel loginSuccess:authResponse.ams_id];
                                   [AAMixpanel loginSuccess:authResponse.amsId operatorid:authResponse.operatorId locationid:authResponse.locationId];
                                   if (authResponse.phoneNumber==nil)
                                   {
                                       authResponse.phoneNumber=@"";
                                   }
                                   [[NSUserDefaults standardUserDefaults] setObject:[authResponse data] forKey:NSStringFromClass([AuthenticateResponse class])];
                                   
                                   
                                   [AMUtilities saveUsernameAndPassword:authRequest.userName password:authRequest.userPassword];
                                   
                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                   if ([[NSUserDefaults standardUserDefaults]boolForKey:emailid] == NO)
                                   {
                                       [self checkForTerms];
                                   }
                                   else
                                   {
                                       [self navigateToMainOrProfileView];
                                   }
                                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                               }
                               else{
                                   displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                               }
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                               //failure
                               if (operation.HTTPRequestOperation.response.statusCode == 401) {
                                   //Mixpanel auth fail
                                   [AAMixpanel loginFailure:@"Unauthorized" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                                   
                                   
                                   displayAlertWithTitleMessage(LOGIN_ERROR_ALERT_TITLE, LOGIN_ERROR_ALERT_MESSAGE);
                               }
                               else                       if(!operation.HTTPRequestOperation.response.statusCode )
                               {
                                   
                                   //Mixpanel auth fail
                                   [AAMixpanel loginFailure:@"Network Error" witherrorCode:nil];
                                   displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                               }
                               else{
                                   //Mixpanel auth fail
                                   [AAMixpanel loginFailure:@"Server Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                                   displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                               }
                           }];
            }
            else{
                AuthenticateRequest *authRequest1 = [[AuthenticateRequest alloc] init];
                authRequest1.userName = self.txtEmailUserID.text;
                authRequest1.userPassword = self.txtPassword.text;
                [[NSUserDefaults standardUserDefaults] setObject:[authRequest1 data] forKey:NSStringFromClass([AuthenticateRequest class])];
                
                AuthenticateResponse *authResponse1 = [[AuthenticateResponse alloc] init];
                authResponse1.firstName = @"Jimmy";
                authResponse1.lastName = @"Wales";
                authResponse1.requestPhoneNumber = false;
                authResponse1.requestPIN = true;
                [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                
                [[NSUserDefaults standardUserDefaults] setObject:[authResponse1 data] forKey:NSStringFromClass([AuthenticateResponse class])];
                [self performSelector:@selector(switchToFirstLoginView:) withObject:sender afterDelay:0.5f];
            }
        }
        else{
            displayAlert(nil, @"Please enter user credentials.", nil, nil);
        }
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"Exception In tapOnLogin:%@",exception.reason);
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    [[AppDelegate sharedDelegate] launchAvantiMarkets];
}

- (IBAction)tapOnCancel:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"This will be exit from the app, Are you sure to continue?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //abort();
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action){
                                                       
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)tapOnForgotPassword:(id)sender{
    //TODO:: tap forgot page
    ForgotPasswordViewController *fpView = [[ForgotPasswordViewController alloc] initWithNibName:[XibHelper XibFileName:@"ForgotPasswordViewController"] bundle:nil];
    [self.navigationController pushViewController:fpView animated:YES];
}

- (IBAction)tapOnSignUp:(id)sender {
    SignUpViewController *fpView = [[SignUpViewController alloc] initWithNibName:[XibHelper XibFileName:@"SignUpViewController"] bundle:nil];
    [self.navigationController pushViewController:fpView animated:YES];
}



-(void) addEmailIcon {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"email-icon.png"]];
    [self.txtEmailUserID addSubview:imgView];
}

-(void) addPasswordIcon {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"password-icon.png"]];
    [self.txtPassword addSubview:imgView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.txtEmailUserID.text = @"";
    self.txtPassword.text = @"";
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    [self.txtEmailUserID becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkForTerms
{
    NSURL *path = [[NSBundle mainBundle] URLForResource: @"TermsAndConditions" withExtension:@"rtf"];
    NSAttributedString *rtfString = [[NSAttributedString alloc]   initWithFileURL:path options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    
    self.termsAndConditionsText.attributedText = rtfString;
    LGAlertView *alert = [[LGAlertView alloc]initWithViewStyleWithTitle:@"BYNDL AMC, LLC Terms of Service" message:nil view:self.view1 buttonTitles:@[@"Accept",@"Cancel"] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index)
                          {
                              
                              
                              if (index ==0)//Accept
                              {
                                  [[NSUserDefaults standardUserDefaults]setBool:YES forKey:emailid];
                                  [self navigateToMainOrProfileView];
                                  
                              }
                              if (index ==1)
                              {
                                  [self checkCancelPopup];
                              }
                              
                          }
                                                          cancelHandler:nil destructiveHandler:nil];
    //    if (IS_IPHONE_4) {
    //        alert.heightMax = 470;
    //    }
    [alert setColorful:YES];
    
    [alert showAnimated:YES completionHandler:nil];
    alert.cancelOnTouch = NO;
    
}
-(void)checkCancelPopup
{
    
    LGAlertView *alertVw=    [[LGAlertView alloc] initWithViewStyleWithTitle:nil
                                                                     message:@"You are required to accept Terms of Service. Do you wish to continue?"
                                                                        view:nil
                                                                buttonTitles:@[@"Accept",@"Cancel"]
                                                           cancelButtonTitle:nil
                                                      destructiveButtonTitle:nil
                                                               actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index)
                              {
                                  
                                  
                                  if (index ==0)
                                  {
                                      [self checkForTerms];
                                      
                                  }
                                  if (index ==1)
                                  {
                                      
                                  }
                                  
                              }
                              
                                                               cancelHandler:nil
                                                          destructiveHandler:nil];
    alertVw.cancelOnTouch = NO;
    [alertVw showAnimated:YES completionHandler:nil];
    
}
-(void)navigateToMainOrProfileView
{
    if (!authResponse.requestPIN) {
        [[NSUserDefaults standardUserDefaults] setObject:[authResponse data] forKey:NSStringFromClass([AuthenticateResponse class])];
        
        if ([authResponse.pin length]==4)
        {
            [[AMUtilities sharedUtilities] storePassword:authRequest.userPassword pin:authResponse.pin];
            
        }
        else
            [[AMUtilities sharedUtilities] storePassword:authRequest.userPassword hexapin:authResponse.pin];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
        
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
        
        
        [[AppDelegate sharedDelegate] launchAvantiMarkets];
    } else {
        NSLog(@" No PIN xxxxxx");
        [self switchToFirstLoginView:@"sd"];
    }
    
    
}
@end

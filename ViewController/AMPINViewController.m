//
//  AMPINViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 25/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMPINViewController.h"
#import "AppDelegate.h"
#import "AvantiCommon.h"
#import "ChangePinViewController.h"
#import "AAMixpanel.h"


@interface AMPINViewController ()
{
    NSString *stringPIN;
    AppDelegate *appdelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *btnForgetPin;

@property (weak, nonatomic) IBOutlet UILabel *lblEnterPin;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin1;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin2;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin3;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin4;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enjoyLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterpinLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@property (weak, nonatomic) IBOutlet UILabel *poweredByLabel;


- (IBAction)tapOnForgetPin:(id)sender;

@end

@implementation AMPINViewController


@synthesize backgroundImage;
@synthesize welcomeLabel;
@synthesize enjoyLabel;
@synthesize separatorLine;
@synthesize lblEnterPin;
@synthesize btnForgetPin;
@synthesize poweredByLabel;

- (void)resetUI {
    for (UIView *v in self.view.subviews) {
        for (UIView *sview in v.subviews) {
            [sview resignFirstResponder];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resetUI];
}


- (void)viewDidLoad {
    
    appdelegate=  (AppDelegate *) [UIApplication sharedApplication].delegate;
    appdelegate .retryCnt=0;

    addBorderInTextField(self.txtEnterPin1);
    addBorderInTextField(self.txtEnterPin2);
    addBorderInTextField(self.txtEnterPin3);
    addBorderInTextField(self.txtEnterPin4);
    [super viewDidLoad];
    //[self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemNone];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    appdelegate=  (AppDelegate *) [UIApplication sharedApplication].delegate;
    // appdelegate .retryCnt=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    self.txtEnterPin1.text = @"";
    self.txtEnterPin2.text = @"";
    self.txtEnterPin3.text = @"";
    self.txtEnterPin4.text = @"";
    //	self.txtEnterPin.text = @"";
    
    if (![[AMUtilities sharedUtilities] isVideoPlaying]) {
        [self.txtEnterPin1 becomeFirstResponder];
    }
    [self setCustomBackgroundImage: self.backgroundImage];
    [self setCustomViewColor: self.backgroundImage];
    [self setCustomLabelColor: self.welcomeLabel];
    [self setCustomLabelText: self.welcomeLabel key:@"welcomeText"];
    [self setCustomLabelColor: self.enjoyLabel];
    [self setCustomLabelColor: self.lblEnterPin];
    [self setCustomLabelColor: self.poweredByLabel];
    [self setCustomRegularButtonTextColor: self.btnForgetPin];
    [self setCustomViewColor: self.separatorLine];
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)textDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    
    if (textField == self.txtEnterPin1 && textField.text.length == 1) {
        [self.txtEnterPin2 becomeFirstResponder];
    }
    else if (textField == self.txtEnterPin2 && textField.text.length == 1) {
        [self.txtEnterPin3 becomeFirstResponder];
    }
    else if (textField == self.txtEnterPin3 && textField.text.length == 1) {
        [self.txtEnterPin4 becomeFirstResponder];
    }
    else if (textField == self.txtEnterPin4 && textField.text.length == 1) {
        [self.txtEnterPin4 resignFirstResponder];
        
        stringPIN = [NSString stringWithFormat:@"%@%@%@%@", self.txtEnterPin1.text, self.txtEnterPin2.text, self.txtEnterPin3.text, self.txtEnterPin4.text];
        
        AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
        
        if (appdelegate.retryCnt > 0) {
            //Mixpanel
            [AAMixpanel pinRetry:[@(appdelegate.retryCnt) stringValue]];
        }
        if ([[AMUtilities sharedUtilities] isValidPIN:stringPIN])
        {
            if ([AMUtilities sharedUtilities].isInternetWorking)
            {
                __block MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
                hud.labelText = @"Signing in...";
                [self  checkSignin:^(id obj)
                 {
                     [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                     if ([obj isKindOfClass:[AuthenticateResponse class]]  )
                     {
                         AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

                         if (app.localNoti==nil)
                         {
                             app.localNoti = [[UILocalNotification alloc] init];
                             app.localNoti.fireDate = [NSDate date];
                             app.localNoti.repeatInterval = NSCalendarUnitMinute;
                             app.localNoti.timeZone = [NSTimeZone defaultTimeZone];
                             [[UIApplication sharedApplication] scheduleLocalNotification:app.localNoti];
                         }
                         [AAMixpanel pinLoginSuccess:authResp.amsId operatorid:authResp.operatorId locationid:authResp.locationId];
                         [MBProgressHUD hideHUDForView:[[AppDelegate sharedDelegate] window] animated:YES];
                         
                         
                         if (self.comingFromBackground) {
                             [self dismissViewControllerAnimated:YES completion: ^{
                                 self.comingFromBackground = NO;
                                 
                             }];
                         }
                         else {
                             hud =  [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
                             hud.labelText = @"Signing in..."    ;
                             
                             [[AppDelegate sharedDelegate] performSelector:@selector(launchAvantiMarkets) withObject:nil afterDelay:0.5f];
                         }

                         [[AppDelegate sharedDelegate] setAvantAppDisplayed:YES];
                         
                     }
                     else if([obj isKindOfClass:[WSLAlertViewAutoDismiss  class]])
                     {
                         WSLAlertViewAutoDismiss *alertView = obj;
                         appdelegate.retryCnt++;
                         if (appdelegate.retryCnt ==3)
                         {
                             [self showAlertForLoginOrPinChange];
                             appdelegate.retryCnt = 0;
                             
                             return ;
                         }
                         [alertView show];
                         
                         
                     }
                     else{
                         appdelegate.retryCnt++;
                         if (appdelegate.retryCnt ==3)
                         {
                             [self showAlertForLoginOrPinChange];
                             appdelegate.retryCnt = 0;
                             
                             return ;
                         }
                         self.txtEnterPin1.text = @"";
                         self.txtEnterPin2.text = @"";
                         self.txtEnterPin3.text = @"";
                         self.txtEnterPin4.text = @"";
                         UIAlertView *alertView = displayAlert(@"Login Failure", @"Please check your PIN and try again", self, @"OK");
                         alertView.tag = UIAlertViewTagIncorrectPin;
                         [self.txtEnterPin1 becomeFirstResponder];
                     }
                 }];
                
            }
            else
            {
                appdelegate.retryCnt++;
                if (appdelegate.retryCnt ==3)
                {
                    [self showAlertForLoginOrPinChange];
                    appdelegate.retryCnt = 0;
                    
                    return ;
                }
                self.txtEnterPin1.text = @"";
                self.txtEnterPin2.text = @"";
                self.txtEnterPin3.text = @"";
                self.txtEnterPin4.text = @"";
                UIAlertView *alertView = displayAlert(NETWORK_ERROR_ALERT_TITLE,NETWORK_ERROR_ALERT_MESSAGE, self, @"OK");
                alertView.tag = UIAlertViewTagIncorrectPin;
                [self.txtEnterPin1 becomeFirstResponder];
                
            }
        }
        else {
            appdelegate.retryCnt++;
            if (appdelegate.retryCnt ==3)
            {
                [self showAlertForLoginOrPinChange];
                appdelegate.retryCnt = 0;
                
                return ;
            }
            self.txtEnterPin1.text = @"";
            self.txtEnterPin2.text = @"";
            self.txtEnterPin3.text = @"";
            self.txtEnterPin4.text = @"";
            UIAlertView *alertView = displayAlert(@"Login Failure", @"Please check your PIN and try again", self, @"OK");
            alertView.tag = UIAlertViewTagIncorrectPin;
            [self.txtEnterPin1 becomeFirstResponder];
            
        }
        
        
        
        
    }
    //For delete PIN
    else if (textField == self.txtEnterPin4 && textField.text.length == 0) {
        [self.txtEnterPin3 becomeFirstResponder];
    }
    else if (textField == self.txtEnterPin3 && textField.text.length == 0) {
        [self.txtEnterPin2 becomeFirstResponder];
    }
    else if (textField == self.txtEnterPin2 && textField.text.length == 0) {
        [self.txtEnterPin1 becomeFirstResponder];
    }
}
-(void)checkCOntactsUS
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //	if (self.txtEnterPin == textField) {
    //		return updateString.length <= 4;
    //	}
    return updateString.length <= 1;
}

- (IBAction)tapOnForgetPin:(id)sender {
    ChangePinViewController *changePin = [[ChangePinViewController alloc] initWithNibName:[XibHelper XibFileName:@"ChangePinViewController"] bundle:nil];
    changePin.comingFromBackground = self.comingFromBackground;
    [self.navigationController pushViewController:changePin animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.view endEditing:YES];
    if (alertView.tag == UIAlertViewTagIncorrectPin) {
        [self.txtEnterPin1 becomeFirstResponder];
    }
    if (alertView.tag == 121)
    {
        if (buttonIndex==0)//logout
            
        {
            [self forceLogout];
        }
    }
    if (alertView.tag == 122)
    {
        [self forceLogout];
    }
    if (alertView.tag == 124)
    {
        if (buttonIndex==0)
        {
            [self.txtEnterPin1 endEditing:YES];
            //[self forceLogout];
            [self tapOnForgetPin:nil];
        }
        if (buttonIndex==1)
        {
            [self tapOnForgetPin:nil];
        }
    }
    if ([self.txtEnterPin1 isFirstResponder])
    {
        [self.txtEnterPin1 resignFirstResponder];
    }
}
-(void)showAlertForLoginOrPinChange
{
    self.txtEnterPin1.text = @"";
    self.txtEnterPin2.text = @"";
    self.txtEnterPin3.text = @"";
    self.txtEnterPin4.text = @"";
    WSLAlertViewAutoDismiss *alertView = [[WSLAlertViewAutoDismiss alloc] initWithTitle:nil
                                                                                message:@"It seems you have changed/forgot your pin!"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"Reset PIN"
                                                                      otherButtonTitles:nil, nil];
    [self.txtEnterPin1 becomeFirstResponder];
    
    alertView.tag = 124;
    [alertView show];
    
}
-(void)forceLogout
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.view endEditing:YES];
    [self.txtEnterPin1 resignFirstResponder];
    [self.txtEnterPin2 resignFirstResponder];
    [self.txtEnterPin3 resignFirstResponder];
    [self.txtEnterPin4 resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_StoredEncryptedPass];
    [[AppDelegate sharedDelegate] performSelector:@selector(launchLoginScreen) withObject:nil afterDelay:0.1];
}


-(void)checkSignin:(void (^)(id))block
{
    
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
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    
    NSLog(@"Request for pin :%@",[NSDate date]);
    
    [manager getObject:nil path:kPathAuthenticate parameters:@{@"userName": @"", @"userPassword": @""} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     
     {
         
         
         AuthenticateResponse *authResponse = [mappingResult firstObject];
         if (authResponse.phoneNumber==nil)
         {
             authResponse.phoneNumber=@"";
         }
         NSLog(@"Response  auth for pin :%@",[NSDate date]);
         
         [[NSUserDefaults standardUserDefaults] setObject:[authResponse data] forKey:NSStringFromClass([AuthenticateResponse class])];
         [[NSUserDefaults standardUserDefaults]synchronize];
         NSString *localPinHash= [[AMUtilities sharedUtilities] generateKeyForPIN:stringPIN withIteration:189];
         localPinHash = [[AMUtilities sharedUtilities] generateKeyForPIN:localPinHash withIteration:32] ;;
         NSString *serverPinHash;
         if (authResponse.pin)
         {
             if (authResponse.pin.length ==4)
             {
                 
                 serverPinHash =[[AMUtilities sharedUtilities] generateKeyForPIN:authResponse.pin withIteration:189];
                 serverPinHash = [[AMUtilities sharedUtilities] generateKeyForPIN:serverPinHash withIteration:32];
                 
             }
             else
             {
                 serverPinHash = [[AMUtilities sharedUtilities] generateKeyForPIN:authResponse.pin withIteration:32];;
                 
                 
             }
             if ([localPinHash isEqualToString:serverPinHash])
             {
                 if (authResponse.pin.length ==4)
                 {
                     [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] pin:authResponse.pin];
                     
                 }
                 else
                     [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] hexapin:authResponse.pin];
                 NSLog(@"After   auth local  data :%@",[NSDate date]);
                 
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 block(authResponse);
                 
                 
             }
             else
             {
                 self.txtEnterPin1.text = @"";
                 self.txtEnterPin2.text = @"";
                 self.txtEnterPin3.text = @"";
                 self.txtEnterPin4.text = @"";
                 WSLAlertViewAutoDismiss *alertView = [[WSLAlertViewAutoDismiss alloc] initWithTitle:LOGIN_ERROR_ALERT_TITLE
                                                                                             message:@"It seems you have changed your pin! Please re-login."
                                                                                            delegate:self
                                                                                   cancelButtonTitle:@"Ok"
                                                                                   otherButtonTitles: nil];
                 
                 alertView.tag = 122;
                 [self.txtEnterPin1 becomeFirstResponder];
                 
                 block(alertView);
             }
             
         }
         else
         {
             block(nil);
         }
         
     }
               failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
         //failure
         if (operation.HTTPRequestOperation.response.statusCode == 401) {
             //Mixpanel auth fail
             self.txtEnterPin1.text = @"";
             self.txtEnterPin2.text = @"";
             self.txtEnterPin3.text = @"";
             self.txtEnterPin4.text = @"";
             // return false;
             WSLAlertViewAutoDismiss *alertView = [[WSLAlertViewAutoDismiss alloc] initWithTitle:LOGIN_ERROR_ALERT_TITLE
                                                                                         message:@"It seems you have changed your password! Please re-login."
                                                                                        delegate:self
                                                                               cancelButtonTitle:@"Ok"
                                                                               otherButtonTitles: @"Cancel",nil];
             
             alertView.tag = 121;
             [alertView show];
             [self.txtEnterPin1 becomeFirstResponder];
             
             block(alertView);
             
             
         }
         else if ([AMUtilities sharedUtilities].isInternetWorking == NO) {
             //Mixpanel auth fail
             //[AAMixpanel loginFailure:@"Network Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
             // return false;
             
             displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
             block(nil);
             
         }
         else{
             //Mixpanel auth fail
             // [AAMixpanel loginFailure:@"Server Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
             // return false;
             
             // displayAlertWithTitleMessage(@"sdfdfsdsfsddsf", SERVER_ERROR_ALERT_MESSAGE);
             block(nil);
             
         }
         
     }];
}


@end

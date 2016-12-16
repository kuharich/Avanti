//
//  FirstLoginProfileViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 24/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "FirstLoginProfileViewController.h"
#import "AppDelegate.h"
#import "UserPin.h"
#import "UpdateProfileRequest.h"
#import "UpdateProfileResponse.h"
#import "AAMixpanel.h"
#import "LGAlertView.h"
@interface FirstLoginProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblHorizontalSaperator;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtContactEmailId;

@property (weak, nonatomic) IBOutlet UIButton *btnResetPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;

@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin;

@property (weak, nonatomic) IBOutlet UILabel *lblEnterPin;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin1;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin2;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin3;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin4;


@property (weak, nonatomic) IBOutlet UILabel *lblReenterPin;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin1;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin2;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin3;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin4;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)tapOnSave:(id)sender;
- (IBAction)tapOnCancel:(id)sender;
- (IBAction)tapOnResetPassword:(id)sender;

@end

@implementation FirstLoginProfileViewController

- (void)resetUI {
	for (UIView *v in self.view.subviews) {
		for (UIView *sview in v.subviews) {
			[sview resignFirstResponder];
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self resetUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    // TODO: tero doesn't understand this
    AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
      AuthenticateRequest *authReq = [AuthenticateRequest authenticateResuestWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateRequest class])]];
    if (authResp) {
        self.txtFirstName.text = authResp.firstName;
        self.txtLastName.text = authResp.lastName;
        self.txtContactEmailId.text = authResp.email;
        self.txtPhone.text = [self getFormatedPhoneNumber:authResp.phoneNumber];
        
        [self orangeGradient];
        [self.navigationController.navigationBar setHidden: NO];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
           NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
        [self setTitle:@"ACCOUNT HISTORY"]; // ???
        [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        self.txtEmailId.text = authReq.emailId;
        
        [self viewBecomeFirstResponder];
    }
    if (authResp.requestPIN==false)
    {
        [self.pinView removeFromSuperview];
        [self.view4Pin removeFromSuperview];
      
    }
   

    
  
    self.txtEmailId.text = authReq.emailId;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [super viewWillAppear:animated];
}

- (NSString *) getFormatedPhoneNumber:(NSString *) phoneNumber
{
    if (phoneNumber.length<10)
    {
        return phoneNumber;
    }
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"()- "];
    NSArray *arrayOfComponents = [phoneNumber componentsSeparatedByCharactersInSet:characterSet];
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    
    NSUInteger length = strOutput.length;
    BOOL hasLeadingOne = length > 0 && [strOutput characterAtIndex:0] == '1';
    NSString *strNewOutput = nil;
     NSString *strOne = nil;
    NSString *strPhoneNo = nil;
    
    if (hasLeadingOne) {
        strNewOutput = [strOutput substringFromIndex:(1)];
        strOne = @"1 ";
    } else {
        strNewOutput = strOutput;
    }
    
    if(strNewOutput.length >10){
        NSMutableString *data = [NSMutableString stringWithString:strNewOutput];
        [data substringFromIndex:1];
        self.txtPhone.text = data;
    } else if(strOutput.length == 10){
        self.txtPhone.text = strOutput;
    } else {
        self.txtPhone.text = @"";
    }
    
    if(strNewOutput.length > 0) {
        NSRange range;
        range.length = 3;
        range.location = 3;
        
        if (hasLeadingOne) {
            strPhoneNo = [NSString stringWithFormat:@"%@%@", strOne, [NSString stringWithFormat:@"(%@)%@-%@", [strNewOutput substringToIndex:3], [strNewOutput substringWithRange:range], [strNewOutput substringFromIndex:6]]];
        } else {
             strPhoneNo = self.txtPhone.text = [NSString stringWithFormat:@"(%@)%@-%@", [strNewOutput substringToIndex:3], [strNewOutput substringWithRange:range], [strNewOutput substringFromIndex:6]];
        }
        
    }

    return strPhoneNo;
}



- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
	addBorderInTextField(self.txtEnterPin1);
	addBorderInTextField(self.txtEnterPin2);
	addBorderInTextField(self.txtEnterPin3);
	addBorderInTextField(self.txtEnterPin4);

	addBorderInTextField(self.txtReenterPin1);
	addBorderInTextField(self.txtReenterPin2);
	addBorderInTextField(self.txtReenterPin3);
	addBorderInTextField(self.txtReenterPin4);
    
//    [self.txtPhone becomeFirstResponder];

	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewBecomeFirstResponder {
    if (self.txtFirstName.text.length == 0) {
        [self.txtFirstName becomeFirstResponder];
    } else if (self.txtLastName.text.length == 0){
         [self.txtLastName becomeFirstResponder];
    } else if (self.txtContactEmailId.text.length == 0) {
        [self.txtContactEmailId becomeFirstResponder];
    } else if (self.txtPhone.text.length == 0){
         [self.txtPhone becomeFirstResponder];
    } else {
         [self.txtEnterPin1 becomeFirstResponder];
    }
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */
- (void)textDidChange:(NSNotification *)notification
{
	UITextField *textField = (UITextField *)[notification object];
    //For signle text fields
    if (textField == self.txtEnterPin && textField.text.length == 4) {
        [self.txtReenterPin becomeFirstResponder];
    }
    else if (textField == self.txtReenterPin && textField.text.length == 4) {
        [self.txtReenterPin resignFirstResponder];
        return;
    }
    
    //For enter PIN
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
		[self.txtReenterPin1 becomeFirstResponder];
	}
	if (textField == self.txtReenterPin1 && textField.text.length == 1) {
		[self.txtReenterPin2 becomeFirstResponder];
	}
	else if (textField == self.txtReenterPin2 && textField.text.length == 1) {
		[self.txtReenterPin3 becomeFirstResponder];
	}
	else if (textField == self.txtReenterPin3 && textField.text.length == 1) {
		[self.txtReenterPin4 becomeFirstResponder];
	}
	else if (textField == self.txtReenterPin4 && textField.text.length == 1) {
		[self.txtReenterPin4 resignFirstResponder];
	}
    //For delete PIN
    else if (textField == self.txtReenterPin4 && textField.text.length == 0) {
        [self.txtReenterPin3 becomeFirstResponder];
    }
    else if (textField == self.txtReenterPin3 && textField.text.length == 0) {
        [self.txtReenterPin2 becomeFirstResponder];
    }
    else if (textField == self.txtReenterPin2 && textField.text.length == 0) {
        [self.txtReenterPin1 becomeFirstResponder];
    }
    else if (textField == self.txtReenterPin1 && textField.text.length == 0) {
        [self.txtEnterPin4 becomeFirstResponder];
    }
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//	if (textField == self.txtFirstName || textField == self.txtLastName || textField == self.txtEmailId) {
    if (textField == self.txtEmailId) {
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if (textField == self.txtFirstName || textField == self.txtLastName || textField == self.txtEmailId || textField == self.txtContactEmailId) {
		return updateString.length <= CHARACTER_LIMIT_EMAIL;
	}
    else if(textField == self.txtPhone)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        NSString *decimalString = [components componentsJoinedByString:@""];
        
        NSUInteger length = decimalString.length;
        BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
        
        if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
            textField.text = decimalString;
            return NO;
        }
        
        NSUInteger index = 0;
        NSMutableString *formattedString = [NSMutableString string];
        
        if (hasLeadingOne) {
            [formattedString appendString:@"1 "];
            index += 1;
        }
        
        if (length - index > 3) {
            NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"(%@) ",areaCode];
            index += 3;
        }
        
        if (length - index > 3) {
            NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"%@-",prefix];
            index += 3;
        }
        
        NSString *remainder = [decimalString substringFromIndex:index];
        [formattedString appendString:remainder];
        
        textField.text = formattedString;
        
        if (hasLeadingOne && length == 11) {
            [self.txtEnterPin1 becomeFirstResponder];
        } else if (!hasLeadingOne && length == 10) {
            [self.txtEnterPin1 becomeFirstResponder];
        }
        
        if ([textField.text isEqualToString:@"1 "])
        {
            return YES;
        }
        return NO;

    }
    else if(textField == self.txtEnterPin || textField == self.txtReenterPin)
    {
        return updateString.length <= 4;
    }
    
	return updateString.length <= 1;
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//
//
//    if (textField == self.txtReenterPin3 && self.txtReenterPin4.text.length == 1) {
//        [self.txtReenterPin4 becomeFirstResponder];
//        return NO;
//    }
//    else if (textField == self.txtReenterPin2 && self.txtReenterPin3.text.length == 1) {
//         [self.txtReenterPin3 becomeFirstResponder];return NO;
//    }
//    else if (textField == self.txtReenterPin1 && self.txtReenterPin2.text.length == 1) {
//        [self.txtReenterPin2 becomeFirstResponder];return NO;
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.txtFirstName) {
		[self.txtLastName becomeFirstResponder];
	}
	else if (textField == self.txtLastName) {
		[self.txtEmailId becomeFirstResponder];
	}
	else if (textField == self.txtEmailId) {
		[self.txtContactEmailId becomeFirstResponder];
	}
    else if (textField == self.txtContactEmailId) {
        [self.txtPhone becomeFirstResponder];
    }
    else if (textField == self.txtPhone) {
        [self.txtEnterPin becomeFirstResponder];
    }
	else {
		[self.txtEnterPin1 becomeFirstResponder];
	}
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == UIAlertViewTagFirstLoginCancel) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [[AppDelegate sharedDelegate] launchAvantiMarkets];
    }
}

- (void)displaySuccessDialog
{
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];    
    displayAlert(@"Update Successful", [NSString stringWithFormat:@"Hello, %@! your profile information has been saved.", self.txtFirstName.text], self, @"OK");

}

- (NSString *) getPhoneNumber:(NSString *) phoneNumber
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"()- "];
    NSArray *arrayOfComponents = [phoneNumber componentsSeparatedByCharactersInSet:characterSet];
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    
    return strOutput;
}

- (BOOL)isPhoneNoValid:(NSString *) strPhone
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"()- "];
    NSArray *arrayOfComponents = [strPhone componentsSeparatedByCharactersInSet:characterSet];
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    NSLog(@"Phone no is: %@",strOutput);

    NSUInteger length = strOutput.length;
    
    if (length < 10) {
        return false;
    }
    
    BOOL hasLeadingOne = length > 0 && [strOutput characterAtIndex:0] == '1';
     unichar isOne = [strOutput characterAtIndex:0];
    
    if (hasLeadingOne && isOne != '1' && length != 11) {
        return false;
    }
    
    for (int position=0; position < length; position++) {
        
        unichar ch = [strOutput characterAtIndex:position];
        
        
        if (length == 11 && position > 0){
            if (ch != '0') {
                return true;
            }
        } else if (length == 11 && position == 0){
            if (ch != '1') {
                return false;
            }
        }
        
        if (length == 10) {
            if (ch != '0') {
                return true;
            }
        }
    }
    
    return false;
    
}

- (IBAction)tapOnSave:(id)sender
{
      AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    if (self.txtFirstName.text.length==0) {
        displayAlertWithMessage(@"Please enter first name");return;

    }
    if (self.txtLastName.text.length==0) {
        displayAlertWithMessage(@"Please enter last name");return;
        
    }
 
//    if (self.txtContactEmailId.text.length == 0 && self.txtEmailId.text.length > 0) {
//        <#statements#>
//    }
//    if (self.txtContactEmailId.text.length == 0 || !validateEmail(self.txtContactEmailId.text)) {
//        displayAlertWithMessage(@"Please enter valid contact email id");return;
//    }
    if (self.txtContactEmailId.text.length>0)
    {
        if (!validateEmail(self.txtContactEmailId.text))
        {
            self.txtContactEmailId.text=@"";
            displayAlertWithMessage(@"Please enter valid email id");return;
        }
    }
    
    NSString *stringPIN=nil;
    NSString *stringConfirmPIN=nil;;
    BOOL isValidNo = [self isPhoneNoValid:self.txtPhone.text];
    if (self.txtPhone.text.length>0) {
        if (!isValidNo)
        {
            displayAlertWithMessage(@"Please enter valid phone number");
            //displayAlertWithTitleMessage(@"Update Failed", @"Phone  number is required.");
            self.txtPhone.text=@"";

            return;
        }
    }
   
    
    
    if (authResp.requestPIN==true)//if pin is der not to check pin filed whic
    {
        stringPIN = [NSString stringWithFormat:@"%@%@%@%@", self.txtEnterPin1.text, self.txtEnterPin2.text, self.txtEnterPin3.text, self.txtEnterPin4.text];
        stringConfirmPIN = [NSString stringWithFormat:@"%@%@%@%@", self.txtReenterPin1.text, self.txtReenterPin2.text, self.txtReenterPin3.text, self.txtReenterPin4.text];
        
        
        
        
        if (stringPIN.length == 0 ) {
            displayAlertWithTitleMessage(@"Update Failed", @"Please enter new PIN.");
            //        displayAlertWithMessage([NSString stringWithFormat:@"Please enter old %@", self.stringTitle]);
            return;
        }
        if (stringPIN.length != 4 ) {
            displayAlertWithTitleMessage(@"Update Failed", @"PIN must be 4 digits.");
            //        displayAlertWithMessage([NSString stringWithFormat:@"Please enter old %@", self.stringTitle]);
            return;
        }
        if (stringConfirmPIN.length == 0 ) {
            displayAlertWithTitleMessage(@"Update Failed", @"Please retype new PIN.");
            //        displayAlertWithMessage([NSString stringWithFormat:@"Please enter new %@", self.stringTitle]);
            return;
        }
        
        
       
        
        
       

        

               
        if (![stringPIN isEqualToString:stringConfirmPIN]) {
            self.txtEnterPin1.text = @"";
            self.txtEnterPin2.text = @"";
            self.txtEnterPin3.text = @"";
            self.txtEnterPin4.text = @"";
            self.txtReenterPin1.text = @"";
            self.txtReenterPin2.text = @"";
            self.txtReenterPin3.text = @"";
            self.txtReenterPin4.text = @"";
            
            [self.txtEnterPin1 becomeFirstResponder];
            displayAlertWithTitleMessage(@"Update Failed", @"PIN fields don't match, please try again.");

           // displayAlertWithMessage(@"PIN mis-match, Please retry");
            return;
        }
 
    }
    
    
    
    //Added by Jyoti
    NSLog(@"***********************************************");
    NSLog(@"POST PROFILE");
    NSLog(@"***********************************************");
    
    if (AVANTI_SERVER_API_RUN)
    {
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];

        UpdateProfileRequest *updateProfileRequest = [[UpdateProfileRequest alloc]init];
        updateProfileRequest.firstName = self.txtFirstName.text;
        updateProfileRequest.lastName = self.txtLastName.text;
        updateProfileRequest.phoneNumber = [self getPhoneNumber:self.txtPhone.text];
        if (self.txtContactEmailId.text.length == 0) {
            updateProfileRequest.email = self.txtEmailId.text;
        } else {
            updateProfileRequest.email = self.txtContactEmailId.text;
        }
        

        // Request
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromArray:@[@"firstName", @"lastName",@"email",@"phoneNumber"]];
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[UpdateProfileRequest class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodAny];
        // Response
        // Left out for brevity
        RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[UpdateProfileResponse  class]];
        [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"firstName" : @"firstName",
                                                          @"lastName" : @"lastName",
                                                          @"email" : @"email",
                                                          @"phoneNumber" : @"phoneNumber" ,
                                                          }];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                                method:RKRequestMethodAny
                                                                                           pathPattern:nil keyPath:nil
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        // RESTManager

        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
        [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
        
        [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
        [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [manager addRequestDescriptor:requestDescriptor];
        [manager addResponseDescriptor:responseDescriptor];

        [manager putObject:nil path:kPathUpdateProfile  parameters:@{@"firstName": updateProfileRequest.firstName, @"lastName": updateProfileRequest.lastName,@"email": updateProfileRequest.email,@"phoneNumber": updateProfileRequest.phoneNumber}
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    
                       profileResponse = [mappingResult firstObject];
                       if (authResp.requestPIN==false)
                       {
                           if ([authResp.pin length]==4)
                           {
                               [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] pin:authResp.pin];
                               
                           }
                           else
                               [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] hexapin:authResp.pin];
                           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
                           [self performSelector:@selector(displaySuccessDialog) withObject:nil afterDelay:0.2f];
                       }

                          else      [self setUserPin:stringPIN];
                       
                       
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       if(!operation.HTTPRequestOperation.response.statusCode ) {
    
                           [AAMixpanel profileSetupFailure:@"Network Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                                                 }
                       else{
                           [AAMixpanel profileSetupFailure:@"Server Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       }
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   }
         ];
    }

}
-(void)setUserPin:(NSString *)userPin
{
    if (AVANTI_SERVER_API_RUN)
    {
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];

        // Request
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromArray:@[@"userPin"]];
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[ChargeStoredCardRequest class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodAny];

        // RESTManager
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
            [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
        
        [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
        [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [manager addRequestDescriptor:requestDescriptor];

        userPin = [[AMUtilities sharedUtilities] generateKeyForPIN:userPin withIteration:189];
        [manager putObject:nil path:kPathSetUserPin parameters:@{@"userPin": userPin}
                    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      //  displayAlertWithMessage(@"Pin  Success");
                        
                        //Mixpanel
                        [AAMixpanel profileSetupSuccess];
                        
                        AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
                        
                 //       profileResponse = [mappingResult firstObject];
                        authResp.email = profileResponse.email;
                        authResp.firstName = profileResponse.firstName;
                        authResp.lastName = profileResponse.lastName;
                        authResp.phoneNumber = profileResponse.phoneNumber;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[authResp data] forKey:NSStringFromClass([AuthenticateResponse class])];
                        
                        
                        
                        if ([authResp.pin length]==4)
                        {
                            [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] pin:userPin];

                        }
                        else
                            [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] hexapin:userPin];

                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
                        
                        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
                        
                        [self performSelector:@selector(displaySuccessDialog) withObject:nil afterDelay:0.2f];
                        

//                        [self getUserPin];//To get the pin from server.
                    }
                    failure:^(RKObjectRequestOperation *operation, NSError *error) {
                        if(!operation.HTTPRequestOperation.response.statusCode ) {
                          
                            
                            [AAMixpanel profileSetupFailure:@"Network Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                            displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                        }
                        else{
                            [AAMixpanel profileSetupFailure:@"Server Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                            displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                        }
                        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                    }
         ];
        }
        else{
          
        //Will be Implemented
        }
    
  }
-(void)getUserPin
{
    NSLog(@"***********************************************");
    NSLog(@"GET USER PIN");
    NSLog(@"***********************************************");
    
    if (AVANTI_SERVER_API_RUN) {

        
        // Response
        RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[UserPin class]];
        [authMapping addAttributeMappingsFromDictionary:@{@"userPin" : @"userPin"}];
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
        [manager addResponseDescriptor:responseDescriptor];
        
        //        [manager postObject:authRequest path:kServerAPIAuthenticate parameters:nil
        id response;
        [manager getObject:response path:kPathGetUserPin
                parameters:nil
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       //sucess
                       UserPin *userPin = [mappingResult firstObject];

                       NSLog(@"**** USER PIN IS :%@ ****",userPin.userPin);
                       }
                    failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       displayAlertWithMessage(@"Get Pin  Failed");

                
                   }];
    }
    
}
-(void)storeUserData
{
   

}
- (IBAction)tapOnCancel:(id)sender {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Update Failed"
                                                      message:@"Account Set-up is required. Are you sure you want to cancel?"
                                                       delegate:self
                                            cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alertView.tag = UIAlertViewTagFirstLoginCancel;
    [alertView show];
}

- (IBAction)tapOnResetPassword:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AVANTI_FORGET_PASSWORD]];
}

@end

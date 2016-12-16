//
//  PersonalInfoViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 14/05/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UpdateProfileRequest.h"
#import "UpdateProfileResponse.h"

@interface PersonalInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblHorizontalSaperator;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;

@property (weak, nonatomic) IBOutlet UITextField *txtPhone;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)tapOnSave:(id)sender;
- (IBAction)tapOnCancel:(id)sender;


@end

@implementation PersonalInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self setTitle:@"EDIT PERSONAL INFO"];
    [self setCustomRegularButtonTextColor:self.btnSave];
    [self setCustomRegularButtonBackgroundColor: self.btnSave];
    [self setCustomRegularButtonTextColor:self.btnCancel];
}

-(void)viewWillAppear:(BOOL)animated
{
    AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    if (authResp) {
        self.txtFirstName.text = authResp.firstName;
        self.txtLastName.text = authResp.lastName;
        self.txtPhone.text = [self getFormatedPhoneNumber:authResp.phoneNumber];
        self.txtEmailId.text = authResp.email;
    }
    
    [super viewWillAppear:animated];
    [self orangeGradient];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) getPhoneNumber:(NSString *) phoneNumber
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"()- "];
    NSArray *arrayOfComponents = [phoneNumber componentsSeparatedByCharactersInSet:characterSet];
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    
    return strOutput;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.view endEditing:YES];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.2f];
}
-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.txtFirstName || textField == self.txtLastName || textField == self.txtEmailId) {
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
            [self.txtPhone resignFirstResponder];
        } else if (!hasLeadingOne && length == 10) {
            [self.txtPhone resignFirstResponder];
        }
        if ([textField.text isEqualToString:@"1 "])
        {
            return YES;
        }
        return NO;

//        return updateString.length <= 11;
    }
    return updateString.length <= 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtFirstName) {
        [self.txtLastName becomeFirstResponder];
    }
    else if (textField == self.txtLastName) {
        [self.txtEmailId becomeFirstResponder];
    }
    else if (textField == self.txtEmailId) {
        [self.txtPhone becomeFirstResponder];
    }
    
    return YES;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    //	if (textField == self.txtFirstName || textField == self.txtLastName || textField == self.txtEmailId) {
//    if (textField == self.txtEmailId) {
//        return NO;
//    }
//    return YES;
//}



- (void)displaySuccessDialog
{
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
    displayAlert(@"Update Successful", @" your profile information has been saved", self, @"OK");
}

- (IBAction)tapOnSave:(id)sender {
    if (self.txtFirstName.text.length==0) {
        //displayAlertWithMessage(@"Please enter first name");return;
        [self markTextFieldWithError:self.txtFirstName];
        return;
    }
    if (self.txtLastName.text.length==0) {
        //displayAlertWithMessage(@"Please enter last name");return;
        [self markTextFieldWithError:self.txtLastName];
        return;
    }

    if (self.txtEmailId.text.length>0) {
        if (!validateEmail(self.txtEmailId.text)) {
            self.txtEmailId.text = @"";
            [self markTextFieldWithError:self.txtEmailId];
            return;
        }
    }
    
    
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
    [self.view endEditing:YES];

    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];

    UpdateProfileRequest *updateProfileRequest = [[UpdateProfileRequest alloc]init];
    updateProfileRequest.firstName = self.txtFirstName.text;
    updateProfileRequest.lastName = self.txtLastName.text;
    
    updateProfileRequest.phoneNumber = [self getPhoneNumber:self.txtPhone.text];
    updateProfileRequest.email = self.txtEmailId.text;
    
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
                   
                   AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];

                   profileResponse = [mappingResult firstObject];
                   authResp.email = profileResponse.email;
                   authResp.firstName = profileResponse.firstName;
                   authResp.lastName = profileResponse.lastName;
                   authResp.phoneNumber = profileResponse.phoneNumber;
                   
//                   NSLog(@" AMS ID xxxxxx%@",authResp.ams_id);
                   [[NSUserDefaults standardUserDefaults] setObject:[authResp data] forKey:NSStringFromClass([AuthenticateResponse class])];
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   [self displaySuccessDialog];
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   if(!operation.HTTPRequestOperation.response.statusCode )
                   {                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       
                   }
                   else{
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   
                   }
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
               }
     ];
    
    
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

- (NSString *) getFormatedPhoneNumber:(NSString *) phoneNumber
{
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


- (IBAction)tapOnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end

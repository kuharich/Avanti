//
//  ResetViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 14/05/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "ResetViewController.h"
#import "ChangePasswordRequest.h"
#import "ChangePasswordResponse.h"

@interface ResetViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableReset;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
- (IBAction)tapOnDone:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)tapOnCancel:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtOldPIN;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPIN;
@property (strong, nonatomic) IBOutlet UITextField *txtRetypeNewPIN;

@property (strong, nonatomic) NSString *stringTitle ;

@end
#define TEXT_PIN        @"PIN"
#define TEXT_PASSWORD   @"Password"
@implementation ResetViewController

- (UITextField *)setupTextField:(UIKeyboardType )keyboardType placeholder:(NSString *)placeholder{
    UITextField *txtPIN  = [[UITextField alloc] initWithFrame:CGRectZero];
    [txtPIN setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [txtPIN setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtPIN setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txtPIN setBorderStyle:UITextBorderStyleNone];
    [txtPIN setClearButtonMode:UITextFieldViewModeWhileEditing];
    txtPIN.delegate=self;
    [txtPIN setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:14]];
    [txtPIN setSecureTextEntry:YES];
    [txtPIN setKeyboardType:keyboardType];
    [txtPIN setPlaceholder:placeholder];
    return txtPIN;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtOldPIN resignFirstResponder];
    [self.txtNewPIN resignFirstResponder];
    [self.txtRetypeNewPIN resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];

    if ([self.title isEqualToString:@"RESET PASSWORD"]) {
        self.txtOldPIN  = [self  setupTextField:UIKeyboardTypeDefault placeholder:@"Old Password (required)"];
        self.txtNewPIN  = [self  setupTextField:UIKeyboardTypeDefault placeholder:@"New Password (required)"];
        self.txtRetypeNewPIN  = [self  setupTextField:UIKeyboardTypeDefault placeholder:@"Retype New Password (required)"];
        self.stringTitle = TEXT_PASSWORD;
    }
    else{
        self.stringTitle = TEXT_PIN;
        self.txtOldPIN  = [self  setupTextField:UIKeyboardTypeNumberPad placeholder:@"Old PIN (required)"];
        self.txtNewPIN  = [self  setupTextField:UIKeyboardTypeNumberPad placeholder:@"New PIN (required)"];
        self.txtRetypeNewPIN  = [self  setupTextField:UIKeyboardTypeNumberPad placeholder:@"Retype New PIN (required)"];
    }
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [tapRec setCancelsTouchesInView:NO];
    [self.tableReset addGestureRecognizer:tapRec];
    
    [self setCustomRegularButtonTextColor:self.btnDone];
    [self setCustomRegularButtonBackgroundColor: self.btnDone];
    [self setCustomRegularButtonTextColor:self.btnCancel];
}

-(void)tap:(id)tapRec{
    [self.txtOldPIN resignFirstResponder];
    [self.txtNewPIN resignFirstResponder];
    [self.txtRetypeNewPIN resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([self.stringTitle isEqualToString:TEXT_PIN]) {
        return updateString.length <= 4;
    }
    return updateString.length <= CHARACTER_LIMIT_PASSWORD;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtOldPIN) {
        [self.txtNewPIN becomeFirstResponder];
    }
    else if (textField == self.txtNewPIN) {
        [self.txtRetypeNewPIN becomeFirstResponder];
    }
    else if (textField == self.txtRetypeNewPIN) {
        [self.txtRetypeNewPIN resignFirstResponder];
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 20)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 25)];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.viewFooter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"resetCellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		[cell.textLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
		cell.textLabel.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}

    CGRect rect = CGRectMake(20, 0, cell.contentView.bounds.size.width - 50, cell.contentView.bounds.size.height) ;
	if (indexPath.row == 0) {
		[self.txtOldPIN setFrame:rect];
		[cell.contentView addSubview:self.txtOldPIN];
	}
	else if (indexPath.row == 1) {
		[self.txtNewPIN setFrame:rect];
		[cell.contentView addSubview:self.txtNewPIN];
	}
	else if (indexPath.row == 2) {
		[self.txtRetypeNewPIN setFrame:rect];
		[cell.contentView addSubview:self.txtRetypeNewPIN];
	}
	else {
        
	}
	return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == UIAlertViewTagPinChangeSuccess) {
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.1f];
    }
}

- (IBAction)tapOnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
  
}



- (IBAction)tapOnDone:(id)sender {
    
    [self.txtOldPIN resignFirstResponder];
    [self.txtNewPIN resignFirstResponder];
    [self.txtRetypeNewPIN resignFirstResponder];
    
    if (self.txtOldPIN.text.length == 0 ) {
        [self markTextFieldWithError:self.txtOldPIN];
        return;
    }
    
    if (self.txtNewPIN.text.length == 0 ) {
        [self markTextFieldWithError:self.txtNewPIN];
        return;
    }
    
    
    if (self.txtRetypeNewPIN.text.length == 0 ) {
        [self markTextFieldWithError:self.txtRetypeNewPIN];
        return;
    }
    
    if ([self.stringTitle isEqualToString:TEXT_PIN] && self.txtNewPIN.text.length != 4) {
        //displayAlertWithMessage([NSString stringWithFormat:@"Please enter 4 dight pin"]);return;
        displayAlertWithTitleMessage(@"Reset Failed", @"PIN must be 4 digits.");
        return;

    }
    
    if ([self.stringTitle isEqualToString:TEXT_PASSWORD] && self.txtNewPIN.text.length < 8) {
        //displayAlertWithMessage([NSString stringWithFormat:@"Please enter 4 dight pin"]);return;
        displayAlertWithTitleMessage(@"Reset Failed", @"Password must be at least 8 characters.");
        return;
        
    }
 
    
    if ([self.txtRetypeNewPIN.text isEqualToString:self.txtNewPIN.text] == false && [self.stringTitle isEqualToString:TEXT_PASSWORD]) {
        displayAlertWithTitleMessage(@"Reset Failed",@"Password fields don't match.");
        //        displayAlertWithMessage([NSString stringWithFormat:@"Retype %@ should be same", self.stringTitle]);
        return;
    }
    
    if ([self.txtRetypeNewPIN.text isEqualToString:self.txtNewPIN.text] == false && [self.stringTitle isEqualToString:TEXT_PIN]) {
         displayAlertWithTitleMessage(@"Reset Failed",[NSString stringWithFormat:@ "The %@'s you entered don't match.", self.stringTitle]);
//        displayAlertWithMessage([NSString stringWithFormat:@"Retype %@ should be same", self.stringTitle]);
        return;
    }
    
    if ([self.txtOldPIN.text isEqualToString:self.txtNewPIN.text]) {
        displayAlertWithTitleMessage(@"Reset Failed",[NSString stringWithFormat:@"New %@ entered is same as old %@. Please try a different %@.", self.stringTitle,self.stringTitle,self.stringTitle]);
//        displayAlertWithMessage([NSString stringWithFormat:@"Please type a different %@", self.stringTitle]);
        return;
    }
    
    if ([self.stringTitle isEqualToString:TEXT_PIN] && [[AMUtilities sharedUtilities] isValidPIN:self.txtOldPIN.text] == false) {
        //    displayAlertWithMessage([NSString stringWithFormat:@"Old %@ mis-match, Please retry", self.stringTitle]);
        displayAlertWithTitleMessage(@"Reset Failed", [NSString stringWithFormat:@"Please check old %@ and try again.", self.stringTitle]);
        return;
    }

    if ([self.stringTitle isEqualToString:TEXT_PASSWORD]) {
        NSString *storePasswordbase64 =[[AMUtilities sharedUtilities]base64PasswordWithUserName:[AMUtilities getUsername] andPassword:[AMUtilities getPassword]];
        NSString *txtPasswordbase64 =[[AMUtilities sharedUtilities]base64PasswordWithUserName:[AMUtilities getUsername] andPassword:self.txtOldPIN.text];
        if ([storePasswordbase64 isEqualToString:txtPasswordbase64])
        {
            [self changePassword:self.txtOldPIN.text withNewPassword:self.txtNewPIN.text];
   
        }
        else
        {
            displayAlertWithTitleMessage(@"Reset Failed", [NSString stringWithFormat:@"Please check old %@ and try again.", self.stringTitle]);
//            displayAlertWithTitleMessage(@"Old Password IN-CORRECT", nil);
//New Password entered is same as old Password. Please try a different Password
        }

    }
    else {
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
        
        NSString *newUserPin = self.txtNewPIN.text;
        newUserPin = [[AMUtilities sharedUtilities] generateKeyForPIN:newUserPin withIteration:189];
        [manager putObject:nil path:kPathSetUserPin parameters:@{@"userPin": newUserPin}
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       if ([newUserPin length]==4)
                       {
                           [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] pin:newUserPin];
                           
                       }
                       else
                           [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] hexapin:newUserPin];
                   //    [[AMUtilities sharedUtilities] storePassword:authRequest.userPassword pin:newUserPin];
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                        UIAlertView *uiAlert = displayAlert(@"Update Successful", @"Your PIN was successfully updated", self, @"OK");
                       uiAlert.tag = UIAlertViewTagPinChangeSuccess;
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       if(!operation.HTTPRequestOperation.response.statusCode )
                       {                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                           
                       }
                       else{
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                           
                       }
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   }
         ];
    }

}

-(void)changePassword:(NSString *)oldPassword withNewPassword:(NSString *)newPassword
{
    if (AVANTI_SERVER_API_RUN)
    {
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
        
        // Request
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromArray:@[@"oldPassword", @"newPassword"]];
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[ChangePasswordRequest class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodAny];
        
        // Response
        RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[ChangePasswordResponse class]];
        [authMapping addAttributeMappingsFromDictionary:@{@"result" : @"result"}];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                                method:RKRequestMethodAny
                                                                                           pathPattern:nil keyPath:nil
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        // RESTManager
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
        [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
        
        [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
        [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [manager addRequestDescriptor:requestDescriptor];
        [manager addResponseDescriptor:responseDescriptor];
        
        
        [manager putObject:nil path:kPathChangePassword parameters:@{@"oldPassword": oldPassword, @"newPassword": newPassword}
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                       if ([operation.HTTPRequestOperation.responseString containsString:@"true"]) {
                           [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                           //                       NSString *alertMessage = @"Password changed successfully! Please reLog-in";
                           //                       displayAlertWithMessage(alertMessage);
                           displayAlertWithTitleMessage(@"Update Successful",@"Your password  was successfully updated!");
                           [[NSNotificationCenter defaultCenter] postNotificationName:AMSignOutSuccessNotification object:nil];
                           [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_StoredEncryptedPass];
                           [[AppDelegate sharedDelegate] performSelector:@selector(launchLoginScreen) withObject:nil afterDelay:0.1];
                       }
                       else
                       {
                           displayAlertWithTitleMessage(@"Change Password Failed", nil);

                       }
                      
                       
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       if(!operation.HTTPRequestOperation.response.statusCode )
                       {                        displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                       }
                       else{
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                       }
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   }
         ];
    }
    
}


@end

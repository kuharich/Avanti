//
//  ForgotPasswordViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 15/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "SendEmailRequest.h"
#import "SendEmailResponse.h"
#import "AAMixpanel.h"

@interface ForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblHeadingText;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailID;

@property (weak, nonatomic) IBOutlet UIButton *btnForgetEmail;
- (IBAction)tapOfForgetEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
- (IBAction)tapOnEmailMe:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
- (IBAction)tapOnReturnMe:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewEntryBox;

@property (weak, nonatomic) IBOutlet UIView *viewBackBox;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)tapOnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewbackground;
@property (weak, nonatomic) IBOutlet UILabel *poweredByLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation ForgotPasswordViewController

@synthesize imgViewbackground;
@synthesize poweredByLabel;
@synthesize separatorLine;
@synthesize lblHeadingText;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    CGRect rect = self.view.frame;
    //    self.view.frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
    [self resignView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [AAMixpanel notRegisteredDisplayed];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    self.txtEmailID.leftView = leftView;
    self.txtEmailID.leftViewMode = UITextFieldViewModeAlways;
    self.txtEmailID.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIColor *color = [UIColor whiteColor];
    if ([self.txtEmailID respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.txtEmailID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    }
    [self setCustomPlaceholderColor:self.txtEmailID text:@"EMAIL"];
    [self setCustomTextFieldColor:self.txtEmailID];
    [self setCustomBackgroundColor: self.imgViewbackground];
    [self setCustomLabelColor: poweredByLabel];
    [self setCustomViewColor: self.separatorLine];
    [self setCustomLabelColor: self.lblHeadingText];
    
    [self setCustomRegularButtonBackgroundColor: self.btnEmail];
    [self setCustomRegularButtonTextColor: self.btnEmail];
    [self setCustomCancelButtonTextColor: self.btnCancel];
    [self setCustomCancelButtonBackgroundColor: self.btnCancel];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return updateString.length <= CHARACTER_LIMIT_EMAIL;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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


- (IBAction)tapOfForgetEmail:(id)sender {
    
}

-(void)sendEmail:(NSString *)eMail
{
    if (AVANTI_SERVER_API_RUN)
    {
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
        
        // Request
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromArray:@[@"email"]];
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[SendEmailRequest class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodAny];
        
        // RESTManager
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
        //[manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
        
        [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
        [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [manager addRequestDescriptor:requestDescriptor];
        
        
        [manager putObject:nil path:kPathRestPassword parameters:@{@"email": eMail}
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       [AAMixpanel forgotPasswordSuccess];

                       NSString *alertMessage = [NSString stringWithFormat:@"An email with instructions on how to reset your Password has been sent to %@.", self.txtEmailID.text];
                       alertMessage = @"If the email address you entered is tied to a Market Account, you will receive an email with password reset instructions. If you do not receive an email within a few minutes, please click the \"Forgot Password\" button again and enter alternative email address.";
                       displayAlertWithMessage(alertMessage);
//                        [self.navigationController popViewControllerAnimated:YES];
                       [self.navigationController popToRootViewControllerAnimated:YES];
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                      
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       if(!operation.HTTPRequestOperation.response.statusCode ) {
                           [AAMixpanel forgotPasswordFailure:@"Network Error" witherrorCode:nil];
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                         //   [AAMixpanel forgotpasswordFailure:@"Server Error" witherrorCode:[NSString stringWithFormat:@"%d",operation.HTTPRequestOperation.response.statusCode]];
                         
                       }
                       else{
                           
                           [AAMixpanel forgotPasswordFailure:@"Server Error" witherrorCode:[NSString stringWithFormat:@"%ld",(long)operation.HTTPRequestOperation.response.statusCode]];
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       }
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   }
         ];
    }

}

- (IBAction)tapOnReturnMe:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)tapOnEmailMe:(id)sender {
    if (validateEmail(self.txtEmailID.text)) {
         [self sendEmail:self.txtEmailID.text];
    }
    else{
        displayAlertWithMessage(@"Please enter valid email address");
    }
}
- (IBAction)tapOnCancel:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}


@end

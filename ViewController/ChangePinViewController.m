//
//  ChangePinViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 27/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "ChangePinViewController.h"
#import "ForgotPasswordViewController.h"
@interface ChangePinViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnSignIN;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtEmailID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin;

@property (weak, nonatomic) IBOutlet UILabel *lblEnterPin;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin1;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin2;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin3;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterPin4;

@property (weak, nonatomic) IBOutlet UIView *separator1View;

@property (weak, nonatomic) IBOutlet UILabel *lblReenterPin;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin1;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin2;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin3;
@property (weak, nonatomic) IBOutlet UITextField *txtReenterPin4;
@property (weak, nonatomic) IBOutlet UILabel *enterCredentialsLabel;
@property (weak, nonatomic) IBOutlet UIView *separator2View;
@property (weak, nonatomic) IBOutlet UIView *separator3View;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

#pragma UIActions
- (IBAction)tapOnSignIN:(id)sender;
- (IBAction)tapOnCancel:(id)sender;
- (IBAction)tapOnForgotPassword:(id)sender;

@end

@implementation ChangePinViewController
@synthesize comingFromBackground;
@synthesize btnSignIN;
@synthesize btnCancel;
@synthesize btnForgotPassword;

- (void)resetUI {
    for (UIView *v in self.view.subviews) {
        for (UIView *sview in v.subviews) {
            [sview resignFirstResponder];
        }
        [v resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resetUI];
}

- (void)viewDidLoad
{       
    addBorderInTextField(self.txtEnterPin1);
    addBorderInTextField(self.txtEnterPin2);
    addBorderInTextField(self.txtEnterPin3);
    addBorderInTextField(self.txtEnterPin4);
    
    addBorderInTextField(self.txtReenterPin1);
    addBorderInTextField(self.txtReenterPin2);
    addBorderInTextField(self.txtReenterPin3);
    addBorderInTextField(self.txtReenterPin4);
    
    [self.txtEmailID becomeFirstResponder];
    self.btnForgotPassword.contentMode = UIViewContentModeScaleAspectFill;
    self.btnForgotPassword.clipsToBounds = YES;
    self.btnForgotPassword.layer.borderWidth = 1.0f;
    self.btnForgotPassword.layer.borderColor = [UIColor grayColor].CGColor;
    [super viewDidLoad];
    
    [self setPlaceholderColor:self.txtEmailID text:@"EMAIL"];
    [self setPlaceholderColor:self.txtPassword text:@"PASSWORD"];
    [self setSubmitButtonColor: btnSignIN];
    [self setCancelButtonColor: btnCancel];
    [self setForgotButtonColor: btnForgotPassword];
    
    [self setTitle:@"RESET PIN"];
    
    [self setCustomRegularButtonBackgroundColor: self.btnSignIN];
    [self setCustomRegularButtonTextColor: self.btnSignIN];
    [self setCustomRegularButtonTextColor: self.btnCancel];
    [self setCustomRegularButtonTextColor: self.btnForgotPassword];
    [self setCustomBackgroundImage: self.backgroundImage];
    [self setCustomViewColor: self.separator1View];
    [self setCustomViewColor: self.separator2View];
    [self setCustomViewColor: self.separator3View];
    [self setCustomLabelColor:self.enterCredentialsLabel];
    [self setCustomLabelColor:self.lblEnterPin];
    [self setCustomLabelColor:self.lblReenterPin];
    [self setCustomPlaceholderColor:self.txtEmailID text:@"EMAIL"];
    [self setCustomPlaceholderColor:self.txtPassword text:@"PASSWORD"];
    [self setCustomTextFieldColor:self.txtEmailID];
    [self setCustomTextFieldColor:self.txtPassword];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [super viewWillDisappear:animated];
}

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
    else if (textField == self.txtReenterPin1 && textField.text.length == 1) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.txtPassword || textField == self.txtEmailID) {
        return updateString.length <= CHARACTER_LIMIT_EMAIL;
    }
    else if(textField == self.txtEnterPin || textField == self.txtReenterPin)
    {
        return updateString.length <= 4;
    }
    return updateString.length <= 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtEmailID) {
        [self.txtPassword becomeFirstResponder];
    }
    else if (textField == self.txtPassword) {
        [self.txtEnterPin1 becomeFirstResponder];
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.comingFromBackground) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.comingFromBackground = NO;
        }];
    }
    else{
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
        [[AppDelegate sharedDelegate] performSelector:@selector(launchAvantiMarkets) withObject:nil afterDelay:0.5f];
    }
    [[AppDelegate sharedDelegate] setAvantAppDisplayed:YES];
    
}
#pragma UIActions
- (IBAction)tapOnSignIN:(id)sender{
    if (self.txtEmailID.text.length == 0 || !validateEmail(self.txtEmailID.text)) {
        displayAlertWithMessage(@"Please enter valid email id.");return;
    }
    if (self.txtPassword.text.length == 0 ) {
        displayAlertWithMessage(@"Password should not be blank.");return;
    }

    
    if ([self.txtEmailID.text caseInsensitiveCompare:[AMUtilities getUsername]] == NSOrderedSame && [self.txtPassword.text isEqualToString:[AMUtilities getPassword]]) {
        NSString *stringPIN = [NSString stringWithFormat:@"%@%@%@%@", self.txtEnterPin1.text, self.txtEnterPin2.text, self.txtEnterPin3.text, self.txtEnterPin4.text];
        NSString *stringConfirmPIN = [NSString stringWithFormat:@"%@%@%@%@", self.txtReenterPin1.text, self.txtReenterPin2.text, self.txtReenterPin3.text, self.txtReenterPin4.text];
        
        if (stringPIN.length < 4) {
            displayAlertWithMessage(@"Please enter 4-digit PIN.");return;
        }
        if (stringConfirmPIN.length < 4) {
            displayAlertWithMessage(@"Please Re-enter 4-digit PIN.");return;
        }
        
        if (![stringPIN isEqualToString:stringConfirmPIN]) {
            displayAlertWithMessage(@"PIN mis-match, Please retry.");return;
        }
        
        
        [[AMUtilities sharedUtilities]setUserPin:stringPIN withBlock:^(id obj)
        {
            if ([obj isEqualToString:stringPIN])
            {
                displayAlert(nil, @"Your PIN was successfully changed.", self, @"OK");
                [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] pin:stringPIN];

            }
            else
            {
               // displayAlert(nil, @"Failed.Please try again", nil, @"OK");

            }
        }];
    
    }
    
    else{
        displayAlertWithTitleMessage(LOGIN_ERROR_ALERT_TITLE, LOGIN_ERROR_ALERT_MESSAGE);
    }
    
}
- (IBAction)tapOnCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapOnForgotPassword:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AVANTI_FORGET_PASSWORD]];
}
- (IBAction)tapOnPasword:(id)sender{
    ForgotPasswordViewController *fpView = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:fpView animated:YES];
}
@end

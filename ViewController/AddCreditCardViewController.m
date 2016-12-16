//
//  AddCreditCardViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AddCreditCardViewController.h"
#import "AMCreditCardInfo.h"

@interface AddCreditCardViewController ()

@property (strong, nonatomic) AMCreditCardInfo *creditCardInfo;

@property (weak, nonatomic) IBOutlet UIView *viewDetailSection;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtBillingZip;
@property (weak, nonatomic) IBOutlet UITextField *txtCVCCode;


@property (weak, nonatomic) IBOutlet UIButton *btnMakePrimary;
- (IBAction)tapOnMakePrimary:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
- (IBAction)tapOnDone:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)tapOnCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)tapOnDelete:(id)sender;

@property BOOL  isCardPrimary;
@end

@implementation AddCreditCardViewController

@synthesize isUpdateCard;
@synthesize creditCardInfo;

- (void)loadCreditCardDetail:(AMCreditCardInfo *)cardInfo {
	self.creditCardInfo = cardInfo;

//	self.txtBillingZip.text = cardInfo.creditCardInfo.cardTypeOne;
//	self.txtCVCCode.text = cardInfo.creditCardInfo.cvv;

//	self.txtFirstName.text = cardInfo.firstName;
//	self.txtLastName.text = cardInfo.lastName;

	[self.btnMakePrimary setSelected:cardInfo.isPrimary];
     self.isCardPrimary = cardInfo.isPrimary;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	[self setTitle:@"ADD CARD"];
	[self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];

	formatButtonWithBorder(self.btnCancel, DEFAULT_COLOR_THEME_WHITE, DEFAULT_COLOR_THEME_GRAY, NO);
	formatButtonWithBorder(self.btnDone, DEFAULT_COLOR_THEME_WHITE, DEFAULT_COLOR_THEME_GREEN, NO);
}

- (void)viewWillAppear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    formatButtonWithoutBorder(self.btnDone, [UIColor whiteColor], DEFAULT_COLOR_THEME_GREEN, NO);
    formatButtonWithoutBorder(self.btnCancel, [UIColor whiteColor], DEFAULT_COLOR_THEME_GRAY, NO);
    
	if (self.isUpdateCard) {
		[self setTitle:@"UPDATE INFO"];
        NSArray *creditCards = [[AMUtilities sharedUtilities] getCreditCards];
        formatButtonWithoutBorder(self.btnDelete, [UIColor whiteColor], [UIColor darkGrayColor], creditCards.count < 2);
	}
	else {
		[self setTitle:@"ADD CARD"];

		self.btnDelete.hidden = YES;
	}
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignView:self.view];
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (self.txtBillingZip == textField) {
		self.txtBillingZip.textColor = [UIColor grayColor];
	}
	else if (self.txtCVCCode == textField) {
		self.txtCVCCode.textColor = [UIColor grayColor];
	}
	else if (self.txtFirstName == textField || self.txtLastName == textField) {
		self.txtFirstName.textColor = [UIColor grayColor];
		self.txtLastName.textColor = [UIColor grayColor];
	}
	return YES;
}

- (void)textDidChange:(NSNotification *)notification {
	UITextField *textField = (UITextField *)[notification object];
	if (textField == self.txtCVCCode && self.txtCVCCode.text.length == 3) {
		[textField resignFirstResponder];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if (textField == self.txtFirstName || textField == self.txtLastName) {
		self.txtFirstName.textColor = [UIColor grayColor];
		self.txtLastName.textColor = [UIColor grayColor];
		return updateString.length <= CHARACTER_LIMIT_CARD_NAME;
	}
	else if (textField == self.txtBillingZip) {
		self.txtBillingZip.textColor = [UIColor grayColor];
		return updateString.length <= CHARACTER_LIMIT_ZIP_CODE;
	}
	self.txtCVCCode.textColor = [UIColor grayColor];
	return updateString.length <= CHARACTER_LIMIT_CVC_CODE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.txtFirstName) {
		[self.txtLastName becomeFirstResponder];
	}
	else if (textField == self.txtLastName) {
		[self.txtBillingZip becomeFirstResponder];
	}
	else if (textField == self.txtBillingZip) {
		[self.txtCVCCode becomeFirstResponder];
	}
	else {
		[textField resignFirstResponder];
	}
	return YES;
}

- (IBAction)tapOnMakePrimary:(id)sender {
    if (self.isCardPrimary == NO) {
     [self.btnMakePrimary setSelected:!self.btnMakePrimary.isSelected];
    }
}

- (IBAction)tapOnDone:(id)sender {
    [self resignView:self.view];
	BOOL isValidForm = YES;
	if (self.txtFirstName.text.length + self.txtLastName.text.length == 0) {
		displayAlert(nil, @"Please enter name", nil, @"OK");
		isValidForm = NO;
	}
	if (!validateZipCode(self.txtBillingZip.text)) {
		self.txtBillingZip.textColor = [UIColor redColor];
		isValidForm = NO;
	}
	if (self.txtCVCCode.text.length < 3) {
		isValidForm = NO;
		self.txtCVCCode.textColor = [UIColor redColor];
	}

	if (isValidForm) {
		self.creditCardInfo.firstName = self.txtFirstName.text;
		self.creditCardInfo.lastName = self.txtLastName.text;

		self.creditCardInfo.creditCardInfo.cardTypeOne = self.txtBillingZip.text;
		self.creditCardInfo.creditCardInfo.cvv = self.txtCVCCode.text;

		self.creditCardInfo.primary = self.btnMakePrimary.isSelected;

		if (self.isUpdateCard) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Are you sure you'd like to update this card?"
                                                               delegate:self
                                                      cancelButtonTitle:@"CANCEL" otherButtonTitles:@"UPDATE", nil];
            alertView.tag = UIAlertViewTagUpdateConfirmation;
            [alertView show];
		}
		else {
			self.creditCardInfo.creditCardInfo.expiryMonth = @"04";
			self.creditCardInfo.creditCardInfo.expiryYear = @"17";
			[[AMUtilities sharedUtilities] saveCreditCard:self.creditCardInfo];
			displayAlert(nil, [NSString stringWithFormat:@"Your card ending in %@ has been successfully added.", self.creditCardInfo.lastFourDigit], nil, @"OK");
			[[NSNotificationCenter defaultCenter] postNotificationName:AMCreditCardSaveSuccessNotification object:nil];

			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (IBAction)tapOnCancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == UIAlertViewTagDeleteConfirmation) {
        if (buttonIndex == 1) {
            [[AMUtilities sharedUtilities] deleteCreditCardByCardId: self.creditCardInfo.cardID];
            [[NSNotificationCenter defaultCenter] postNotificationName:AMCreditCardSaveSuccessNotification object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag == UIAlertViewTagUpdateConfirmation){
        if (buttonIndex == 1) {
            if (self.btnMakePrimary.isSelected) {
                [[NSUserDefaults standardUserDefaults] setObject:self.creditCardInfo.cardID forKey:NSUSERDEFAULT_PRIMARY_CREDIT_CARD];
            }
            else {
                NSString *primaryCardID = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:NSUSERDEFAULT_PRIMARY_CREDIT_CARD];
                if (primaryCardID == nil) {
                    primaryCardID = @"";
                }
                if ([primaryCardID isEqualToString:self.creditCardInfo.cardID]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_PRIMARY_CREDIT_CARD];
                }
            }
            [[AMUtilities sharedUtilities] updateCreditCard:self.creditCardInfo];
            displayAlert(nil, [NSString stringWithFormat:@"Your card ending in %@ has been successfully updated.", self.creditCardInfo.lastFourDigit], nil, @"OK");
            [[NSNotificationCenter defaultCenter] postNotificationName:AMCreditCardSaveSuccessNotification object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
    
    }
}

- (IBAction)tapOnDelete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Are you sure you'd like to delete this card?"
                                                       delegate:self
                                              cancelButtonTitle:@"KEEP" otherButtonTitles:@"DELETE", nil];
    alertView.tag = UIAlertViewTagDeleteConfirmation;
    [alertView show];
}

@end

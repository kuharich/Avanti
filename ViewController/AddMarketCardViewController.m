//
//  AddMarketCardViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 10/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AddMarketCardViewController.h"

@interface AddMarketCardViewController ()

@property (strong, nonatomic) AMMarketCardInfo *amMarketCardInfo;
@property (assign, nonatomic) MarketCardColor selectedColor;
@property (weak, nonatomic) IBOutlet UIView *viewTextField;
@property (weak, nonatomic) IBOutlet UITextField *txtNameOfCard;

@property (weak, nonatomic) IBOutlet UIButton *btnMakePrimary;
- (IBAction)tapOnMakePrimary:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewChooseColor;
@property (weak, nonatomic) IBOutlet UIButton *btnColorGreen;
@property (weak, nonatomic) IBOutlet UIButton *btnColorBlue;
@property (weak, nonatomic) IBOutlet UIButton *btnColorAqua;
- (IBAction)tapOnChooseColor:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btnDone;
- (IBAction)tapOnDone:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)tapOnCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)tapOnDelete:(id)sender;

@property BOOL  isCardPrimary;
@end

@implementation AddMarketCardViewController

@synthesize scanedMMCardBarCode;
@synthesize isUpdateCard;


- (void)viewDidLoad {
    [self setTitle:@"ADD MARKET CARD"];
    [super viewDidLoad];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
    [self tapOnChooseColor:self.btnColorGreen];
    // Do any additional setup after loading the view from its nib.
    
    formatButtonWithBorder(self.btnCancel, DEFAULT_COLOR_THEME_WHITE, DEFAULT_COLOR_THEME_GRAY, NO);
    formatButtonWithBorder(self.btnDone, DEFAULT_COLOR_THEME_WHITE, DEFAULT_COLOR_THEME_GREEN, NO);
}

- (void)loadMyMarketCardDetail:(AMMarketCardInfo *)cardInfo{
    self.amMarketCardInfo = cardInfo;
    
    self.txtNameOfCard.text = cardInfo.cardName;

    [self.btnMakePrimary setSelected:cardInfo.isPrimary];
    self.isCardPrimary = cardInfo.isPrimary;
    
    [self.btnColorAqua setSelected:NO];
    [self.btnColorGreen setSelected:NO];
    [self.btnColorBlue setSelected:NO];
    
    self.selectedColor = cardInfo.color;
    switch (cardInfo.color) {
        case MarketCardColorAqua:
            [self.btnColorAqua setSelected:YES];
            break;
        case MarketCardColorBlue:
            [self.btnColorBlue setSelected:YES];
            break;
        default:
            [self.btnColorGreen setSelected:YES];
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    formatButtonWithoutBorder(self.btnDone, [UIColor whiteColor], DEFAULT_COLOR_THEME_GREEN, NO);
    formatButtonWithoutBorder(self.btnCancel, [UIColor whiteColor], DEFAULT_COLOR_THEME_GRAY, NO);
    if (self.isUpdateCard) {
        [self setTitle:@"UPDATE INFO"];
        NSArray *marketCards = [[AMUtilities sharedUtilities] getMarketCards];
        formatButtonWithoutBorder(self.btnDelete, [UIColor whiteColor], [UIColor darkGrayColor], marketCards.count < 2);
    }
    else {
        [self setTitle:@"ADD MARKET CARD"];
        self.btnDelete.hidden = YES;
    }
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return updateString.length <= CHARACTER_LIMIT_CARD_NAME;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapOnMakePrimary:(id)sender {
    if (self.isCardPrimary == NO) {
        [self.btnMakePrimary setSelected:!self.btnMakePrimary.isSelected];
    }
}

- (IBAction)tapOnChooseColor:(id)sender {
    
    if (sender == self.btnColorAqua) {
        self.selectedColor = MarketCardColorAqua;
        [self.btnColorAqua setSelected:YES];
        [self.btnColorGreen setSelected:NO];
        [self.btnColorBlue setSelected:NO];
    }
    else if (sender == self.btnColorGreen) {
        self.selectedColor = MarketCardColorGreen;
        [self.btnColorAqua setSelected:NO];
        [self.btnColorGreen setSelected:YES];
        [self.btnColorBlue setSelected:NO];
    }
    else if (sender == self.btnColorBlue) {
        self.selectedColor = MarketCardColorBlue;
        [self.btnColorAqua setSelected:NO];
        [self.btnColorGreen setSelected:NO];
        [self.btnColorBlue setSelected:YES];
    }
}

- (IBAction)tapOnDone:(id)sender {
    if (self.txtNameOfCard.text.length==0) {
        displayAlert(nil, @"Please enter card name", nil, @"OK");
    }
    else{
        self.amMarketCardInfo.cardName = self.txtNameOfCard.text;
        self.amMarketCardInfo.color = self.selectedColor;
        self.amMarketCardInfo.primary = self.btnMakePrimary.isSelected;
        
        if (self.isUpdateCard) {
            
            if (self.btnMakePrimary.isSelected) {
                [[NSUserDefaults standardUserDefaults] setObject:self.amMarketCardInfo.mScanCode forKey:NSUSERDEFAULT_PRIMARY_CREDIT_CARD];
            }
            else{
                NSString *primaryCard = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:NSUSERDEFAULT_PRIMARY_CREDIT_CARD];
                if (primaryCard==nil) {
                    primaryCard = @"";
                }
                if ([primaryCard isEqualToString:self.self.amMarketCardInfo.mScanCode]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_PRIMARY_CREDIT_CARD];
                }
            }
            [[AMUtilities sharedUtilities] updateMarketCard:self.amMarketCardInfo];
            
            displayAlert(nil, [NSString stringWithFormat:@"Your card was successfully updated"], nil, @"OK");
        }
        else
        {   
            [[AMUtilities sharedUtilities] saveMarketCard:self.amMarketCardInfo];
            displayAlert(nil, [NSString stringWithFormat:@"Your card has been successfully added"], nil, @"OK");
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:AMMarketCardSaveSuccessNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tapOnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == UIAlertViewTagDeleteConfirmation) {
        if (buttonIndex == 1) {
            [[AMUtilities sharedUtilities] deleteMarketCardByCode:self.amMarketCardInfo.mScanCode];
            [[NSNotificationCenter defaultCenter] postNotificationName:AMMarketCardSaveSuccessNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
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

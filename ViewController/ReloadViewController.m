//
//  ReloadViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 31/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "ReloadViewController.h"
#import "MIRadioButtonGroup.h"
#import "AAMixpanel.h"
#import "AddCCTableViewCell.h"
#import "AddCardWebViewController.h"
#import "GlobalGateWayResponse.h"
#import "DenominationWithBns.h"
#import "WSLAlertViewAutoDismiss.h"
#import "UIButton+BackgroundColor.h"
#import "CreditCardViewController.h"
#import "AddCreditCardViewViewController.h"
#import "MarketCardView.h"

typedef NS_ENUM(NSInteger, ReloadScreenActive) {
    ReloadScreenActiveSelectDenomination    = 0,
    ReloadScreenActiveSelectCreditCard      = 1,
    ReloadScreenActiveConfirmCreditCard     = 2
};

@interface ReloadViewController () {
GlobalGateWayResponse *gateWayResponse;
    MarketCardView *marketCard ;
    AMMarketCardInfo *amMarketCard;
}

@property (weak, nonatomic) IBOutlet UILabel *lblPrimaryText;
@property (weak, nonatomic) IBOutlet UILabel *lblCardType;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMMCContainer;

#pragma mark viewReloadAmount
@property (weak, nonatomic) IBOutlet UILabel *lblGetBonus;
@property (strong, nonatomic) NSMutableArray *radioReloadAmounts;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;


#pragma mark viewReloadPay
@property (weak, nonatomic) IBOutlet UIView *viewReloadPay;
@property (weak, nonatomic) IBOutlet UILabel *lblReloadPay;
@property (weak, nonatomic) IBOutlet UILabel *lblPayWith;
@property (weak, nonatomic) IBOutlet UILabel *lblAutoReload;
@property (weak, nonatomic) IBOutlet UITableView *tableCreditCards;
@property (weak, nonatomic) IBOutlet UIButton *btnRelaodPayCancel;

// TODO: is this really necessary, two separate arrays
//@property (strong, nonatomic) NSMutableArray *creditCards; // card details
@property (strong, nonatomic) NSMutableArray *creditCardViewControllers; // controllers

@property (strong, nonatomic) NSString  *selectedCardID;


@property (weak, nonatomic) IBOutlet UIView *viewReloadPayConfirm;
@property (weak, nonatomic) IBOutlet UILabel *lblReloadPayConfirm;
@property (weak, nonatomic) IBOutlet UILabel *lblPayingWith;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSelectedCard;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedCard;
@property (weak, nonatomic) IBOutlet UIButton *btnRelaodPayConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnRelaodPayConfirmCancel;
- (IBAction)tapOnConfirm:(id)sender;


@property (assign, nonatomic) ReloadScreenActive reloadScreenActive;

@property BOOL hasReloadCompleted;

@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet AmountButton *amount1Button;
@property (weak, nonatomic) IBOutlet AmountButton *amount2Button;
@property (weak, nonatomic) IBOutlet AmountButton *amount3Button;
@property (weak, nonatomic) IBOutlet UIScrollView *creditCardsScrollView;

- (IBAction)amount1Tapped:(id)sender;
- (IBAction)amount2Tapped:(id)sender;
- (IBAction)amount3Tapped:(id)sender;

@property (assign, nonatomic) int amount;
@property (strong, nonatomic) NSDecimalNumber *bonus;

@property (weak, nonatomic) IBOutlet AmountButton *reloadButton;
- (IBAction)reloadTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceHeader;
@property (weak, nonatomic) IBOutlet UILabel *reloadLabel;
@property (weak, nonatomic) IBOutlet UIView *reloadView;
@property (weak, nonatomic) IBOutlet UILabel *reloadAmountHeader;
@property (weak, nonatomic) IBOutlet UILabel *payWithHeader;
@property (weak, nonatomic) IBOutlet UILabel *comingSoonHeader;

@end

@implementation ReloadViewController

@synthesize reloadButton;
@synthesize reloadLabel;
@synthesize reloadView;
@synthesize balanceLabel;
@synthesize balanceHeader;
@synthesize reloadAmountHeader;
@synthesize payWithHeader;
@synthesize lblAutoReload;
@synthesize comingSoonHeader;

#pragma mark RadioButtonGroupDelegate


-(void) tweakAmountButton:(AmountButton *) button amount:(NSString *) amount bonus:(NSString *) bonus {
    UIColor *selectedAmountColor = [UIColor colorWithRed:96.0/255.0 green:185.0/255.0 blue:136.0/255.0 alpha:1.0];
    [button setFonts:[UIFont fontWithName:[self quicksandFontName] size:([XibHelper isIpad] ? 30 : 19)] secondFont: [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:([XibHelper isIpad] ? 16 : 9)]];
    [button setColors: [UIColor whiteColor] selectedBackgroundColor:selectedAmountColor];
    [self setCustomAmountButtonColors:button];
    [button setTexts:amount secondRowText:[[@"+ " stringByAppendingString:bonus] stringByAppendingString:@" bonus"]];
}

-(NSString *) intToCurrency:(int) amount {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter  setMaximumFractionDigits:0];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithInt:amount]]];
}

-(NSString *) floatToCurrency:(float) amount {
    // remove ".00" from the string
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount]]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
}

UIColor *selectedAmountColor;

- (void)viewDidLoad
{
    selectedAmountColor = [UIColor colorWithRed:96.0/255.0 green:185.0/255.0 blue:136.0/255.0 alpha:1.0];
    [self setTitle:@"RELOAD"];
    
    [super viewDidLoad];
    
    [self amount2Tapped:nil];
    
    self.view.userInteractionEnabled     = NO;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[AMUtilities sharedUtilities].balance.userBalance];
    self.balanceLabel.text = numberAsString;
    
    [self.balanceHeader setFont:[UIFont fontWithName:[self quicksandFontName] size:self.balanceHeader.font.pointSize]];
    [self.balanceHeader setFont:[UIFont fontWithName:[self quicksandBoldFontName] size:self.balanceHeader.font.pointSize] range:NSMakeRange(0, 6)];
    
    [self setCustomLabelColor: self.balanceLabel];
    [self setCustomTitleColor: self.balanceHeader];
    [self setCustomBodyTextColor:self.comingSoonHeader];
    [self.comingSoonHeader setFont:[UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:self.comingSoonHeader.font.pointSize]];
    [self setCustomLightBackgroundColor: self.backgroundView];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    

    [self setReloadLabel];

    [[AMUtilities    sharedUtilities]getReloadDenominations:^(id obj)
     {
         [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
         self.view.userInteractionEnabled     = YES;
         
         if (!obj) {
             [self.navigationController popViewControllerAnimated:YES];
             return;
         }
         
         //Do any additional setup after loading the view from its nib.
         //GetBalanceResponse *balance = [AMUtilities sharedUtilities].balance;
         
         self.radioReloadAmounts = [[NSMutableArray alloc]init];
         self.lblGetBonus.text = @"";
         
         //[self loadCreditDebitCards:[[AMUtilities sharedUtilities] getCreditCards]];
         
         DenominationWithBns *amountAndBonus = (DenominationWithBns *) [[AMUtilities sharedUtilities].loyalityArray objectAtIndex:0];
         
         [self tweakAmountButton:self.amount1Button amount:[self intToCurrency:amountAndBonus.denominAmount] bonus:[self floatToCurrency:amountAndBonus.bouns]];
         [self.amount1Button setSums:[[NSDecimalNumber alloc] initWithInt:amountAndBonus.denominAmount] bonus: [[NSDecimalNumber alloc] initWithFloat:amountAndBonus.bouns]];
         
         amountAndBonus = (DenominationWithBns *) [[AMUtilities sharedUtilities].loyalityArray objectAtIndex:1];
         [self tweakAmountButton:self.amount2Button amount:[self intToCurrency:((DenominationWithBns *) [[AMUtilities sharedUtilities].loyalityArray objectAtIndex:1]).denominAmount] bonus:[self floatToCurrency:((DenominationWithBns *) [[AMUtilities sharedUtilities].loyalityArray objectAtIndex:1]).bouns]];
         [self.amount2Button setSums:[[NSDecimalNumber alloc] initWithInt:amountAndBonus.denominAmount] bonus: [[NSDecimalNumber alloc] initWithFloat:amountAndBonus.bouns]];
         
         amountAndBonus = (DenominationWithBns *) [[AMUtilities sharedUtilities].loyalityArray objectAtIndex:2];
         [self tweakAmountButton:self.amount3Button amount:[self intToCurrency:amountAndBonus.denominAmount] bonus:[self floatToCurrency:amountAndBonus.bouns]];
         [self.amount3Button setSums:[[NSDecimalNumber alloc] initWithInt:amountAndBonus.denominAmount] bonus: [[NSDecimalNumber alloc] initWithFloat:amountAndBonus.bouns]];
         
         
         [self amount2Tapped:nil];
         
     }];
    }

-(IBAction) cardTapped:(id) sender {
    int tag = (int) ((UIView *) [((UIButton *) sender) superview]).tag;
    NSLog(@"Card %d tapped", tag);
    if (tag == (self.creditCardsScrollView.subviews.count - 1)) {
        // add
        [self getURlForLoadingWithValue:self.amount];
    }
    else {
        //existing card selected
        self.selectedCardID = ((AMCreditCardInfo *)[[[AMUtilities sharedUtilities] getCreditCards] objectAtIndex:tag]).cardID;
        NSLog(@"Saving selected card id %@", self.selectedCardID);
        for (CreditCardViewController *v in self.creditCardViewControllers) {
            if ([v.cardID isEqualToString:self.selectedCardID]) {
                [v selectCard];
            }
            else {
                [v deselectCard];
            }
        }
        [self setReloadLabel];
    }
}


-(void) requestReload {

    ChargeStoredCardRequest *charges = [[ChargeStoredCardRequest alloc] init];
    // Values set
    charges.cardID = self.selectedCardID;
    NSLog(@"selected card Id: %@", self.selectedCardID);
    charges.reloadAmount = self.amount;
    // Request
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"cardID", @"reloadAmount"]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[ChargeStoredCardRequest class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodAny];
    // Response
    // Left out for brevity
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[ResultResponse class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"success" : @"success"}];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager postObject:charges path:kPathChargeStoredCard parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    //Mixpanel
                    [AAMixpanel reloadSuccess:@"One Time Reload" amount:[@(self.amount) stringValue]];
                    NSLog(@"Mixpanel: ReloadViewController.reload %@", [@(self.amount) stringValue] );
                    
                    [[AMUtilities sharedUtilities] getUserbalance:^(id obj){
                        // [[AMUtilities sharedUtilities] getServerUserbalance];
                        displayAlertWithMessage(@"Your reload was successful!");
                        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];

                    //  [[AMUtilities sharedUtilities] getServerUserbalance];
                    // displayAlertWithMessage(@"Your reload was successful!");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadHistory" object:nil];
                    self.hasReloadCompleted = YES;
                }
                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                    if(!operation.HTTPRequestOperation.response.statusCode )
                    {
                        [AAMixpanel reloadFailure:@"One Time Reload" amount:[@(self.amount) stringValue] errortype:@"Network Error" witherrorCode:nil];
                        displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                    }
                    else{
                        [AAMixpanel reloadFailure:@"One Time Reload" amount:[@(self.amount) stringValue] errortype:@"Server Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                        displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                    }
                }
     ];
}


-(void) disableReload {
    [self.reloadButton setEnabled:NO];
    
    [self.reloadButton setTexts: @"RELOAD" secondRowText:@"Please select amount and card!"];
    [self.reloadButton setSums: (NSDecimalNumber *) [NSDecimalNumber numberWithDouble:1.0] bonus: (NSDecimalNumber *) [NSDecimalNumber numberWithDouble:1.0]]; // show bonus row ;)
    [self.reloadButton setFonts:[UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:24] secondFont: [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:13]];
    [self.reloadButton setColors: [UIColor whiteColor] selectedBackgroundColor:selectedAmountColor];
    [self setCustomAmountButtonColors: self.reloadButton];
    self.reloadButton.alpha=0.66;
    [self.reloadButton select];
}

-(void) enableReload {
    [self.reloadButton setEnabled:YES];
    
    NSString *bonusRow = [[@"+ " stringByAppendingString:[self floatToCurrency:[self.bonus floatValue]]] stringByAppendingString:@" bonus"];
    [self.reloadButton setTexts: [NSString stringWithFormat:@"RELOAD %@", [self intToCurrency:self.amount]] secondRowText:bonusRow];
    [self.reloadButton setFonts:[UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:24] secondFont: [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:13]];
    [self.reloadButton setColors: [UIColor whiteColor] selectedBackgroundColor:selectedAmountColor];
    [self.reloadButton setSums: (NSDecimalNumber *) [NSDecimalNumber numberWithInt:self.amount] bonus: self.bonus];
    [self setCustomAmountButtonColors: self.reloadButton];
    self.reloadButton.alpha=1.0;
    [self.reloadButton select];

}

- (void)loadCreditDebitCards  {
    

    float height = 92.0f, width= 134.0f;
    
    if ([XibHelper isIpad]) {
        height = 165.0;
        width = 271.0;
        NSLog(@"iPad height set");
    }

    self.creditCardViewControllers = [[NSMutableArray alloc] init];
    
    for (UIView *v in self.creditCardsScrollView.subviews) {
        [v removeFromSuperview];
    }

    //[self disableReload];
    
    int i=0;
    if ([[AMUtilities sharedUtilities] getCreditCards].count > 0) {
        for (i = 0; i < [[AMUtilities sharedUtilities] getCreditCards].count; i++) {
            
            BOOL selected = NO;
            if ((self.selectedCardID != nil && [((AMCreditCardInfo *) [[[AMUtilities sharedUtilities] getCreditCards] objectAtIndex:i]).cardID isEqualToString:self.selectedCardID]) ||
                [[AMUtilities sharedUtilities] getCreditCards].count == 1) {
                NSLog(@"Marking card selected with id %@", self.selectedCardID);
                selected = YES;
                self.selectedCardID = ((AMCreditCardInfo *)[[[AMUtilities sharedUtilities] getCreditCards] objectAtIndex:i]).cardID;
            }
 
            CreditCardViewController *creditCardViewController = [[CreditCardViewController alloc] initWithNibName:[XibHelper XibFileName:@"CreditCardView"] bundle:nil selected: selected];
            
            [self.creditCardViewControllers addObject:creditCardViewController];
            creditCardViewController.delegate = self;
            creditCardViewController.view.frame = CGRectMake(i * width, 0, width, height);
            creditCardViewController.view.tag = i;
            [self.creditCardsScrollView addSubview:creditCardViewController.view];
            [creditCardViewController loadCreditCardDetail:[[[AMUtilities sharedUtilities] getCreditCards] objectAtIndex:i]];
            NSLog(@"Selected card id: %@", self.selectedCardID);
        }
    }
    
    [self setReloadLabel];

    // add the plus sign image
    AddCreditCardViewViewController *addCreditCardView = [[AddCreditCardViewViewController alloc] initWithNibName:[XibHelper XibFileName:@"AddCreditCardViewViewController"] bundle:nil];
    
    addCreditCardView.view.frame = CGRectMake(i * width, 0, width, height);
    addCreditCardView.view.tag = i;
    [self.creditCardsScrollView addSubview:addCreditCardView.view];
    i++;
    [self.creditCardsScrollView setContentSize:CGSizeMake(width * i, height)];
    
    return;
}

- (IBAction)deleteButtonPressed:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Are you sure you'd like to delete this card?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"KEEP"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   
                                               }];
                                            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"DELETE"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action){
                                                       int tag = (int) ((UIView *) [((UIButton *) sender) superview]).tag;
                                                       NSLog(@"Delete tapped, tag %d, card id: %@", tag, ((CreditCardViewController *) [self.creditCardViewControllers objectAtIndex:tag]).cardID);
                                                       
                                                       [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
                                                       
                                                       AMCreditCardInfo *cardToDelete = [[[AMUtilities sharedUtilities] getCreditCards] objectAtIndex:tag];
                                                       [[AMUtilities sharedUtilities]deleteCreditCardByCardId:cardToDelete.cardID withCompletion:^(id obj)
                                                        {
                                                            [[AMUtilities sharedUtilities] getServerStoredCreditCards:^(id obj)
                                                             {
                                                                 
                                                                 //self.creditCards = [[[AMUtilities sharedUtilities] getCreditCards] mutableCopy];
                                                                 //[self.creditCards removeObjectAtIndex:tag];
                                                                 //[self.creditCardViewControllers removeObjectAtIndex:tag];
                                                                 [self loadCreditDebitCards];
                                                                 [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                                                                 
                                                             }];
                                                        }];
                                                   }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)getBalanceNotification:(id)noti{
    NSNumber *respose = [noti object];
    if ([respose boolValue]) {
        GetBalanceResponse *balance = [AMUtilities sharedUtilities].balance;
        
        [marketCard loadMarketCardDetail:amMarketCard balance:balance.userBalance];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    self.hasReloadCompleted = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    if (app.shouldSaveCard==YES)
    {
        [self showAlertviewToSaveCard];
    }
    
    [super viewWillAppear:animated];
    self.reloadScreenActive  = ReloadScreenActiveSelectDenomination;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBalanceNotification:)
                                                 name:AMGetBalanceSuccessNotification object:nil];
    
    [self tallerGreenGradient:self.topBackgroundView];
    [self tallerCustomGradient: self.topBackgroundView]; // toimiiko kontinental
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [[AMUtilities sharedUtilities] getServerUserbalance];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
    [self setCustomReloadAmountHeaderLabelColor:self.reloadAmountHeader];
    [self setCustomReloadAmountHeaderLabelColor:self.payWithHeader];
    [self setCustomReloadAmountHeaderLabelColor:self.lblAutoReload];
    [self setCustomSecondaryLabelColor: self.comingSoonHeader];
    [self disableReload];
    [self setReloadLabel];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AMUtilities sharedUtilities] getServerStoredCreditCards:^(id obj)
     {
         [[AMUtilities sharedUtilities] getUserbalance:^(id obj){
             
             // TODO: don't duplicate this formatting code
             NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
             [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
             NSString *numberAsString = [numberFormatter stringFromNumber:[AMUtilities sharedUtilities].balance.userBalance];
             self.balanceLabel.text = numberAsString;
             [self loadCreditDebitCards];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];
     }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)remoVeAlert
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)tapOnConfirm:(id)sender {
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    ChargeStoredCardRequest *charges = [[ChargeStoredCardRequest alloc] init];
    // Values set
    charges.cardID = self.selectedCardID;
    charges.reloadAmount = self.amount;
    // Request
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"cardID", @"reloadAmount"]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[ChargeStoredCardRequest class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodAny];
    // Response
    // Left out for brevity
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[ResultResponse class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"success" : @"success"}];
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager postObject:charges path:kPathChargeStoredCard parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    //Mixpanel
                    [AAMixpanel reloadSuccess:@"One Time Reload" amount:[@(self.amount) stringValue]];
                    
                    [[AMUtilities sharedUtilities] getUserbalance:^(id obj){
                       // [[AMUtilities sharedUtilities] getServerUserbalance];
                        displayAlertWithMessage(@"Your reload was successful!");
                        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    
                    }];

                  //  [[AMUtilities sharedUtilities] getServerUserbalance];
                   // displayAlertWithMessage(@"Your reload was successful!");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadHistory" object:nil];
                    self.hasReloadCompleted = YES;
                }
                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    if(!operation.HTTPRequestOperation.response.statusCode )
                    {                       [AAMixpanel reloadFailure:@"One Time Reload" amount:[@(self.amount) stringValue] errortype:@"Network Error" witherrorCode:nil];
                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                                           }
                    else{
                        [AAMixpanel reloadFailure:@"One Time Reload" amount:[@(self.amount) stringValue] errortype:@"Server Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                        displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                     
                    }
                    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                }
     ];
    
    //
    
}
-(void)getURlForLoadingWithValue:(int) value
{
    
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    
    RKObjectMapping *transactionMapping = [RKObjectMapping mappingForClass:[GlobalGateWayResponse class]];
    [transactionMapping addAttributeMappingsFromDictionary:@{
                                                             @"x_url" : @"x_url",
                                                             @"x_login" : @"x_login",
                                                             @"x_show_form" : @"x_show_form",
                                                             @"x_fp_sequence" : @"x_fp_sequence",
                                                             @"x_fp_hash" : @"x_fp_hash",
                                                             @"x_amount" : @"x_amount",
                                                             @"x_currency_code" : @"x_currency_code",
                                                             @"x_test_request" : @"x_test_request",
                                                             @"x_relay_response" : @"x_relay_response",
                                                             @"donation_prompt" : @"donation_prompt",
                                                             @"button_code" : @"button_code",
                                                             @"mmc_operatorid" : @"mmc_operatorid",
                                                             @"mmc_marketuserid" : @"mmc_marketuserid",
                                                             @"mmc_transactionid" : @"mmc_transactionid",
                                                             @"mmc_requesthost" : @"mmc_requesthost",
                                                             @"mmc_save_card_info" : @"mmc_save_card_info",
                                                             @"x_fp_timestamp" : @"x_fp_timestamp",
                                                             
                                                             }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:transactionMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager addResponseDescriptor:responseDescriptor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    [manager getObject:nil path: [self getCustomPath:[NSString stringWithFormat:@"%@/%d",kPathGetGlobalGetWay, value]]
            parameters:nil
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   if ([mappingResult array].count > 0) {
                       gateWayResponse = [[mappingResult array]objectAtIndex:0];
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                       AddCardWebViewController *webViewAddCard = [[AddCardWebViewController alloc]initWithNibName:@"AddCardWebViewController" bundle:nil];
                       webViewAddCard.parenntViewController =@"Reload";
                       webViewAddCard.gateWay = gateWayResponse;
                       [self.navigationController pushViewController:webViewAddCard animated:YES];
                   }
                   else{
                       if(!operation.HTTPRequestOperation.response.statusCode )
                       {                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                       }
                       else{
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                       }
                   }
               }
               failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   
                   if (!([AMUtilities sharedUtilities].isInternetWorking))
                   {
                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                   }
                   else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                   {
                       ;
                   }
                   else
                   {
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }
               }];

}

-(void)showAlertviewToSaveCard
{
    [[AMUtilities sharedUtilities] getServerUserbalance];

    GetBalanceResponse *balance = [AMUtilities sharedUtilities].balance;

    [marketCard loadMarketCardDetail:amMarketCard balance:balance.userBalance];
                                                                   
    [[AMUtilities sharedUtilities] getUserbalance:^(id obj){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *numberAsString = [numberFormatter stringFromNumber:[AMUtilities sharedUtilities].balance.userBalance];
        self.balanceLabel.text = numberAsString;
        WSLAlertViewAutoDismiss *alertview = [[WSLAlertViewAutoDismiss alloc]initWithTitle:@"Please Confirm" message:@"Do you wish to store secure payment information for future use?" delegate:self cancelButtonTitle:@"Save"otherButtonTitles:@"No Thanks", nil];
        [alertview show];
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        app.shouldSaveCard = YES;
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

    app.shouldSaveCard = NO;

   
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[AMUtilities sharedUtilities] deleteLastSavedStoredCard:^(id obj)
             {
                 [[AMUtilities sharedUtilities] getServerStoredCreditCards:^(id obj)
                  {
                      //  [self saveCreditCardNotification];
                      [self loadCreditDebitCards];
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      [alertView dismissWithClickedButtonIndex:1 animated:YES];
                      
                      
                  }];
                 
             }];
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
            
            
        }
        if (buttonIndex == 0) {
            [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];

            [[AMUtilities sharedUtilities] getServerStoredCreditCards:^(id obj)
             {

                 //[self saveCreditCardNotification];
                 [alertView dismissWithClickedButtonIndex:0 animated:YES];
                 //self.creditCards = [[[AMUtilities sharedUtilities] getCreditCards] mutableCopy];


                 [self.tableCreditCards reloadData];
                 [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

             }];
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
            
        }
    
    
}


- (IBAction) amount1Tapped:(id)sender {
    [self.amount1Button select];
    [self.amount2Button deselect];
    [self.amount3Button deselect];
    self.amount = [[self.amount1Button getAmount] shortValue];
    self.bonus = [self.amount1Button getBonus];
   [self setReloadLabel];
}

- (IBAction) amount2Tapped:(id)sender {
    [self.amount1Button deselect];
    [self.amount2Button select];
    [self.amount3Button deselect];
    self.amount = [[self.amount2Button getAmount] shortValue];
    self.bonus = [self.amount2Button getBonus];
    [self setReloadLabel];
}

- (IBAction) amount3Tapped:(id)sender {
    [self.amount1Button deselect];
    [self.amount2Button deselect];
    [self.amount3Button select];
    self.amount = [[self.amount3Button getAmount] shortValue];
    self.bonus = [self.amount3Button getBonus];
    [self setReloadLabel];
}

-(void) setReloadLabel {
    BOOL aCardIsSelected = NO;
    if (self.creditCardViewControllers) {
        NSLog(@"setReloadLabel: number of cards: %lu", (unsigned long) self.creditCardViewControllers.count);
        for (CreditCardViewController *v in self.creditCardViewControllers) {
            NSLog(@"setReloadLabel: comparing %@ and %@", self.selectedCardID, v.cardID);
            if ([v.cardID isEqualToString:self.selectedCardID]) {
                aCardIsSelected = YES;
                break;
            }
        }
    }
    if (aCardIsSelected) {
        [self enableReload];
    }
    else {
        [self disableReload];
    }
    
}

- (IBAction)reloadTapped:(id)sender {
    [self requestReload];
}
@end

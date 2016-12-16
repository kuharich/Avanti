//
//  MyAccountViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 08/05/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "MyAccountViewController.h"
#import "PersonalInfoViewController.h"
#import "ResetViewController.h"
#import "LGAlertView.h"
#import "AAMixpanel.h"
@interface MyAccountViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableAccount;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;

@property(nonatomic, strong) NSArray *arrItems;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
- (IBAction)tapOnDone:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)tapOnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;


@property (nonatomic, strong) UISwitch *switchPasswordLock;
@property (nonatomic, strong) UISwitch *switchMessages;
@property (nonatomic, strong) UISwitch *switchReceipts;
@property (weak, nonatomic) IBOutlet UITextView *termsAndConditionsText;
@end

@implementation MyAccountViewController


//check if the switch is currently ON or OFF
- (void) passwordLockSwitchIsChanged:(UISwitch *)paramSender{
    if ([paramSender isOn]){
        NSLog(@"The switch is turned on.");
    } else {
        NSLog(@"The switch is turned off.");
    }
    [[NSUserDefaults standardUserDefaults] setBool:[paramSender isOn] forKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
}

- (void) messagesSwitchIsChanged:(UISwitch *)paramSender{
    if ([paramSender isOn]){
        NSLog(@"The switch is turned on.");
    } else {
        NSLog(@"The switch is turned off.");
    }
     [[NSUserDefaults standardUserDefaults] setBool:[paramSender isOn] forKey:NSUSERDEFAULT_SET_NOTI_MESSAGES];
}

- (void) receiptsSwitchIsChanged:(UISwitch *)paramSender{
    if ([paramSender isOn]){
        NSLog(@"The switch is turned on.");
    } else {
        NSLog(@"The switch is turned off.");
    }
     [[NSUserDefaults standardUserDefaults] setBool:[paramSender isOn] forKey:NSUSERDEFAULT_SET_NOTI_RECEIPTS];
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

    if (app.tcAlertShow == YES)
    {
        [ self shoWTcAlert];
        app.tcAlertShow = NO;

    }
    
    [self orangeGradient];
    
    self.navigationController.navigationBar.translucent = NO;
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
}


- (void)viewDidLoad {
    [super viewDidLoad];


    [self setTitle:@"MY ACCOUNT"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
    self.arrItems = [NSArray arrayWithObjects:@"Edit Personal Info",@"Reset Password", @"Reset PIN", @"Password Lock",  nil];

    [self.tableAccount setTableFooterView:self.viewFooter];
    
   // CGRect myFrame = CGRectMake(0.0f, 0.0f, 51.0f, 25.0f);
    
    //create and initialize the slider
    //attach action method to the switch when the value changes
    self.switchPasswordLock = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.switchPasswordLock addTarget:self action:@selector(passwordLockSwitchIsChanged:) forControlEvents:UIControlEventValueChanged];
    BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
    [self.switchPasswordLock setOn:isOn animated:YES];
    
    self.switchMessages = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.switchMessages addTarget:self action:@selector(messagesSwitchIsChanged:) forControlEvents:UIControlEventValueChanged];
    isOn = [[NSUserDefaults standardUserDefaults] boolForKey:NSUSERDEFAULT_SET_NOTI_MESSAGES];
    [self.switchMessages setOn:isOn animated:YES];
    
    self.switchReceipts = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.switchReceipts addTarget:self action:@selector(receiptsSwitchIsChanged:) forControlEvents:UIControlEventValueChanged];
    isOn = [[NSUserDefaults standardUserDefaults] boolForKey:NSUSERDEFAULT_SET_NOTI_RECEIPTS];
    [self.switchReceipts setOn:isOn animated:YES];
    
    [self setCustomRegularButtonTextColor:self.btnDone];
    [self setCustomRegularButtonBackgroundColor: self.btnDone];
    [self setCustomRegularButtonTextColor:self.btnCancel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"ACCOUNT MANAGEMENT";
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
//  Forv2
//    else if (section == 1) {
//        return 2;
//    }
    return 1;
}
/* code uncommited for v2.0
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"PUSH NOTIFICATIONS:";
    }
    return nil;
}
*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 20)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 25)];
    }
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.textLabel.textColor = color;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor whiteColor] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:DEFAULT_COLOR_THEME_TEXT_GRAY ForCell:cell]; //normal color
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"accountCellIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		[cell.textLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
		cell.textLabel.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;

        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = DEFAULT_COLOR_THEME_GREEN;
        cell.selectedBackgroundView = backgroundView;
        
        [self setCustomMenuItemSelectedColor: cell];

	}

	if (indexPath.section == 0) {
		//4 items
		cell.textLabel.text = [self.arrItems objectAtIndex:indexPath.row];
		if (indexPath.row < 3) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else {
			cell.accessoryView = self.switchPasswordLock;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
	}
	/* for v2.0
     else if (indexPath.section == 1) {
		//Notifications
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Messages";
			cell.accessoryView = self.switchMessages;
		}
		else {
			cell.textLabel.text = @"Receipts";
			cell.accessoryView = self.switchReceipts;
		}
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}*/
	else {
		//T&C's
		cell.textLabel.text = @"Terms of Service";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            //Edit personal info
            PersonalInfoViewController *detailViewController = [[PersonalInfoViewController alloc] initWithNibName:@"PersonalInfoViewController" bundle:nil];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        else if (indexPath.row == 1){
            //Reset PAssword
            ResetViewController *detailViewController = [[ResetViewController alloc] initWithNibName:@"ResetViewController" bundle:nil];
            [detailViewController setTitle:@"RESET PASSWORD"];
            [self.navigationController pushViewController:detailViewController animated:YES];
            
        }
        else if (indexPath.row == 2){
            //Reset PIN
            ResetViewController *detailViewController = [[ResetViewController alloc] initWithNibName:@"ResetViewController" bundle:nil];
            [detailViewController setTitle:@"RESET PIN"];
            [self.navigationController pushViewController:detailViewController animated:YES];
            
        }
        else{
            
           
                                 }
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        [self shoWTcAlert];
    }
    else{
        //Nothing
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)tapOnDone:(id)sender {
    self.btnDone.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[AppDelegate sharedDelegate] launchAvantiMarkets];
}

- (IBAction)tapOnCancel:(id)sender { // there is nothing to cancel, hiding this button
    [[AppDelegate sharedDelegate] openControllerAtIndexPath:[NSIndexPath indexPathForItem:MenuItemAVANTI_LOGO inSection:MenuItemSectionOthers]withBool:false];
}
inline static void addBorderInViewValue(UIView *myView,UIColor *textColor, UIColor *backgroudColor, CGFloat cornerRadius, CGFloat borderWidth)  {
    myView.layer.cornerRadius = cornerRadius;
    myView.layer.borderColor = [textColor CGColor];
    myView.layer.borderWidth = borderWidth;
    myView.layer.masksToBounds = YES;
}
-(void)shoWTcAlert
{
    addBorderInViewValue(self.button,DEFAULT_COLOR_THEME_LBLUE, nil, 1.0,1.0);

    NSURL *path = [[NSBundle mainBundle] URLForResource: @"TermsAndConditions" withExtension:@"rtf"];
    NSAttributedString *rtfString = [[NSAttributedString alloc]   initWithFileURL:path options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    self.termsAndConditionsText.attributedText = rtfString;
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate  ;
    app.tcAlert = [[LGAlertView alloc]initWithViewStyleWithTitle:@"BYNDL AMC, LLC Terms of Service" message:nil view:self.view1 buttonTitles:nil cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index)
                   {
                       
                       if (index ==0)//Accept
                       {
                           app.tcAlertShow = NO;

                       }
                     
                       
                   }
        cancelHandler:nil destructiveHandler:nil];
    [app.tcAlert setColorful:YES];

    [app.tcAlert showAnimated:YES completionHandler:nil];
      app.tcAlert.cancelOnTouch = NO;

}
-(IBAction)onClickOk:(id)sender
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate  ;
    [app.tcAlert dismissAnimated:YES completionHandler:nil];

}
- (IBAction)tapOnSignOut:(id)sender {
    //Mixpanel
    [AAMixpanel signOutSuccess];
    AppDelegate *a = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [AMUtilities sharedUtilities].balance=nil;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    a.localNoti = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMSignOutSuccessNotification object:nil];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_StoredEncryptedPass];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSStringFromClass([GetBalanceResponse class])];
    
    
    
    [[AppDelegate sharedDelegate] performSelector:@selector(launchLoginScreen) withObject:nil afterDelay:0.1];
}
@end

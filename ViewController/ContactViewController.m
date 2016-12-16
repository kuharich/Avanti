//
//  ContactViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "ContactViewController.h"
#import "COntactIssue.h"
#import "DidYouSeeThisVC.h"
#import "AAMixpanel.h"
#import "SFToken.h"

typedef NS_ENUM(NSInteger, ContactScreenActive) {
    ContactScreenActiveEntries          = 0,
    ContactScreenActiveDidYouSee        = 1,
    ContactScreenActiveConfirmation     = 2
};

@interface ContactViewController ()



@property (assign, nonatomic) ContactScreenActive screenActive;

@property (weak, nonatomic) IBOutlet UILabel *lblContactTitle;

@property (strong, nonatomic) NSMutableArray *arrCategory;
@property (strong, nonatomic) NSString *selectedCategory;

@property (strong, nonatomic) NSMutableArray *arrIssues;
@property (strong, nonatomic) NSString *selectedIssue;

@property (strong, nonatomic) NIDropDown *dropDownCategory;
@property (strong, nonatomic) NIDropDown *dropDownIssue;

@property (weak, nonatomic) IBOutlet UIButton *btnCategoty;
- (IBAction)tapOnCategory:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnIssue;
- (IBAction)tapOnIssue:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (assign, nonatomic) int selectedIndex;

- (IBAction)tapOnNext:(id)sender;
@property(strong,nonatomic)NSMutableDictionary *categoryDictionary;

@property (weak, nonatomic) IBOutlet UIView *viewDidYouSee;

@property (weak, nonatomic) IBOutlet UIView *viewConfirmation;
@property (weak, nonatomic) IBOutlet UIButton *btnDidYouSee1;
@property (weak, nonatomic) IBOutlet UIButton *btnDidYouSee2;
@property (weak, nonatomic) IBOutlet UIButton *btnDidYouSee3;
@property (weak, nonatomic) IBOutlet UIButton *btnSendRequest;
- (IBAction)tapOnSendRequest:(id)sender;
- (IBAction)tapOnDidYouSee:(id)sender;

@end

@implementation ContactViewController

#define Category1       @"Purchase Issue"
#define Category2       @"Item or Market Issue"
#define Category3       @"App Feature Issue"
#define Category4       @"Customer Account Issue"
#define PLACEHODER_TEXT @"Describe the issue"

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.txtDescription.text.length == 0){
        self.txtDescription.textColor = [UIColor lightGrayColor];
        self.txtDescription.text = PLACEHODER_TEXT;
        [self.txtDescription resignFirstResponder];
    }
    
    [self resignView:self.view];
}

- (void) niDropDown:(NIDropDown *)dropDown didSelectIndexPath:(NSIndexPath *)indexPath{
    if (dropDown == self.dropDownCategory) {
        self.selectedIndex= (int)indexPath.row;
        
        self.selectedCategory = [[((NSDictionary *)[self.arrCategory objectAtIndex:indexPath.row]) allKeys]objectAtIndex:0];
        AppDelegate *ap = (AppDelegate *) [UIApplication sharedApplication].delegate;
        ap.retrySFDCCount = 0;
        [self getSubIssueType];
        self.btnIssue.enabled = YES;
        self.dropDownCategory = nil;
        [self.btnIssue setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [self.btnIssue setTitle:@"Select Specific Issue" forState:UIControlStateNormal];
    }
    else{
        NSDictionary *di = [[self.categoryDictionary objectForKey:@"Category"]objectAtIndex:self.selectedIndex];
        
        self.selectedIssue = [[di objectForKey:[[di allKeys]objectAtIndex:0]] objectAtIndex:indexPath.row];
        self.dropDownIssue = nil;
        [self.btnIssue setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    [self.btnCategoty setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self setNextButtonActiveInactive];
}

- (void)setContactScreen:(ContactScreenActive)contactScreen {
    self.screenActive = contactScreen;
    
    switch (contactScreen) {
        case ContactScreenActiveDidYouSee:
            self.viewConfirmation.hidden = YES;
            self.viewDidYouSee.hidden = NO;
            [self.view bringSubviewToFront:self.viewDidYouSee];
            break;
            
        case ContactScreenActiveConfirmation:
            self.viewConfirmation.hidden = NO;
            self.viewDidYouSee.hidden = YES;
            [self.view bringSubviewToFront:self.viewConfirmation];
            break;
            
        default:
            self.viewConfirmation.hidden = YES;
            self.viewDidYouSee.hidden = YES;
            //[self.view sendSubviewToBack:self.viewDidYouSee];
            //[self.view sendSubviewToBack:self.viewConfirmation];
            break;
    }
}

- (void)backSideMenuButtonPressed:(id)sender {
    if (self.screenActive == ContactScreenActiveDidYouSee) {
        [self setContactScreen:ContactScreenActiveEntries];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setNextButtonActiveInactive{
    
    BOOL isActive = (self.selectedCategory.length > 0 && self.selectedIssue.length > 0);
    self.txtDescription.editable = isActive;
    self.txtDescription.selectable = isActive;
    
    self.btnNext.enabled = (isActive && ![self.txtDescription.text isEqualToString:PLACEHODER_TEXT]);
}
- (void)viewDidLoad {
    [self setTitle:@"CONTACT US"];
    
    [super viewDidLoad];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
    //    self.arrCategory = [NSArray arrayWithObjects:Category1, Category2, Category3, Category4, nil];
    self.selectedCategory = nil;
    self.selectedIssue = nil;
    self.btnIssue.enabled = NO;
    // Do any additional setup after loading the view from its nib.
    [self setContactScreen:ContactScreenActiveEntries];
    
    [self.btnDidYouSee1 setAttributedTitle:formattedText(self.btnDidYouSee1.titleLabel.text, 12) forState:UIControlStateNormal];
    [self.btnDidYouSee2 setAttributedTitle:formattedText(self.btnDidYouSee2.titleLabel.text, 12) forState:UIControlStateNormal];
    [self.btnDidYouSee3 setAttributedTitle:formattedText(self.btnDidYouSee3.titleLabel.text, 12) forState:UIControlStateNormal];
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    app.retrySFDCCount = 0;
    [self getIssueType];
    self.txtDescription.textColor = [UIColor lightGrayColor];
    [self setNextButtonActiveInactive];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [AAMixpanel pageView:@"Contact Us"];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)tapOnCategory:(id)sender {
    @try {
        if (self.dropDownIssue) {
            [self.dropDownIssue hideDropDown:sender];
            self.dropDownIssue = nil;
            [self.btnIssue setTitle:@"Select Specific Issue" forState:UIControlStateNormal];
        }
        
        if(self.dropDownCategory == nil) {
            
            self.dropDownCategory = [[NIDropDown alloc] showDropDown:self.btnCategoty height:self.arrCategory.count *50 list:[self getAllKeyFromArray: [self.categoryDictionary objectForKey:@"Category"]]
                                                             imgList:nil direction:@"down"];
            self.dropDownCategory.backgroundColor = [UIColor whiteColor];
            self.dropDownCategory.delegate = self;
            self.selectedIssue = nil;
        }
        else {
            [self.dropDownCategory hideDropDown:sender];
            self.dropDownCategory = nil;
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Exception in tapOnCategory:getIssueType %@",exception.reason);
    }
      }

- (IBAction)tapOnIssue:(id)sender {
    if (self.dropDownIssue) {
        [self.dropDownIssue hideDropDown:sender];
        self.dropDownIssue = nil;
        [self.btnIssue setTitle:@"Select Specific Issue" forState:UIControlStateNormal];
        return;
    }
    self.selectedIssue = nil;
    //    if ([self.selectedCategory isEqualToString:Category1]) {
    //        self.arrIssues = @[@"Kiosk screen frozen.  Can’t make a purchase",
    //                           @"Can’t scan an item on Kiosk or App",
    //                           @"Kiosk scans the wrong item",
    //                           @"Wrong price showing on Kiosk for scanned item",
    //                           @"I was charged the wrong price for an item",
    //                           @"Unintentional item purchase",
    //                           @"My purchase issue’s not listed here"];
    //        self.dropDownIssue = [[NIDropDown alloc] showDropDown:self.btnIssue height:200 list:self.arrIssues
    //                                                         imgList:nil direction:@"down"];
    //        self.dropDownIssue.delegate = self;
    //    }
    //    else if ([self.selectedCategory isEqualToString:Category2]){
    //        self.arrIssues = @[@"My purchased item quality was unacceptable",
    //                           @"I can't find an item at the Market",
    //                           @"I need nutritional information on an item",
    //                           @"There’s no pricing for my item",
    //                           @"My Item or Market issue’s not listed here"];
    //        self.dropDownIssue = [[NIDropDown alloc] showDropDown:self.btnIssue height:200 list:self.arrIssues
    //                                                      imgList:nil direction:@"down"];
    //        self.dropDownIssue.delegate = self;
    //    }
    //    else if ([self.selectedCategory isEqualToString:Category3]){
    //        self.arrIssues = @[@"App won’t scan an item",
    //                           @"I can’t make a purchase using the App",
    //                           @"I can’t upload funds to my Wallet",
    //                           @"My App issue isn’t listed here"];
    //        self.dropDownIssue = [[NIDropDown alloc] showDropDown:self.btnIssue height:200 list:self.arrIssues
    //                                                      imgList:nil direction:@"down"];
    //        self.dropDownIssue.delegate = self;
    //    }
    //    else if ([self.selectedCategory isEqualToString:Category4]){
    //        self.arrIssues = @[@"There was unauthorized use of my Market Account (Fraud)",
    //                           @"Incorrect funds were applied to my Wallet",
    //                           @"My refund has been applied or is incorrect",
    //                           @"My Customer Account issue isn’t listed here"];
    //        self.dropDownIssue = [[NIDropDown alloc] showDropDown:self.btnIssue height:200 list:self.arrIssues
    //                                                      imgList:nil direction:@"down"];
    //        self.dropDownIssue.delegate = self;
    //    }
    @try {
        NSDictionary *di = [[self.categoryDictionary objectForKey:@"Category"]objectAtIndex:self.selectedIndex];
        self.dropDownIssue = [[NIDropDown alloc] showDropDown:self.btnIssue height:((NSArray *)[self getAllValuesFromDictionary:di]).count*50 list:[self getAllValuesFromDictionary:di]
                                                      imgList:nil direction:@"down"];
        
        self.dropDownIssue.delegate = self;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   
    
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.textColor == [UIColor lightGrayColor]) {
        textView.text = @"";
        textView.textColor = [UIColor grayColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = PLACEHODER_TEXT;
        [textView resignFirstResponder];
    }
    [self setNextButtonActiveInactive];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(textView.text.length == 0){
            textView.textColor = [UIColor lightGrayColor];
            textView.text = PLACEHODER_TEXT;
            [textView resignFirstResponder];
        }
        return NO;
    }
    NSString *updateString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (updateString.length > 500) {
        return NO;
    }
    return YES;
}

- (IBAction)tapOnNext:(id)sender {
    
    if (self.selectedCategory && self.selectedIssue && self.txtDescription.text.length>0) {
        //next
        [self createIssue];
    }
    
}
- (IBAction)tapOnSendRequest:(id)sender {
    [self setContactScreen:ContactScreenActiveConfirmation];
}

- (IBAction)tapOnDidYouSee:(id)sender {
    //[self setContactScreen:ContactScreenActiveConfirmation];
}
//Added By Jyoti
-(void)getIssueType
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    AuthenticateResponse *authRes = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];

    //This should be use to get the AMSid and Operator lgged in user.
    // AuthenticateResponse *authRes = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Authorization"  value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];
    
    [manager.HTTPClient getPath:kGetIssueType
                     parameters:@{@"operatorAmsId":authRes.operatorId}
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         app.retrySFDCCount++;

         if (((NSArray *)responseObject).count)
         {
             self.arrCategory = [[NSMutableArray alloc]init];
             for (int i=0; i<((NSArray *)responseObject).count; i++)
             {
                 NSString *categoryString = [((NSArray *)responseObject) objectAtIndex:i];
                 [self.arrCategory addObject:[NSMutableDictionary dictionaryWithObject:@"" forKey:categoryString]];
                 
             }
             self.categoryDictionary = [NSMutableDictionary dictionaryWithObject:self.arrCategory forKey:@"Category"];
         }
         
         [MBProgressHUD hideHUDForView:[[AppDelegate sharedDelegate] window] animated:YES];
         
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            app.retrySFDCCount++;

                            //               self.arrCategory = [NSArray arrayWithObjects:@"App Features and Reliability", @"Market Product Selection and Prices", @"Market Product Quality", @"Market Appearance and Condition", @"Customer Support", nil];
                            
                            if (operation.response.statusCode == 401 && app.retrySFDCCount<3) {
 
                                
                                [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                                 {
                                     if ([obj isKindOfClass:[SFToken class]])
                                     {
                                         [self getIssueType];
                                     }
                                     else
                                     {
                                         NSLog(@"Failed to get Token");
                                         displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                         
                                     }
                                     
                                 }];
                                
                            }
                            
                            if (app.retrySFDCCount  >=4)
                            {
                                if (operation.error.code <0)
                            {
                                displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                            }
                            else{
                                displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                            }
                            }
                            else
                            {
                                if(operation.error.code <0)
                                {
                                    displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                                }
                            }
                            [MBProgressHUD hideHUDForView:[[AppDelegate sharedDelegate] window] animated:YES];
                            
                        }];
}
-(void)getSubIssueType
{
    AppDelegate *ap = (AppDelegate *) [UIApplication sharedApplication].delegate;
   
    NSDictionary *di = [[self.categoryDictionary objectForKey:@"Category"]objectAtIndex:self.selectedIndex];
    AuthenticateResponse *authRes = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];

    if (!([[di objectForKey:self.selectedCategory] isKindOfClass:[NSArray class]]) ){
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
        
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
        [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];
        
        [manager.HTTPClient getPath:kGetSubIssueType
                         parameters:@{@"category":self.selectedCategory,@"operatorAmsId":authRes.operatorId}
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                ap.retrySFDCCount ++;
                                self.arrIssues = [self.categoryDictionary objectForKey:@"Category"];
                                for (int i=0; i<self.arrIssues.count; i++)
                                {
                                    
                                    NSMutableDictionary *categoryDictionary = [self.arrIssues objectAtIndex:i];
                                    if ([[[categoryDictionary allKeys]objectAtIndex:0]isEqualToString:self.selectedCategory]) {
                                        [categoryDictionary setObject:responseObject forKey:self.selectedCategory];
                                        [self.arrIssues replaceObjectAtIndex:i withObject:categoryDictionary];
                                    }
                                }
                                [NSMutableDictionary dictionaryWithObject:self.arrIssues forKey:@"Category"];
                                
                                [MBProgressHUD hideHUDForView:[[AppDelegate sharedDelegate] window] animated:YES];
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                ap.retrySFDCCount ++;
                                //                           self.arrIssues = [NSArray arrayWithObjects:@"App Features and Reliability", @"Market Product Selection and Prices", @"Market Product Quality", @"Market Appearance and Condition", @"Customer Support", nil];
                                if (operation.response.statusCode == 401 && ap.retrySFDCCount<4) {
                                    
                                    [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                                     {
                                         if ([obj isKindOfClass:[SFToken class]])
                                         {
                                             [self getSubIssueType];
                                         }
                                         else
                                         {
                                             NSLog(@"Failed to get Token");
                                             displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                             
                                         }
                                         
                                     }];
                                    
                                }
                                else if(!operation.response.statusCode ) {
                                    displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                                    
                                }

                                else{
                                    displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                                }
                                [MBProgressHUD hideHUDForView:[[AppDelegate sharedDelegate] window] animated:YES];
                                
                            }];
        
        
    }
    
    
    
}

#pragma mark - CREATE issue
-(void)createIssue
{
    
    DidYouSeeThisVC *didYouSeeVC = [[DidYouSeeThisVC alloc] initWithNibName:@"DidYouSeeThisVC" bundle:nil];
    didYouSeeVC.issueType = self.selectedCategory;
    didYouSeeVC.subIssueType = self.selectedIssue;
    didYouSeeVC.textDescritption = self.txtDescription.text;
    [self.navigationController pushViewController:didYouSeeVC animated:YES];
    
}
-(NSArray *)getAllKeyFromArray:(NSArray *)arr
{
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    for (int i=0; i<arr.count; i++)
    {
        NSDictionary *di = [arr objectAtIndex:i];
        [arr1 addObject:[[di allKeys]objectAtIndex:0]];
    }
    return arr1;
}
-(id)getAllValuesFromDictionary:(NSDictionary *)dict
{
    return [dict objectForKey:[[dict allKeys ]objectAtIndex:0]];
}
@end

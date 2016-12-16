//
//  ContactViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "DidYouSeeThisVC.h"
#import "SupportArticleViewController.h"
#import "SuccessViewController.h"
#import "SupportArticleListResponse.h"
#import "SuccessViewController.h"
#import "AAMixpanel.h"
#import "SFToken.h"
typedef NS_ENUM(NSInteger, ContactScreenActive) {
    ContactScreenActiveEntries          = 0,
    ContactScreenActiveDidYouSee        = 1,
    ContactScreenActiveConfirmation     = 2
};

@interface DidYouSeeThisVC ()





@property (strong, nonatomic) NSArray *arrCategory;


@property (weak, nonatomic) IBOutlet UIView *viewDidYouSee;


@end

@implementation DidYouSeeThisVC

- (void)viewDidLoad
{
    [self setTitle:@"CONTACT US"];
    self.dataArray = @[@"Set up a My MarketCard account", @"Making a purchase at the market", @"Market Kiosk Services", @"Using the kiosk to Add Wallet Funds", @"Print and email a purchase receipt from the Kiosk", @"Getting help for Market questions and issues"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    app.retrySFDCCount = 0;
    [self getArticle];


 }
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    app.retrySFDCCount = 0;
    [AAMixpanel pageView:@"Did You See"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrCategory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setNumberOfLines:4];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    SupportArticleListResponse *responseArticle = [self.arrCategory objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = formattedText(responseArticle.Title, 14);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupportArticleViewController *supportArticleViewController = [[SupportArticleViewController alloc] initWithNibName:@"SupportArticleViewController" bundle:nil];
    supportArticleViewController.articleResponseObj = [self.arrCategory objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:supportArticleViewController animated:YES];
}
-(IBAction)onClickSend:(id)sender
{
    //check for Valid SFDC Account
   // [[AMUtilities sharedUtilities]checkAndCreateSFDC];
    //api/Case/CreateFeedback?consumerAmsId={consumerAmsId}&feedbackCategory={feedbackCategory}&feedbackDetails={feedbackDetails}
    AppDelegate *a = (AppDelegate *)  [UIApplication sharedApplication].delegate;
    a.retrySFDCCount = 0;
    [self createIssue];
}
-(void)createIssue
{
    AuthenticateResponse *authRes = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    NSLog(@"**************************");
    NSLog(@"CREATE ISSUE :");
    NSLog(@"*************************");
    // GET api/Case/Create?consumerAmsId={consumerAmsId}&requestCategory={requestCategory}&issueType={issueType}&issueDescription={issueDescription}
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];
    
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [manager getObject:nil path:kPathCreateIssue
            parameters:@{@"consumerAmsId": authRes.amsId, @"requestCategory":  self.issueType,@"issueType":self.subIssueType,@"issueDescription":self.textDescritption}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //Mixpanel
                   [AAMixpanel caseSuccess:self.issueType andissuetype:self.subIssueType];
                   //sucess
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   app.retrySFDCCount ++;

                   if ([mappingResult array].count > 0) {
                       self.arrCategory = mappingResult.firstObject;
                       SuccessViewController *didYouSeeVC = [[SuccessViewController alloc] initWithNibName:@"SuccessViewController" bundle:nil];
                       [self.navigationController pushViewController:didYouSeeVC animated:YES];
                       
                   }
               }
     
               failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   app.retrySFDCCount ++;

                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   if (operation.HTTPRequestOperation.response.statusCode == 401 && app.retrySFDCCount<4) {
                       
                       [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                        {
                            
                            if ([obj isKindOfClass:[SFToken class]])
                            {
                                [self createIssue];
                            }
                            else
                            {
                                NSLog(@"Failed to get Token");
                                displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                
                            }
                        }];
                       
                   }
                   else                                     if(!operation.HTTPRequestOperation.response.statusCode ) {

                       
                   
                       //Mixpanel
                       [AAMixpanel caseFailure:self.issueType andissuetype:self.subIssueType anderrortype:@"Network Error" errorCode:nil];
                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                   }
                   else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                   {
                       //Mixpanel
                       [AAMixpanel caseSuccess:self.issueType andissuetype:self.subIssueType];
                       NSLog(@"***** Case id= %@***** ",operation.HTTPRequestOperation.responseString);
                       SuccessViewController *didYouSeeVC = [[SuccessViewController alloc] initWithNibName:@"SuccessViewController" bundle:nil];
                       [self.navigationController pushViewController:didYouSeeVC animated:YES];
                       
                   }
                   else
                   {
                       //Mixpanel
                       [AAMixpanel caseFailure:self.issueType andissuetype:self.subIssueType anderrortype:@"Server Error" errorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }
                   
               }];
    

}

-(void)getArticle
{
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];

    RKObjectMapping *transactionMapping = [RKObjectMapping mappingForClass:[SupportArticleListResponse class]];
    [transactionMapping addAttributeMappingsFromDictionary:@{
                                                             @"id" : @"id",
                                                             @"KnowledgeArticleId" : @"KnowledgeArticleId",
                                                             @"ArticleNumber" : @"ArticleNumber",
                                                             @"Title" : @"Title",
                                                             @"Summary" : @"Summary",
                                                             @"Body_Content__c" : @"Body_Content__c",
                                                             @"Visible_in_Common_Issues__c" : @"Visible_in_Common_Issues__c",
                                                             @"Visible_in_Using_the_App__c" : @"Visible_in_Using_the_App__c",
                                                             @"Visible_in_Using_the_Market__c" : @"Visible_in_Using_the_Market__c",
                                                             @"IsVisibleInApp" : @"IsVisibleInApp",
                                                             @"IsVisibleInPkb" : @"IsVisibleInPkb",
                                                             }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:transactionMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];

    //[manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
   // app.retrySFDCCount ++;
    [manager getObject:nil path:KPathGetArticle
            parameters:@{@"listType":@"didyouseethis",@"keyword":@"",@"requestCategory":self.issueType,@"IssueType":self.subIssueType}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   app.retrySFDCCount ++;

                   if ([mappingResult array].count > 0) {
                       self.arrCategory = [mappingResult array];
                       [self.tableViewArticle reloadData];
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                   }
                   else{
//                       [self.tableViewArticle stopAnimating];
//                       self.lblNoRecords.text = HISTORY_NO_RECORD_ALERT_MESSAGE;
                       //displayAlertWithTitleMessage(HISTORY_NO_RECORD_ALERT_TITLE, HISTORY_NO_RECORD_ALERT_MESSAGE);
                   }
                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   app.retrySFDCCount ++;

                   if (operation.HTTPRequestOperation.response.statusCode == 401 && app.retrySFDCCount<4) {
                       
                       [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                        {
                            if ([obj isKindOfClass:[SFToken class]])
                            {
                                [self getArticle];
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
                   else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                   {
                       ;
                   }
                   else
                   {
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }   }
               
                   else
                   {
                       if(operation.error.code <0)
                       {
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       }
                   }
               
               }];

}


@end

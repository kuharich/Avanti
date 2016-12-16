//
//  ContactViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "HelpfulSearchViewController.h"
#import "SupportArticleViewController.h"
#import "SupportArticleListResponse.h"
#import "HelpfulArticleViewController.h"
#import "AAMixpanel.h"
#import "SFToken.h"

//typedef NS_ENUM(NSInteger, ContactScreenActive) {
//    ContactScreenActiveEntries          = 0,
//    ContactScreenActiveDidYouSee        = 1,
//    ContactScreenActiveConfirmation     = 2
//};

@interface HelpfulSearchViewController ()


@property (strong, nonatomic) NSArray *arrArticles;


@property (weak, nonatomic) IBOutlet UIView *viewDidYouSee;


//- (IBAction)tapOnSendRequest:(id)sender;
//- (IBAction)tapOnDidYouSee:(id)sender;

@end

@implementation HelpfulSearchViewController

- (void)viewDidLoad
{
    [self setTitle:self.headerTitle];
//    self.dataArray = @[@"Set up a My MarketCard account", @"Making a purchase at the market", @"Market Kiosk Services", @"Using the kiosk to Add Wallet Funds", @"Print and email a purchase receipt from the Kiosk", @"Getting help for Market questions and issues"];
  
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self getArticle];
 //   [self.arrArticles ]formattedTt(responseArticle.ResponseDetails, 14);
 }
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.headerTitle isEqualToString:@"USING THE MARKET"]) {
        [AAMixpanel pageView:@"Search - Using The Market"];
        
    } else if ([self.headerTitle isEqualToString:@"USING THE APP"]) {
        [AAMixpanel pageView:@"Search - Using The App"];
        
    }
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    app.retrySFDCCount = 0;
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrArticles count];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SupportArticleListResponse *responseArticle = [self.arrArticles objectAtIndex:indexPath.row];
    if (responseArticle.Title) {
        cell.textLabel.attributedText = formattedText(responseArticle.Title, 14);

    }
    else
        if (responseArticle.ResponseDetails)
        {
            cell.textLabel.attributedText = formattedTt(responseArticle.ResponseDetails, 14);

        }
        else cell.textLabel.attributedText =formattedTt(@"                     No result found.", 14);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupportArticleListResponse *responseArticle = [self.arrArticles objectAtIndex:indexPath.row];

      if (responseArticle.Title) {
    HelpfulArticleViewController *helpfulArticleViewController = [[HelpfulArticleViewController alloc] initWithNibName:@"HelpfulArticleViewController" bundle:nil];
    helpfulArticleViewController.articleResponseObj = [self.arrArticles objectAtIndex:indexPath.row];
    helpfulArticleViewController.title = self.headerTitle;
    helpfulArticleViewController.detailName = @"Search";

    [self.navigationController pushViewController:helpfulArticleViewController animated:YES];
      }
    else
    {
        ;
    }
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
                                                             @"ResponseDetails":@"ResponseDetails"
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

    NSString *list = nil;
    if ([self.title isEqualToString:@"USING THE MARKET"]) {
        list =@"HowToUsingTheMarket";
        
    } else if ([self.title isEqualToString:@"USING THE APP"]) {
         list =@"HowToUsingTheApp";
        
    } else if([self.title isEqualToString:@"COMMON ISSUES"]) {
       list =@"HowToCommonIssues";
        
    }
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

    self.searchText = [self.searchText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [manager addResponseDescriptor:responseDescriptor];
    [manager getObject:nil path:KPathGetArticle
            parameters:@{@"listType":list,@"keyword":self.searchText,@"requestCategory":@"",@"issueType":@""}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //Mixpanel
                   app.retrySFDCCount ++;

                   [AAMixpanel searchSuccess:self.headerTitle searchterm:self.searchText];
                   //sucess
                   if ([mappingResult array].count > 0) {
                       self.arrArticles = [mappingResult array];
                       [self.tableViewArticle reloadData];

                   }
                   else{
                       SupportArticleListResponse *responseArticle = [[SupportArticleListResponse alloc]init];
                       self.arrArticles = [[NSArray alloc]initWithObjects:responseArticle, nil];
                       [self.tableViewArticle reloadData];
                       
//                       [self.tableViewArticle stopAnimating];
//                       self.lblNoRecords.text = HISTORY_NO_RECORD_ALERT_MESSAGE;
                       //displayAlertWithTitleMessage(HISTORY_NO_RECORD_ALERT_TITLE, HISTORY_NO_RECORD_ALERT_MESSAGE);
                   }
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   app.retrySFDCCount ++;
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
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
                       if(!operation.HTTPRequestOperation.response.statusCode )
                       {
                           [AAMixpanel searchFailure:self.headerTitle searchterm:self.searchText errortype:@"Network Error" errorcode:nil];
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       }
                       else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                       {
                           [AAMixpanel searchSuccess:self.headerTitle searchterm:self.searchText];
                       }
                       else
                       {
                           [AAMixpanel searchFailure:self.headerTitle searchterm:self.searchText errortype:@"Server Error" errorcode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                           
                       }
                   }
                   else
                   {
                      
                       if(!operation.HTTPRequestOperation.response.statusCode )
                       {
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                             [AAMixpanel searchFailure:self.headerTitle searchterm:self.searchText errortype:@"Network Error" errorcode:nil];
                       }
//                        //(operation.HTTPRequestOperation.response.statusCode == 500)
//                    else   {
//                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
//                        
//                        [AAMixpanel searchFailure:self.headerTitle searchterm:self.searchText errortype:@"Server Error" errorcode:[NSString stringWithFormat:@"%ld",operation.HTTPRequestOperation.response.statusCode]];
//
//                       }
                   }
                   
               }];

}


@end

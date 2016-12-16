//
//  HelpDetailViewController.m
//  BYNDL Support
//
//  Created by Sanjay Morya on 16/04/15.
//  Copyright (c) 2015 Sanjay Morya. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "ArticleRatingViewController.h"
#import "SupportArticleListResponse.h"
#import "HelpfulArticleViewController.h"
#import "HelpfulSearchViewController.h"
#import "AAMixpanel.h"
#import "SFToken.h"

@interface HelpDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSearchText;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchBox;
@property (weak, nonatomic) IBOutlet UIButton *btnFind;

@end

@implementation HelpDetailViewController

@synthesize headerColor;

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
	[self setTitle:self.navigationTitle];
    [self loadArticles];
	if ([self.navigationTitle isEqualToString:@"USING THE MARKET"]) {
    }
	else if ([self.navigationTitle isEqualToString:@"USING THE APP"]) {
	}
	else if ([self.navigationTitle isEqualToString:@"COMMON ISSUES"]) {

		[self.btnFind setHidden:YES];
		[self.txtSearchBox setHidden:YES];
        [self.lblSearchText setHidden:YES];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.showTable
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:14.0]];
	}
	// WHY WAS THIS DISABLED: self.btnFind.enabled = NO;
	[self.showTable setBackgroundColor:[UIColor clearColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setCustomRegularButtonTextColor:self.btnFind];
    [self setCustomRegularButtonBackgroundColor: self.btnFind];
}

- (void)viewWillAppear:(BOOL)animated
{
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    self.txtSearchBox.leftView = leftView;
    self.txtSearchBox.leftViewMode = UITextFieldViewModeAlways;
    self.txtSearchBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    if ([self.navigationTitle isEqualToString:@"USING THE MARKET"]) {
        [AAMixpanel pageView:@"Using The Market"];
        
    } else if ([self.navigationTitle isEqualToString:@"USING THE APP"]) {
         [AAMixpanel pageView:@"Using The App"];
        
    } else if([self.navigationTitle isEqualToString:@"COMMON ISSUES"]) {
        [AAMixpanel pageView:@"Common Issues"];
        
    } else {
        // to be implemented
    }
    
    if (headerColor) {
        [self solidGradient:headerColor];
    }
    else {
        [self greenGradient];
    }
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
   
}

-(void)loadArticles
  {
      AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
      
      app.retrySFDCCount = 0;
      
      if ([self.navigationTitle isEqualToString:@"USING THE MARKET"]) {
          [self getArticle:@"HowToUsingTheMarket"];
          
      } else if ([self.navigationTitle isEqualToString:@"USING THE APP"]) {
          [self getArticle:@"HowToUsingTheApp"];
          
      } else if([self.navigationTitle isEqualToString:@"COMMON ISSUES"]) {
          [self getArticle:@"HowToCommonIssues"];
          
      } else {
          // to be implemented
      }

  }


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    updateString = [updateString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *cellIdentifier = @"CellIdentifier";

	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		[cell.textLabel setNumberOfLines:0];
		[cell setBackgroundColor:[UIColor clearColor]];
		[cell.textLabel setTextColor:[UIColor grayColor]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}

	SupportArticleListResponse *text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = formattedText(text.Title, 14);
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpfulArticleViewController *helpfulArticleViewController = [[HelpfulArticleViewController alloc] initWithNibName:@"HelpfulArticleViewController" bundle:nil];
    helpfulArticleViewController.articleResponseObj = [self.dataArray objectAtIndex:indexPath.row];
    helpfulArticleViewController.title = self.navigationTitle;
    helpfulArticleViewController.detailName = @"HelpDetail";
    [self.navigationController pushViewController:helpfulArticleViewController animated:YES];
    
//	if ([self.navigationTitle isEqualToString:@"USING THE MARKET"] && indexPath.row == 0) {
//		ArticleRatingViewController *article = [[ArticleRatingViewController alloc] initWithNibName:@"ArticleRatingViewController" bundle:nil];
//		[self.navigationController pushViewController:article animated:YES];
//	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)searchButonTapped:(id)sender {
    NSString *updateString =    [self.txtSearchBox.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (updateString.length)
    {
        [self.txtSearchBox resignFirstResponder];
        
        
        HelpfulSearchViewController *helpfulSearchViewController = [[HelpfulSearchViewController alloc]
                                                                    initWithNibName:@"HelpfulSearchViewController" bundle:nil];
        helpfulSearchViewController.searchText = self.txtSearchBox.text;
        helpfulSearchViewController.headerTitle = self.navigationTitle;
        [self.navigationController pushViewController:helpfulSearchViewController animated:YES];
    }
    
    
    
}

-(void)getArticle:(NSString *)listType
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
            parameters:@{@"listType":listType,@"keyword":@"",@"requestCategory":@"",@"IssueType":@""}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   app.retrySFDCCount ++;

                   if ([mappingResult array].count > 0) {
                       self.dataArray = [mappingResult array];
                       [self.showTable reloadData];

                       
                   }
                   else{
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
                                [self getArticle:listType];
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
                           
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                       {
                       ;
                       }
                       else
                       {
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                       }
                   }
                   else
                   {
                       if(!operation.HTTPRequestOperation.response.statusCode )
                           
                       {
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       }

                   // else
                         //   displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                                                          }
               }];
               
    
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end

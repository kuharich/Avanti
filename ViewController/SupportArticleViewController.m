//
//  ContactViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "SupportArticleViewController.h"
#import "SupportArticleListResponse.h"
#import "ArticleDetailsResponse.h"
#import "AAMixpanel.h"
#import "SFToken.h"

#define MIN_FONT 11.0;
#define MAX_FONT 19.0;
typedef NS_ENUM(NSInteger, ContactScreenActive) {
    ContactScreenActiveEntries          = 0,
    ContactScreenActiveDidYouSee        = 1,
    ContactScreenActiveConfirmation     = 2
};

@interface SupportArticleViewController ()
@property (strong, nonatomic) ArticleDetailsResponse *articleObject;

@end
@implementation SupportArticleViewController

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
- (void)viewDidLoad
{
    [self setTitle:@"CONTACT US"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    self.webView.delegate = self;
    
    [self getArticleDetail];
}
-(void)viewWillAppear:(BOOL)animated
{
    [AAMixpanel pageView:@"Article Details - Did You See"];
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    app.retrySFDCCount = 0;
}
-(void)getArticleDetail
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    RKObjectMapping *transactionMapping = [RKObjectMapping mappingForClass:[ArticleDetailsResponse class]];
    [transactionMapping addAttributeMappingsFromDictionary:@{
                                                             @"Title" : @"Title",
                                                             @"Body_Content__c" : @"Body_Content__c",
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
    
    [manager getObject:nil path:KPathGetArticleDescription
            parameters:@{@"knowledgeArticleId":self.articleResponseObj.KnowledgeArticleId}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   app.retrySFDCCount ++;
                   
                   if ([mappingResult array].count > 0) {
                       self.articleObject = [[mappingResult array]objectAtIndex:0];
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                      [self loadWebView];
                      // [self loadWebView1];

                       
                   }
                   else{
                       if(!operation.HTTPRequestOperation.response.statusCode )
                       {                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                           
                       }
                       else{
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                           
                       }                     //                       [self.tableViewArticle stopAnimating];
                       //                       self.lblNoRecords.text = HISTORY_NO_RECORD_ALERT_MESSAGE;
                   }
                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   app.retrySFDCCount ++;

                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   if (operation.HTTPRequestOperation.response.statusCode == 401 && app.retrySFDCCount<4) {
                       
                       [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                        {
                            
                            if ([obj isKindOfClass:[SFToken class]])
                            {
                                [self getArticleDetail];
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
                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                   }
                   else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                   {
                       ;
                   }
                   else
                   {
                       [[UIApplication sharedApplication] endIgnoringInteractionEvents];

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
               
               }];
}
-(void)loadWebView
{
        NSString *html = self.articleObject.Body_Content__c;
    self.articleTitle.text = self.articleObject.Title;
   // self.webView.scalesPageToFit = YES;
    

        [self.webView loadHTMLString:html baseURL:nil];
    
    
}
-(void)loadWebView1
{
    self.articleTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.articleTitle.numberOfLines = 0;
    self.articleTitle.text = self.articleObject.Title;

   self.txtViewArticleDtls.text= self.articleObject.Body_Content__c;
   
    UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeFontSize:)];
    [self.txtViewArticleDtls addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setDelegate:self];
    //[self.txtViewArticleDtls setUserInteractionEnabled:YES];
}
- (void)changeFontSize:(UIPinchGestureRecognizer *)gestureRecognizer {
    UITextView *textView = (UITextView *)gestureRecognizer.view;
    float yourFontSize = gestureRecognizer.scale * 14;
    if (yourFontSize < 9.0)//Textsize cannot be less than 9
    {
        return;
    }
    if (yourFontSize > 22.0)//Text size cannot be morethan 22
    {
        return;
    }
   
    textView.font = [UIFont fontWithName: @"AvenirLTStd-Medium" size:yourFontSize];
}

@end

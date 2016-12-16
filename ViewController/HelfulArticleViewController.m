//
//  ContactViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "HelpfulArticleViewController.h"
#import "SupportArticleListResponse.h"
#import "ArticleDetailsResponse.h"
#import "AAMixpanel.h"
#import "SFToken.h"

typedef NS_ENUM(NSInteger, ContactScreenActive) {
    ContactScreenActiveEntries          = 0,
    ContactScreenActiveDidYouSee        = 1,
    ContactScreenActiveConfirmation     = 2
};

@interface HelpfulArticleViewController ()
@property (strong, nonatomic) ArticleDetailsResponse *articleObject;

@end
@implementation HelpfulArticleViewController


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [self setTitle:self.title];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];

  //  [self.webView setScalesPageToFit:YES];
    self.webView.delegate = self;

}


-(void)viewWillAppear:(BOOL)animated
{   AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if([self.detailName isEqualToString: @"HelpDetail"])
    {
    if ([self.title isEqualToString:@"USING THE MARKET"]) {
        [AAMixpanel pageView:@"Article Details - Using The Market"];
        
    } else if ([self.title isEqualToString:@"USING THE APP"]) {
        [AAMixpanel pageView:@"Article Details - Using The App"];
        
    } else if([self.title isEqualToString:@"COMMON ISSUES"]) {
        [AAMixpanel pageView:@"Article Details - Common Issues"];
        
    } else {
        [AAMixpanel pageView:@"Article Details - Did You See"];
    }
    }
   else if([self.detailName isEqualToString: @"Search"])
    {
        if ([self.title isEqualToString:@"USING THE MARKET"]) {
            [AAMixpanel pageView:@"Article Details - Search - Using The Market"];
            
        } else if ([self.title isEqualToString:@"USING THE APP"]) {
            [AAMixpanel pageView:@"Article Details - Search - Using The App"];
            
        } else if([self.title isEqualToString:@"COMMON ISSUES"]) {
            [AAMixpanel pageView:@"Article Details - Common Issues"];
            
        } else {
            [AAMixpanel pageView:@"Article Details - Did You See"];
        }
    }
    app.retrySFDCCount = 0;
    [self getArticleDetail];
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
//    self.articleTitle.numberOfLines =0;
//    self.articleTitle.lineBreakMode = NSLineBreakByWordWrapping;
}
-(void)getArticleDetail
{
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
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    //[manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObject:nil path:KPathGetArticleDescription
            parameters:@{@"knowledgeArticleId":self.articleResponseObj.KnowledgeArticleId}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   app.retrySFDCCount ++;

                   if ([mappingResult array].count > 0) {
                       self.articleObject = [[mappingResult array]objectAtIndex:0];
                       [self loadWebView];
                       //[self loadWebView1];

                   }
                   else{
                       if (operation.error.code<0){
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                       }
                       else{
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                       }
                       //                       [self.tableViewArticle stopAnimating];
                       //                       self.lblNoRecords.text = HISTORY_NO_RECORD_ALERT_MESSAGE;
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
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }
                   }
                   else
                   {
                        if(!operation.HTTPRequestOperation.response.statusCode )
                       
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                       
                    //   else  displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }
               }];
}
-(void)loadWebView
{
        NSString *html = self.articleObject.Body_Content__c;

        [self.webView loadHTMLString:html baseURL:nil];
        self.articleTitle.text = self.articleObject.Title;
    self.webView.delegate = self;
    UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeFontSize:)];
   // [self.webView addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setDelegate:self];

}
-(void)loadWebView1
{
    self.txtViewArticleDtls.text= self.articleObject.Body_Content__c;
    self.articleTitle.numberOfLines = 0;

    self.articleTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.articleTitle.text = self.articleObject.Title;

     // [self.txtViewArticleDtls setUserInteractionEnabled:YES];
}
- (void)changeFontSize:(UIPinchGestureRecognizer *)gestureRecognizer {
    UIWebView *textView = (UIWebView *)gestureRecognizer.view;
    float yourFontSize = gestureRecognizer.scale * 14;
    if (yourFontSize < 9.0)//Textsize cannot be less than 9
    {
        return;
    }
    if (yourFontSize > 22.0)//Text size cannot be morethan 22
    {
        return;
    }
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",
                          yourFontSize];
    [textView stringByEvaluatingJavaScriptFromString:jsString];
}
-(void)viewWillDisappear:(BOOL)animated {
}

@end

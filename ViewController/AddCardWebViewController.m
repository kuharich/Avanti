//
//  AddCardWebViewController.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 7/13/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AddCardWebViewController.h"
#import "GlobalGateWayResponse.h"
#import "AMUtilities.h"

#import "AppDelegate.h"
#import "WSLAlertViewAutoDismiss.h"
#import "AAMixpanel.h"
@interface AddCardWebViewController ()
{
    BOOL shouldShowAlert;
}

@end

@implementation AddCardWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"RELOAD"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    NSURL *url = [NSURL URLWithString: self.gateWay.x_url];
    NSString *body = [NSString stringWithFormat: @"x_login=%@&x_show_form=%@&x_fp_sequence=%@&x_fp_hash=%@&x_amount=%@&x_currency_code=%@&x_test_request=%@&x_relay_response=%@&donation_prompt=%@&button_code=%@&mmc_operatorid=%@&mmc_marketuserid=%@&mmc_transactionid=%@&mmc_requesthost=%@&mmc_save_card_info=%@&x_fp_timestamp=%@",self.gateWay.x_login,self.gateWay.x_show_form,self.gateWay.x_fp_sequence,self.gateWay.x_fp_hash,self.gateWay.x_amount,self.gateWay.x_currency_code,self.gateWay.x_test_request ,self.gateWay.x_relay_response,self.gateWay.donation_prompt,self.gateWay.button_code,self.gateWay.mmc_operatorid,self.gateWay.mmc_marketuserid,self.gateWay.mmc_transactionid,self.gateWay.mmc_requesthost,self.gateWay.mmc_save_card_info,self.gateWay.x_fp_timestamp];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setTimeoutInterval:120];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
  //  NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self greenGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
    [self customGradient];
    self.webView.delegate = self;
    [self.webView loadRequest: request];
}
-(void)viewWillAppear:(BOOL)animated
{
    shouldShowAlert = NO;
    
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

        [self backSideMenuButtonPressed:nil];
        return NO;
    }

    NSRange rangeValue = [[request.mainDocumentURL absoluteString] rangeOfString:@"final_receipt" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0)
    {
        
        NSString *dollars = self.gateWay.x_amount;
        if ([self.gateWay.x_amount rangeOfString:@"."].location != NSNotFound) {
            dollars = [self.gateWay.x_amount componentsSeparatedByString: @"."][0];
        }
        [AAMixpanel reloadSuccess:@"One Time Reload" amount:dollars];
        NSLog(@"Mixpanel: AddCardWebViewController.reload %@", dollars);
        
        shouldShowAlert = YES;
        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        app.shouldSaveCard = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    rangeValue = [[request.mainDocumentURL absoluteString] rangeOfString:@"payment_completion" options:NSCaseInsensitiveSearch];

    if (rangeValue.length > 0)
    {
        [AAMixpanel reloadFailure:@"One Time Reload" amount:self.gateWay.x_amount  errortype:@"BAMS Error" witherrorCode:nil];

        shouldShowAlert = NO;
        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        app.shouldSaveCard = NO;
        [self.navigationController popViewControllerAnimated:YES];
        
        WSLAlertViewAutoDismiss* alert = [[WSLAlertViewAutoDismiss alloc] initWithTitle:@"Transaction failed"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles: nil];
        
        
        [alert show ];
        return NO;

        }
    return YES;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    WSLAlertViewAutoDismiss* alert;
    if (error.code == NSURLErrorTimedOut) {
        alert = [[WSLAlertViewAutoDismiss alloc] initWithTitle:@"Error occurred"
                                                                                message:@"A timeout has occurred. Please try again."
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles: nil];
        
    }
    else {
        alert = [[WSLAlertViewAutoDismiss alloc] initWithTitle:@"Error occurred"
                                                                                message:@"An error has occurred. Please try again."
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles: nil];

    }
    [alert show ];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
}


- (void)backSideMenuButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
     WSLAlertViewAutoDismiss* alert = [[WSLAlertViewAutoDismiss alloc] initWithTitle:@"Transaction Cancelled"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles: nil];

    [alert show ];


}



@end

//
//  SupportViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 31/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "SupportViewController.h"
#import "HelpfulViewController.h"
#import "ContactViewController.h"
#import "FeedbackViewController.h"
#import "ShowContactUsReponse.h"
#import "AAMixpanel.h"
#import "AMUtilities.h"

@interface SupportViewController ()
{
    ShowContactUsReponse *shouldShowResponse;
    NSLayoutConstraint *_myConstrain;
}


@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation SupportViewController

- (void)viewDidLoad {
    
    [self setTitle:@"SUPPORT"];
   
    [super viewDidLoad];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];

    self.webView.delegate = self;
    NSString *urlString = [self getCustomSupportUrl: SUPPORT_BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [AAMixpanel supportSectionViewed];
    [self greenGradient];
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    WSLAlertViewAutoDismiss *alert = [[WSLAlertViewAutoDismiss alloc] initWithTitle:@"Error occurred"
                                                   message:@"An error has occurred. Please try again."
                                                  delegate:self
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles: nil];
    
    [alert show ];
    NSLog(@"could not load page, caused by error: %@", error);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}


    



@end

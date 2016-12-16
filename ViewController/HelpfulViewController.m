//
//  HelpfulViewController.m
//  BYNDL Support
//
//  Created by Sanjay Morya on 16/04/15.
//  Copyright (c) 2015 Sanjay Morya. All rights reserved.
//

#import "HelpfulViewController.h"
#import "AAMixpanel.h"

@interface HelpfulViewController ()

@end

@implementation HelpfulViewController

@synthesize usingTheMarketButton;
@synthesize usingTheAppButton;
@synthesize commonIssuesButton;

- (void)viewDidLoad {

    [super viewDidLoad];
    [self setTitle:@"HELPFUL HOW TO'S"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self setCustomRegularButtonTextColor:self.usingTheMarketButton];
    [self setCustomRegularButtonTextColor:self.usingTheAppButton];
    [self setCustomRegularButtonTextColor:self.commonIssuesButton];
    [self setCustomRegularButtonBackgroundColor: self.usingTheMarketButton];
    [self setCustomRegularButtonBackgroundColor: self.usingTheAppButton];
    [self setCustomRegularButtonBackgroundColor: self.commonIssuesButton];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [AAMixpanel pageView:@"Helpful How To's"];
    [self greenGradient];
    [self customGradient];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
}

-(IBAction)usingTheMarket:(id)sender
{
    HelpDetailViewController *helpDetailViewController = [[HelpDetailViewController alloc] initWithNibName:@"HelpDetailViewController" bundle:nil];
    helpDetailViewController.headerColor = self.usingTheMarketButton.backgroundColor;
    [helpDetailViewController setNavigationTitle:@"USING THE MARKET"];
    [self.navigationController pushViewController:helpDetailViewController animated:YES];
}

-(IBAction)usingTheApp:(id)sender
{
    HelpDetailViewController *helpDetailViewController = [[HelpDetailViewController alloc] initWithNibName:@"HelpDetailViewController" bundle:nil];
    helpDetailViewController.headerColor = self.usingTheAppButton.backgroundColor;
    [helpDetailViewController setNavigationTitle:@"USING THE APP"];
    [self.navigationController pushViewController:helpDetailViewController animated:YES];
}

-(IBAction)commonIssues:(id)sender
{
    HelpDetailViewController *helpDetailViewController = [[HelpDetailViewController alloc] initWithNibName:@"HelpDetailViewController" bundle:nil];
    helpDetailViewController.headerColor = self.commonIssuesButton.backgroundColor;
    [helpDetailViewController setNavigationTitle:@"COMMON ISSUES"];
    [self.navigationController pushViewController:helpDetailViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

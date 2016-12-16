//
//  ContactViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "SuccessViewController.h"
#import "AAMixpanel.h"

typedef NS_ENUM(NSInteger, ContactScreenActive) {
    ContactScreenActiveEntries          = 0,
    ContactScreenActiveDidYouSee        = 1,
    ContactScreenActiveConfirmation     = 2
};

@interface SuccessViewController ()

@end
@implementation SuccessViewController


- (void)viewDidLoad
{
    [self setTitle:@"CONTACT US"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemNone];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [AAMixpanel pageView:@"Case registered : Success"];
}
- (void)backSideMenuButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)onClickDone:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}


@end

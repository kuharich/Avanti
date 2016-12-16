//
//  HelpfulViewController.h
//  BYNDL Support
//
//  Created by Sanjay Morya on 16/04/15.
//  Copyright (c) 2015 Sanjay Morya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDetailViewController.h"

@interface HelpfulViewController : AMViewController

-(IBAction)usingTheMarket:(id)sender;
-(IBAction)usingTheApp:(id)sender;
-(IBAction)commonIssues:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *usingTheMarketButton;

@property (weak, nonatomic) IBOutlet UIButton *usingTheAppButton;


@property (weak, nonatomic) IBOutlet UIButton *commonIssuesButton;
@end

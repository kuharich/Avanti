//
//  SignUpViewController.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 10/26/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "SignUpViewController.h"
#import "AAMixpanel.h"


@interface SignUpViewController ()


@property (weak, nonatomic) IBOutlet UILabel *existingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *howToLabel;
@property (weak, nonatomic) IBOutlet UILabel *notYeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *step1Label;
@property (weak, nonatomic) IBOutlet UILabel *step1TextLabel;
@property (weak, nonatomic) IBOutlet UILabel *step2Label;
@property (weak, nonatomic) IBOutlet UILabel *step2TextLabel;
@property (weak, nonatomic) IBOutlet UILabel *step3Label;
@property (weak, nonatomic) IBOutlet UILabel *step3TextLabel;

@end

@implementation SignUpViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [AAMixpanel notRegisteredDisplayed];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self.existingLabel sizeToFit];
    int fontSize = [XibHelper isIpad] ? 36.0 : 14.0;
    [self.existingLabel setFont:[UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:fontSize] range:NSMakeRange(24, 6)];
    [self setCustomBackgroundColor: self.imgBackgroundView];
    [self setInfoBoxLabelColor:self.existingLabel];
    [self setCustomLabelColor:self.step1Label];
    [self setCustomLabelColor:self.step1TextLabel];
    [self setCustomLabelColor:self.step2Label];
    [self setCustomLabelColor:self.step2TextLabel];
    [self setCustomLabelColor:self.step3Label];
    [self setCustomLabelColor:self.step3TextLabel];
    [self setCustomLabelColor:self.howToLabel];
    [self setCustomLabelColor:self.notYeatLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

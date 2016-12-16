//
//  AddCreditCardViewViewController.m
//  AvantiMarket
//
//  Created by Tero Jankko on 3/2/16.
//  Copyright © 2016 Byndl. All rights reserved.
//

#import "AddCreditCardViewViewController.h"

@interface AddCreditCardViewViewController ()


@end

@implementation AddCreditCardViewViewController

@synthesize btnCardArea;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnCardArea addTarget:self.delegate action:@selector(cardTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self setCustomButtonSecondaryTextColor:btnCardArea];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

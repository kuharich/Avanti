//
//  HelpFullHowToViewController.m
//  BYNDL Support
//
//  Created by Sanjay Morya on 16/04/15.
//  Copyright (c) 2015 Sanjay Morya. All rights reserved.
//

#import "HelpFullHowToViewController.h"

@interface HelpFullHowToViewController ()

@end

@implementation HelpFullHowToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self setTitle:@"HELPFUL HOW TO'S"];

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

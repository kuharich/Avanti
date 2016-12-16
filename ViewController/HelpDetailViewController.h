//
//  HelpDetailViewController.h
//  BYNDL Support
//
//  Created by Sanjay Morya on 16/04/15.
//  Copyright (c) 2015 Sanjay Morya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpFullHowToViewController.h"

@interface HelpDetailViewController : AMViewController<UITableViewDataSource,UITableViewDelegate>
{
//    IBOutlet UITableView *showTable;
}
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSString *navigationTitle;
@property(nonatomic,strong) IBOutlet UITableView *showTable;
@property(nonatomic,strong) UIColor *headerColor;
-(IBAction)searchButonTapped:(id)sender;

@end

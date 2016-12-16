//
//  ContactViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DidYouSeeThisVC : AMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString *issueType;
@property(nonatomic,strong)NSString *subIssueType;
@property(nonatomic,strong)NSString *textDescritption;
@property(nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong)IBOutlet UITableView *tableViewArticle;

-(IBAction)onClickSend:(id)sender;
@end

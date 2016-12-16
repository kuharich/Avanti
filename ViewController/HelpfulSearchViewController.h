//
//  ContactViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HelpfulSearchViewController : AMViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString *searchText;
@property(nonatomic,strong)NSString *headerTitle;
//@property(nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong)IBOutlet UITableView *tableViewArticle;
@property(nonatomic,strong)IBOutlet UITextView *txtViewArticleDtls;

//-(IBAction)onClickSend:(id)sender;
@end

//
//  AddCardViewController.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 7/10/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMViewController.h"

@interface AddCardViewController : AMViewController
@property (nonatomic, assign) NSString *parenntViewController;;
@property (nonatomic, weak) IBOutlet UITableView *tbl;;
//@property (nonatomic, weak) IBOutlet UIButton *btnReload20;;
//@property (nonatomic, weak) IBOutlet UIButton *btnReload50;;
-(void)setAvantiSide;
@end

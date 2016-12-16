//
//  MyProgressBGTableViewCell.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 1/4/16.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleProgressBar;
@interface MyProgressBGTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet CircleProgressBar *progressView;
//@property(nonatomic,strong)IBOutlet UILabel *lblText;
@property(nonatomic,strong)IBOutlet UILabel *lblDetailText;
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblDescription;

@end

//
//  FeedbackViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface FeedbackViewController : AMViewController <NIDropDownDelegate>
-(void)getFeedbackType;
@end

//
//  FirstLoginProfileViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 24/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UpdateProfileResponse;
@interface FirstLoginProfileViewController : AMViewController
{
    UpdateProfileResponse *profileResponse;

}
@property(nonatomic,strong)IBOutlet UIView *pinView;
@property(nonatomic,strong)IBOutlet UIView *view4Pin;

@end

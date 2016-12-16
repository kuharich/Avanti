//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;

@protocol NIDropDownDelegate
- (void) niDropDown:(NIDropDown *)dropDown didSelectIndexPath:(NSIndexPath *)indexPath;
@end


@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}

@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;

-(void)hideDropDown:(UIButton *)onButton;
- (id)showDropDown:(UIButton *)onButton height:(CGFloat )height list:(NSArray *)arr imgList:(NSArray *)imgArr direction:(NSString *)direction;

@end

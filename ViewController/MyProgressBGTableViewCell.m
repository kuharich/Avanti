//
//  MyProgressBGTableViewCell.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 1/4/16.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "MyProgressBGTableViewCell.h"
#import "CircleProgressBar.h"

@implementation MyProgressBGTableViewCell

- (void)awakeFromNib {
    //    self.progressView.roundedCorners = YES;
    //    self.progressView.progressTintColor = [UIColor colorWithRed:250.0/255.0 green:200.0/255.0 blue:25.0/255.0 alpha:1.0];
    //
    //    self.progressView.trackTintColor = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0];
    //    self.progressView.thicknessRatio = .21;
    //    CGFloat progress = .5;
    //    [self.progressView setProgress:progress animated:YES];
    //    self.progressView.progressLabel.font  = [UIFont fontWithName:@"Avenir Next" size:16];
    //    self.progressView.progressLabel.textColor = [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0];
    [super awakeFromNib];
    [self customizeAccordingToState];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)customizeAccordingToState {
    
    // Progress Bar Customization
    [self.progressView setProgressBarWidth:7];
    [self.progressView setProgressBarProgressColor:[UIColor colorWithRed:250.0/255.0 green:200.0/255.0 blue:25.0/255.0 alpha:1.0]];
    [self.progressView setProgressBarTrackColor:[UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0]];
    // Hint View Customization
    // [_circleProgressBar setHintViewSpacing:(customized ? 10.0f : 0)];
    // [_circleProgressBar setHintViewBackgroundColor:(customized ? [UIColor colorWithWhite:1.000 alpha:0.800] : nil)];
    [self.progressView setHintTextFont:[UIFont fontWithName:@"Avenir Next" size:16.0f] ];
    [self.progressView setHintViewBackgroundColor:[UIColor whiteColor]];
    [self.progressView setHintTextColor:[UIColor grayColor] ];
    
    //  [_circleProgressBar setHintTextColor:(customized ? [UIColor blackColor] : nil)];
    // [_circleProgressBar setHintTextGenerationBlock:(customized ? ^NSString *(CGFloat progress) {
    // return [NSString stringWithFormat:@"%.0f / 255", progress * 255];
    //} : nil)];
    
    // Attributed String
    //    [_circleProgressBar setHintAttributedGenerationBlock:(state == CustomizationStateCustomAttributed ? ^NSAttributedString *(CGFloat progress) {
    //        NSString *formatString = [NSString stringWithFormat:@"%.0f / 255", progress * 255];
    //        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:formatString];
    //        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:40.0f] range:NSMakeRange(0, string.length)];
    //
    //        NSArray *components = [formatString componentsSeparatedByString:@"/"];
    //        UIColor *valueColor = [UIColor colorWithRed:(0.2f) green:(0.2f) blue:(0.5f + progress * 0.5f) alpha:1.0f];
    //        [string addAttribute:NSForegroundColorAttributeName value:valueColor range:NSMakeRange(0, [[components firstObject] length])];
    //        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange([[components firstObject] length], 1)];
    //        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange([[components firstObject] length] + 1, [[components lastObject] length])];
    //        return string;
    //    } : nil)];
}

@end

//
//  CircleProgressBar.m
//  CircleProgressBar
//
//  Created by Andrew Cherkashin on 3/16/15.
//  Copyright (c) 2015 Eclair. All rights reserved.
//
// 250 200 25

#import "CircleProgressBar.h"

// Common
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

// Progress Bar Defaults
#define DefaultProgressBarProgressColor [UIColor colorWithRed:250.0/255.0 green:200.0/255.0 blue:25.0/255.0 alpha:1.0]
#define DefaultProgressBarTrackColor [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]
const CGFloat DefaultProgressBarWidth = 33.0f;

// Hint View Defaults
#define DefaultHintBackgroundColor [UIColor colorWithWhite:0 alpha:0.7]
#define DefaultHintTextFont [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0f]
#define DefaultHintTextColor [UIColor whiteColor]
const CGFloat DefaultHintSpacing = 20.0f;
const StringGenerationBlock DefaultHintTextGenerationBlock = ^NSString *(CGFloat progress) {
    return [NSString stringWithFormat:@"%.0f%%", progress * 100];
};

// Animation Constants
const CGFloat AnimationChangeTimeDuration = 0.2f;
const CGFloat AnimationChangeTimeStep = 0.01f;

@interface CircleProgressBar (Private)

// Common
- (CGFloat)progressAccordingToBounds:(CGFloat)progress;

// Base Drawing
- (void)drawBackground:(CGContextRef)context;

// ProgressBar Drawing
- (UIColor*)progressBarProgressColorForDrawing;
- (UIColor*)progressBarTrackColorForDrawing;
- (CGFloat)progressBarWidthForDrawing;
- (void)drawProgressBar:(CGContextRef)context progressAngle:(CGFloat)progressAngle center:(CGPoint)center radius:(CGFloat)radius;

// Hint Drawing
- (CGFloat)hintViewSpacingForDrawing;
- (UIColor*)hintViewBackgroundColorForDrawing;
- (UIFont*)hintTextFontForDrawing;
- (UIColor*)hintTextColorForDrawing;
- (NSString*)stringRepresentationOfProgress:(CGFloat)progress;
- (void)drawSimpleHintTextAtCenter:(CGPoint)center;
- (void)drawAttributedHintTextAtCenter:(CGPoint)center;
- (void)drawHint:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius;

// Animation
- (void)animateProgressBarChangeFrom:(CGFloat)startProgress to:(CGFloat)endProgress duration:(CGFloat)duration;
- (void)updateProgressBarForAnimation;

@end

@implementation CircleProgressBar {
    NSTimer *_animationTimer;
    CGFloat _currentAnimationProgress, _startProgress, _endProgress, _animationProgressStep;
    StringGenerationBlock _hintTextGenerationBlock;
    AttributedStringGenerationBlock _hintAttributedTextGenerationBlock;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setProgress:progress animated:animated duration:AnimationChangeTimeDuration];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration; {
    progress = [self progressAccordingToBounds:progress];
    if (_progress == progress) {
        return;
    }
    
    [_animationTimer invalidate];
    _animationTimer = nil;
    
    if (animated) {
        [self animateProgressBarChangeFrom:_progress to:progress duration:duration];
    } else {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGPoint innerCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = MIN(innerCenter.x, innerCenter.y);
    CGFloat currentProgressAngle = (_progress * 360) + _startAngle;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);

    [self drawBackground:context];
    
    [self drawProgressBar:context progressAngle:currentProgressAngle center:innerCenter radius:radius];
    if (!_hintHidden) {
        [self drawHint:context center:innerCenter radius:radius];
    }
}

#pragma mark - Setters with View Update

- (void)setProgressBarWidth:(CGFloat)progressBarWidth {
    _progressBarWidth = progressBarWidth;
    [self setNeedsDisplay];
}

- (void)setProgressBarProgressColor:(UIColor *)progressBarProgressColor {
    _progressBarProgressColor = progressBarProgressColor;
    [self setNeedsDisplay];
}

- (void)setProgressBarTrackColor:(UIColor *)progressBarTrackColor {
    _progressBarTrackColor = progressBarTrackColor;
    [self setNeedsDisplay];
}

- (void)setHintHidden:(BOOL)isHintHidden {
    _hintHidden = isHintHidden;
    [self setNeedsDisplay];
}

- (void)setHintViewSpacing:(CGFloat)hintViewSpacing {
    _hintViewSpacing = hintViewSpacing;
    [self setNeedsDisplay];
}

- (void)setHintViewBackgroundColor:(UIColor *)hintViewBackgroundColor {
    _hintViewBackgroundColor = hintViewBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setHintTextFont:(UIFont *)hintTextFont {
    _hintTextFont = hintTextFont;
    [self setNeedsDisplay];
}

- (void)setHintTextColor:(UIColor *)hintTextColor {
    _hintTextColor = hintTextColor;
    [self setNeedsDisplay];
}

- (void)setHintTextGenerationBlock:(StringGenerationBlock)generationBlock {
    _hintTextGenerationBlock = generationBlock;
    [self setNeedsDisplay];
}

- (void)setHintAttributedGenerationBlock:(AttributedStringGenerationBlock)generationBlock {
    _hintAttributedTextGenerationBlock = generationBlock;
    [self setNeedsDisplay];
}

- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
    [self setNeedsDisplay];
}

@end

@implementation CircleProgressBar (Private)

#pragma mark - Common

- (CGFloat)progressAccordingToBounds:(CGFloat)progress {
    progress = MIN(progress, 1);
    progress = MAX(progress, 0);
    return progress;
}

#pragma mark - Base Drawing

- (void)drawBackground:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
}

#pragma mark - ProgressBar Drawing

- (UIColor*)progressBarProgressColorForDrawing {
    return (_progressBarProgressColor != nil ? _progressBarProgressColor : DefaultProgressBarProgressColor);
}

- (UIColor*)progressBarTrackColorForDrawing {
    return (_progressBarTrackColor != nil ? _progressBarTrackColor : DefaultProgressBarTrackColor);
}

- (CGFloat)progressBarWidthForDrawing {
    return (_progressBarWidth > 0 ? _progressBarWidth : DefaultProgressBarWidth);
}

// color varies from 75, 178, 185 to 100, 187, 126
#define DRAW_STEPS  100
#define RED_START   76.0
#define RED_END     100.0
#define GREEN_START 178.0
#define GREEN_END   187.0
#define BLUE_START  185.0
#define BLUE_END    126.0

- (void)drawProgressBar:(CGContextRef)context progressAngle:(CGFloat)progressAngle center:(CGPoint)center radius:(CGFloat)radius {
    CGFloat barWidth = self.progressBarWidthForDrawing;
    if (barWidth > radius) {
        barWidth = radius;
    }
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor);
    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(progressAngle), DEGREES_TO_RADIANS(_startAngle + 360.0), 0);
    CGContextAddArc(context, center.x, center.y, radius - barWidth, DEGREES_TO_RADIANS(_startAngle + 360.0), DEGREES_TO_RADIANS(progressAngle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);

    double angle = _startAngle;
    double step = (progressAngle - _startAngle) / DRAW_STEPS;
    double red = RED_START;
    double blue = BLUE_START;
    double green = GREEN_START;
    double redStep = (RED_END - RED_START) / DRAW_STEPS;
    double greenStep = (GREEN_END - GREEN_END) / DRAW_STEPS;
    double blueStep = (BLUE_END - BLUE_START) / DRAW_STEPS;
    for (int i=0; i<DRAW_STEPS; i++) {
        UIColor *color = [UIColor colorWithRed:red/255.0
                                         green:green/255.0
                                          blue:blue/255.0
                                         alpha:1];
        red += redStep;
        green += greenStep;
        blue += blueStep;
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, barWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextAddArc(context, center.x, center.y, radius - (barWidth/2.0), DEGREES_TO_RADIANS(angle), DEGREES_TO_RADIANS(angle+step), 0);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        angle += step;
    }

}

#pragma mark - Hint Drawing

- (CGFloat)hintViewSpacingForDrawing {
    return (_hintViewSpacing != 0 ? _hintViewSpacing : DefaultHintSpacing);
}

- (UIColor*)hintViewBackgroundColorForDrawing {
    return (_hintViewBackgroundColor != nil ? _hintViewBackgroundColor : DefaultHintBackgroundColor);
}

- (UIFont*)hintTextFontForDrawing {
    return (_hintTextFont != nil ? _hintTextFont : DefaultHintTextFont);
}

- (UIColor*)hintTextColorForDrawing {
    return (_hintTextColor != nil ? _hintTextColor : DefaultHintTextColor);
}

- (NSString*)stringRepresentationOfProgress:(CGFloat)progress {
    return (_hintTextGenerationBlock != nil ? _hintTextGenerationBlock(progress) : DefaultHintTextGenerationBlock(progress));
}

- (void)drawSimpleHintTextAtCenter:(CGPoint)center {
    NSString *progressString = [self stringRepresentationOfProgress:_progress];
    CGSize hintTextSize = [progressString boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.hintTextFontForDrawing} context:nil].size;
    [progressString drawAtPoint:CGPointMake(center.x - hintTextSize.width / 2, center.y - hintTextSize.height / 2) withAttributes:@{NSFontAttributeName: self.hintTextFontForDrawing, NSForegroundColorAttributeName: self.hintTextColorForDrawing}];
}

- (void)drawAttributedHintTextAtCenter:(CGPoint)center {
    NSAttributedString *progressString = _hintAttributedTextGenerationBlock(_progress);
    CGSize hintTextSize = [progressString boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading context:nil].size;
    [progressString drawAtPoint:CGPointMake(center.x - hintTextSize.width / 2, center.y - hintTextSize.height / 2)];
}

- (void)drawHint:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius {
    CGFloat barWidth = self.progressBarWidthForDrawing;
    if (barWidth + self.hintViewSpacingForDrawing > radius) {
        return;
    }
    
    CGContextSetFillColorWithColor(context, self.hintViewBackgroundColorForDrawing.CGColor);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius - barWidth - self.hintViewSpacingForDrawing, DEGREES_TO_RADIANS(0), DEGREES_TO_RADIANS(360), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    if (_hintAttributedTextGenerationBlock != nil) {
        [self drawAttributedHintTextAtCenter:center];
    } else {
        [self drawSimpleHintTextAtCenter:center];
    }
}

#pragma mark - Amination

- (void)animateProgressBarChangeFrom:(CGFloat)startProgress to:(CGFloat)endProgress duration:(CGFloat)duration {
    _currentAnimationProgress = _startProgress = startProgress;
    _endProgress = endProgress;
    
    _animationProgressStep = (_endProgress - _startProgress) * AnimationChangeTimeStep / duration;
    
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:AnimationChangeTimeStep target:self selector:@selector(updateProgressBarForAnimation) userInfo:nil repeats:YES];
}

- (void)updateProgressBarForAnimation {
    _currentAnimationProgress += _animationProgressStep;
    _progress = _currentAnimationProgress;
    if ((_animationProgressStep > 0 && _currentAnimationProgress >= _endProgress) || (_animationProgressStep < 0 && _currentAnimationProgress <= _endProgress)) {
        [_animationTimer invalidate];
        _animationTimer = nil;
        _progress = _endProgress;
    }
    [self setNeedsDisplay];
}

@end
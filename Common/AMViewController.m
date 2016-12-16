//
//  AMViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 07/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMViewController.h"

#define avantiGreenGradientStart [[UIColor colorWithRed:113.0/255.0 green:191.0/255.0 blue:86.0/255.0 alpha:1.0] CGColor]
#define avantiGreenGradientEnd [[UIColor colorWithRed:74.0/255.0 green:179.0/255.0 blue:178.0/255.0 alpha:1.0] CGColor]

@interface AMViewController ()
@end

@implementation AMViewController

- (void)resignView:(UIView *)v{
    for (UIView *sview in v.subviews) {
        [self resignView:sview];
    }
    [v resignFirstResponder];
}


-(void) setCustomBackgroundColor:(UIImageView *) image {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        UIGraphicsBeginImageContext(image.frame.size);
        [[self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryBackgroundColor"]] set];
        UIRectFill(CGRectMake(0, 0, image.frame.size.width, image.frame.size.height));
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [image setImage:scaledImage];
    }
}

-(void) setCustomBackgroundImage:(UIImageView *) image {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        NSString *imageSetName= [[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryBackgroundImageSetName"];
        if ([imageSetName length] > 0) {
             [image setImage:[UIImage imageNamed:imageSetName]];
        }
        else {
            [self setCustomBackgroundColor: image];
        }
    }
}


-(void) setCustomLabelFont:(UILabel *) label {
    if ([label.font.fontName isEqualToString:@"Quicksand-Bold"]) {
        label.font = [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:label.font.pointSize];
    }
    else if ([label.font.fontName isEqualToString:@"Quicksand-Regular"]) {
        label.font = [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandFontName"] size:label.font.pointSize];
    }
}

-(void) setCustomTextViewFont:(UITextView *) textView {
    if ([textView.font.fontName isEqualToString:@"Quicksand-Bold"]) {
        textView.font = [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"] size:textView.font.pointSize];
    }
    else if ([textView.font.fontName isEqualToString:@"Quicksand-Regular"]) {
        textView.font = [UIFont fontWithName:[[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandFontName"] size:textView.font.pointSize];
    }
}

-(void) setCustomLabelColor:(UILabel *) label {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryTextColor"]]];
        [self setCustomLabelFont:label];
    }
}

-(void) setCustomSecondaryLabelColor:(UILabel *) label {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"secondaryTextColor"]]];
        [self setCustomLabelFont:label];
    }
}

-(void) setCustomBodyTextColor:(UILabel *) label {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"bodyTextColor"]]];
        [self setCustomLabelFont:label];
    }
}

-(void) setInfoBoxLabelColor:(UILabel *) label {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"infoBoxTextColor"]]];
        [label setBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"infoBoxBackgroundColor"]]];
        [self setCustomLabelFont:label];
    }
}

-(void) setCustomTitleColor:(UILabel *) label {
    [self setCustomLabelColor:label];
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor:[self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"highlightColor"]] range:NSMakeRange(0, 6)];
    }
}

-(void) setCustomTextViewColor:(UITextView *) textView {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [textView setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryTextColor"]]];
        [self setCustomTextViewFont:textView];
    }
}

-(void) setCustomReloadAmountHeaderLabelColor:(UILabel *) label {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"reloadAmountHeaderColor"]]];
    }
}

-(void) setCustomButtonSecondaryTextColor:(UIButton *) button {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [button setTitleColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"secondaryTextColor"]] forState:UIControlStateNormal];
    }
}

-(void) setCustomAmountButtonColors: (AmountButton *) button {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [button setColors: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryTextColor"]]
            selectedBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryButtonBackgroundColor"]]
            notSelectedTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"secondaryTextColor"]]
            notSelectedBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"itemBackgroundColor"]]
         ];
    }
}

-(void) setCustomTitleTextColorAttribute: (UINavigationBar *) navigationBar {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryTextColor"]]}];
    }
}


-(void) setCustomTextFieldColor:(UITextField *) field {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [field setTextColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryTextColor"]]];
    }
}

-(void) setCustomViewColor:(UIView *) view {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [view setBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryTextColor"]]]; // TODO: can the text color be used always
    }
}

-(BOOL) brandHasLightBackgroundColor {
    return ([[AppDelegate sharedDelegate].customSettings objectForKey:@"screenBackgroundColor"] != nil);
}

-(void) setCustomLightBackgroundColor:(UIView *) view {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [view setBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"screenBackgroundColor"]]];
    }
}

-(void) setCustomRegularButtonTextColor: (UIButton *) button {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [button setTitleColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryTextColor"]] forState:UIControlStateNormal];
        [self setCustomLabelFont:button.titleLabel];
    }
}

-(void) setCustomCancelButtonTextColor: (UIButton *) button {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [button setTitleColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"cancelButtonTextColor"]] forState:UIControlStateNormal];
        [self setCustomLabelFont:button.titleLabel];
    }
}

-(void) setCustomCancelButtonBackgroundColor:(UIView *) view {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [view setBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"cancelButtonBackgroundColor"]]];
    }
}

-(void) setCustomTintColor: (UIBarButtonItem *) button {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [button setTintColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"menuSandwichColor"]]];
    }
}


-(void) setCustomButtonTextColor: (UIButton *) button key: (NSString *) key {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        
        NSLog(@"%@ -> %@", key, [[AppDelegate sharedDelegate].customSettings objectForKey:key]);
        
        [button setTitleColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:key]] forState:UIControlStateNormal];
        [self setCustomLabelFont:button.titleLabel];
    }
}

-(void) setCustomLabelText: (UILabel *) label key: (NSString *) key {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [label setText:[[AppDelegate sharedDelegate].customSettings objectForKey:key]];
    }
}

-(void) setCustomRegularButtonBackgroundColor: (UIButton *) button {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [button setBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryButtonBackgroundColor"]]];
    }
}

-(void) setCustomLoginButtonBackgroundColor: (UIButton *) button {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        [button setBackgroundColor: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"logInButtonColor"]]];
    }
}


-(void) setCustomMenuItemSelectedColor: (UITableViewCell *) cell {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryButtonBackgroundColor"]];
        cell.selectedBackgroundView = backgroundView;
    }
}


-(void) setCustomPlaceholderColor: (UITextField *) view text:(NSString *) text {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        if ([view respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            view.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{ NSForegroundColorAttributeName: [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"textPlaceholderColor"]]}];
        }
    }
}

-(void) tallerCustomGradient:(UIView *) view {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        CGRect frame = view.bounds;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        [gradient setFrame: frame];
        UIColor *startColor;
        UIColor *endColor;
        if ([[[AppDelegate sharedDelegate].customSettings objectForKey:@"gradientStart"] length] > 0) {
            startColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"gradientStart"]];
            endColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"gradientEnd"]];
        }
        else {
            startColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryBackgroundColor"]];
            endColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryBackgroundColor"]];
        }
        gradient.colors = [NSArray arrayWithObjects:(id)startColor.CGColor,
                           (id) endColor.CGColor, nil];
        [view.layer insertSublayer:gradient atIndex:0];
    }
}

- (UIColor *) convertToColor:(NSString *)str {
    int red = 0;
    int green = 0;
    int blue = 0;
    sscanf([str UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    return  [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

-(void) customGradient {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0., 0., [UIScreen mainScreen].bounds.size.width, 64.);
        
        UIColor *startColor;
        UIColor *endColor;
        if ([[[AppDelegate sharedDelegate].customSettings objectForKey:@"gradientStart"] length] > 0) {
            startColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"gradientStart"]];
            endColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"gradientEnd"]];
        }
        else {
            startColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryBackgroundColor"]];
            endColor = [self convertToColor:[[AppDelegate sharedDelegate].customSettings objectForKey:@"primaryBackgroundColor"]];
        }
        
        gradient.colors = [NSArray arrayWithObjects:(id) startColor.CGColor,
                           (id) endColor.CGColor, nil];
        [self.navigationController.navigationBar setBackgroundImage:[self imageFromLayer:gradient] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
    }
}

-(NSString *) getCustomPath: (NSString *) path {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        if (((NSString *) [[AppDelegate sharedDelegate].customSettings objectForKey:@"applicationName"]).length > 0) {
            NSString *suffix = [[AppDelegate sharedDelegate].customSettings objectForKey:@"applicationName"];
            if ([suffix length] == 0) {
                suffix = @"avanti";
            }
            return [NSString stringWithFormat:@"%@/%@",path, suffix];
        }
    }
    return [NSString stringWithFormat:@"%@/%@",path, @"filler"];
}

-(NSString *) getCustomSupportUrl: (NSString *) path {
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        NSDictionary *appNameToStyleName = @{@"avanti" : @"avanti",
                                             @"continental" : @"market247",
                                             @"parkspantry": @"parkspantry",
                                             @"sodexo" : @"convenience"};
        if (((NSString *) [[AppDelegate sharedDelegate].customSettings objectForKey:@"applicationName"]).length > 0) {
            NSString *appName = [[AppDelegate sharedDelegate].customSettings objectForKey:@"applicationName"];
            if ([appName length] == 0) {
                appName = @"avanti";
            }
            return [NSString stringWithFormat:@"%@?brand=%@",path, [appNameToStyleName objectForKey:appName]];
        }
    }
    return [NSString stringWithFormat:@"%@?brand=%@",path, @"avanti"];
    
}

-(void) orangeGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0., 0., [UIScreen mainScreen].bounds.size.width, 64.);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:249.0/255.0 green:166.0/255.0 blue:66.0/255.0 alpha:1.0] CGColor],
                       (id)[[UIColor colorWithRed:234.0/255.0 green:128.0/255.0 blue:38.0/255.0 alpha:1.0] CGColor], nil];
    [self.navigationController.navigationBar setBackgroundImage:[self imageFromLayer:gradient] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void) greenGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0., 0., [UIScreen mainScreen].bounds.size.width, 64.);
    gradient.colors = [NSArray arrayWithObjects:(id)avantiGreenGradientStart, (id)avantiGreenGradientEnd, nil];
    [self.navigationController.navigationBar setBackgroundImage:[self imageFromLayer:gradient] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
}

// TODO: temporary - don't use gradient
-(void) solidGradient: (UIColor *) color {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0., 0., [UIScreen mainScreen].bounds.size.width, 64.);
    gradient.colors = [NSArray arrayWithObjects:(id)[color CGColor],
                       (id)[color CGColor], nil];
    [self.navigationController.navigationBar setBackgroundImage:[self imageFromLayer:gradient] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
}



-(void) tallerGreenGradient:(UIView *) view {
    if ([AppDelegate sharedDelegate].customSettings.count == 0) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        CGRect frame = view.bounds;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        [gradient setFrame: frame];
        gradient.colors = [NSArray arrayWithObjects: (id) avantiGreenGradientStart, (id)avantiGreenGradientEnd, nil];
        [view.layer insertSublayer:gradient atIndex:0];
    }
}

-(void) markTextFieldWithError: (UITextField *) view {
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:view.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }];
    view.attributedPlaceholder = str;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resignView:self.view];
}

- (void)setupMenuBarButtonItemsShow:(LeftMenuBarButtonItem )itemToDisplay {
    if (itemToDisplay == LeftMenuBarButtonItemSideMenu) {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
    else if (itemToDisplay == LeftMenuBarButtonItemBackItem){
        self.navigationItem.leftBarButtonItem = [self backMenuBarButtonItem];
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (UIBarButtonItem *)backMenuBarButtonItem {
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(backSideMenuButtonPressed:)];
    [menuItem setTintColor:DEFAULT_COLOR_THEME_WHITE];
    [self setCustomTintColor: menuItem];
    return menuItem;
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(leftSideMenuButtonPressed:)];
    [menuItem setTintColor:DEFAULT_COLOR_THEME_WHITE];
    [self setCustomTintColor: menuItem];
    return menuItem;
}

- (void)leftSideMenuButtonPressed:(id)sender{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

- (void)backSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemSideMenu];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    if ([AppDelegate sharedDelegate].customSettings.count > 0) {
        if ([@"black" isEqualToString:[[AppDelegate sharedDelegate].customSettings objectForKey:@"statusBarStyle"]]) {
            return UIStatusBarStyleDefault;
        }
        else {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            return UIStatusBarStyleLightContent;
        }
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    return UIStatusBarStyleLightContent;
    
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

-(void) setPlaceholderColor: (UITextField *) view text:(NSString *) text {
    UIColor *color = [UIColor whiteColor];
    if ([view respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        view.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
    }
}

-(void) setSubmitButtonColor: (UIButton *) button {
    const float red=132./255.0, green=194./255.0, blue=101./255.0;
    [button setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
}

-(void) setCancelButtonColor: (UIButton *) button {
    const float red=68./255.0, green=145./255.0, blue=148./255.0;
    [button setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
}

-(void) setForgotButtonColor: (UIButton *) button {
    const float red=48./255.0, green=125./255.0, blue=128./255.0;
    [button setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
}

-(void) setButtonColor: (UIButton *) button R: (int) red G: (int) green B: (int) blue {
    [button setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
}

-(void) setCustomBackgroundGradient: (AMViewController *) viewController {
    if ([AppDelegate sharedDelegate].customSettings.count == 0) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:112.0/255.0 green:191.0/255.0 blue:88.0/255.0 alpha:0.4] CGColor],
                           (id)[[UIColor colorWithRed:214.0/255.0 green:224.0/255.0 blue:61.0/255.0 alpha:0.4] CGColor], nil];
        [self.view.layer insertSublayer:gradient atIndex:1];
    }
    // TODO: else use custom values if required
}

-(NSString *) quicksandFontName {
    NSString *font = [[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandFontName"];
    if (font) {
        return font;
    }
    else {
        return @"Quicksand-Regular";
    }
}

-(NSString *) quicksandBoldFontName {
    NSString *font = [[AppDelegate sharedDelegate].customSettings objectForKey:@"quicksandBoldFontName"];
    if (font) {
        return font;
    }
    else {
        return @"Quicksand-Bold";
    }
}

@end



//
//  ArticleRatingViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 23/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "ArticleRatingViewController.h"
#import "MIRadioButtonGroup.h"

@interface ArticleRatingViewController () <RadioButtonGroupDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITableView *tableViewDetail;
@property (weak, nonatomic) IBOutlet UIWebView *webViewDetail;
@property (weak, nonatomic) IBOutlet UIView *viewVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UIView *viewRadioRating;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)tapOnSubmit:(id)sender;

@property (strong, nonatomic) IBOutlet MIRadioButtonGroup *radioReloadAmount;
@property (strong, nonatomic) NSArray *radioReloadAmounts;
@property (nonatomic)  BOOL isVideoPlaying;

@property (strong, nonatomic) NSDictionary *contents;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ArticleRatingViewController

- (void)setIsVideoPlaying:(BOOL)videoPlaying{
    _isVideoPlaying = videoPlaying;
    [[AMUtilities sharedUtilities] setVideoPlaying:videoPlaying];
}

- (void)clickedRadioButton:(UIButton *)sender atIndex:(NSInteger )index
{
    if (index == 0) {
        //Yes
    }
    else{
        //No
    }
}
#define HELP_TITLE      @"Title"
#define HELP_STEPS      @"HelpSteps"
#define HELP_VIDEO_ID      @"VideoURL"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"HELPFUL HOW TO"];
    [self.view setBackgroundColor:DEFAULT_COLOR_THEME_DARK_GREEN];
    [self.webViewDetail setBackgroundColor:DEFAULT_COLOR_THEME_DARK_GREEN];
    formatButtonWithoutBorder(self.btnSubmit, DEFAULT_COLOR_THEME_DARK_GREEN,
                              DEFAULT_COLOR_THEME_WHITE, NO);
    [self.tableViewDetail setBackgroundColor:DEFAULT_COLOR_THEME_DARK_GREEN];
    // Do any additional setup after loading the view from its nib.
    CGRect rect = self.viewRadioRating.frame;
    self.radioReloadAmounts = @[@" Yes", @" No"];
    self.radioReloadAmount = [[MIRadioButtonGroup alloc] initWithFrame:CGRectMake(5, 0, rect.size.width, rect.size.height)
                                                            andOptions:self.radioReloadAmounts
                                                            andColumns:2];
    [self.radioReloadAmount setDelegate:self];
    [self.viewRadioRating setBackgroundColor:[UIColor clearColor]];
    [self.viewRadioRating addSubview:self.radioReloadAmount];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];

    self.contents = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"Set up a My MarketCard account", HELP_TITLE,
                     @[@"First get a market card.", @"Scan your market card at a kiosk.", @"Sign up for web access.", @"Set your email and password.", @"Sign in using your email and password."], HELP_STEPS,
                     @"zLOUdVUW1rQ", HELP_VIDEO_ID,
                     nil];
    
    self.lblTitle.text = (NSString *)[self.contents objectForKey:HELP_TITLE];
    [self.tableViewDetail setTableFooterView:self.viewVideo];
    [self loadWebView];
}
- (void)loadWebView{
    [self.webViewDetail setHidden:YES];
    [self.activityIndicator startAnimating];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"setupaccount" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [self.webViewDetail loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
    self.isVideoPlaying = NO;
}

- (void)applicationDidEnterBackground{
    //[self dismissVideo:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (IBAction)playVideo:(id)sender{
    [self.webViewDetail stringByEvaluatingJavaScriptFromString:@"player.playVideo()"];
}

- (IBAction)pauseVideo:(id)sender{
    [self.webViewDetail stringByEvaluatingJavaScriptFromString:@"player.pauseVideo()"];
}

- (IBAction)dismissVideo:(id)sender{
    [self.webViewDetail stringByEvaluatingJavaScriptFromString:@"player.destroy()"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webViewDetail setHidden:NO];
    [self.activityIndicator stopAnimating];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *protocolPrefix = @"js2ios";
    if ([[url scheme] isEqualToString:protocolPrefix]) {

        NSString *urlStr = [url absoluteString];
        protocolPrefix = @"js2ios://";
        //strip protocol from the URL. We will get input to call a native method
        urlStr = [urlStr substringFromIndex:protocolPrefix.length];
        
        //Decode the url string
        urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSError *jsonError;
        
        //parse JSON input in the URL
        NSDictionary *callInfo = [NSJSONSerialization
                                  JSONObjectWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]
                                  options:kNilOptions
                                  error:&jsonError];
        //check if there was error in parsing JSON input
        if (jsonError != nil)
        {
            NSLog(@"Error parsing JSON for the url %@",url);
            return NO;
        }
        
        //Get function name. It is a required input
        NSString *functionName = [callInfo objectForKey:@"functionname"];
        if (functionName == nil)
        {
            NSLog(@"Missing function name");
            return NO;
        }
        NSString *successCallback = [callInfo objectForKey:@"success"];
        NSString *errorCallback = [callInfo objectForKey:@"error"];
        NSArray *argsArray = [callInfo objectForKey:@"args"];
        
        [self callNativeFunction:functionName withArgs:argsArray onSuccess:successCallback onError:errorCallback];
        
        //Do not load this url in the WebView
        return NO;
        
    }
    return YES;
}

- (void) callJSFunction:(NSString *) name withArgs:(NSMutableDictionary *) args
{
    NSError *jsonError;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:&jsonError];
    
    if (jsonError != nil)
    {
        //call error callback function here
        NSLog(@"Error creating JSON from the response  : %@",[jsonError localizedDescription]);
        return;
    }
    
    //initWithBytes:length:encoding
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonStr = %@", jsonStr);
    
    if (jsonStr == nil)
    {
        NSLog(@"jsonStr is null. count = %lu", (unsigned long)[args count]);
    }
    
    [self.webViewDetail stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');",name,jsonStr]];
}

- (void) callNativeFunction:(NSString *) name withArgs:(NSArray *) args onSuccess:(NSString *) successCallback onError:(NSString *) errorCallback
{
    //We only know how to process onPlayerStateChange
    if ([name compare:@"onPlayerStateChange" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        NSString *event = [args objectAtIndex:0];
        self.isVideoPlaying = [event isEqualToString:@"play"];
        if(self.isVideoPlaying){
            NSLog(@"onPlayerStateChange:play");
        }
        else{//pause
            NSLog(@"onPlayerStateChange:pause");
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 28.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.contents objectForKey:HELP_STEPS];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setNumberOfLines:2];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:13]];
    }
    NSArray *array = [self.contents objectForKey:HELP_STEPS];
    NSString *text = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row+1, [array objectAtIndex:indexPath.row]];
    cell.textLabel.text = text;//formattedText(text, 14);
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapOnSubmit:(id)sender {

}
@end

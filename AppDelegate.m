/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "MFSideMenuContainerViewController.h"
#import "Mixpanel.h"
#import "AAMixpanel.h"
#import "AvantiCommon.h"



#import "LGAlertView.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AMSideMenuViewController.h"


/*1555dfae6a8496d0b95a6c96fdb68aab
   My Apps Custom uncaught exception catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void HandleExceptions(NSException *exception) {
	NSLog(@"This is where we save the application data during a exception");
	// Save application     data on crash
}

/*
   My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void SignalHandler(int sig) {
	NSLog(@"This is where we save the application data during a signal");
	// Save application data on crash
}

@interface AppDelegate ()
{
	Reachability *internetReachable;
}

@property BOOL isAppInBackground;
@property BOOL isAvantAppDisplayed;

@end

@implementation AppDelegate

@synthesize menuController;
@synthesize customSettings;

+ (AppDelegate *)sharedDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)setAvantAppDisplayed:(BOOL)isDisplay {
	self.isAvantAppDisplayed = isDisplay;
}

- (void)openControllerAtIndexPath:(NSIndexPath *)indexPath withBool:(BOOL)param {
    [self.menuController openControllerAtIndexPath:indexPath withBool:param];
}


- (void)launchAvantiMarkets {

    self.menuController = [[AMSideMenuViewController alloc] initWithNibName:[XibHelper XibFileName:@"AMSideMenuViewController"] bundle:nil];
    [[AMUtilities sharedUtilities] getUserbalance:^(id obj){}];
    
    
    if (self.localNoti==nil)
    {
        [[AMUtilities sharedUtilities] getServerUserbalance];
        
        self.localNoti = [[UILocalNotification alloc] init];
        self.localNoti.fireDate = [NSDate date];
        self.localNoti.repeatInterval = NSCalendarUnitMinute;
        self.localNoti.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:self.localNoti];
    }
    
    // initiate fetching credit cards in advance. reload screen will check if there has been a response, if not, there will be a new request on viewWillLoad
    [[AMUtilities sharedUtilities] getServerStoredCreditCards:^(id obj)
     {
     }];
    [[AMUtilities sharedUtilities] getHasDiscounts:^(id obj){
        // Must wait for response before showing the home page
        [[AMUtilities sharedUtilities] getDiscounts: [[NSDate alloc] init] block: ^(id obj){ 
            AMHomeViewController     *homeVC =[self.menuController avantiMarketsHomeViewController];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
            navigationController.edgesForExtendedLayout = UIRectEdgeAll;
            MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:navigationController
                                                        leftMenuViewController:self.menuController
                                                        rightMenuViewController:nil];
        
            [container setMenuWidth:[XibHelper isIpad] ? 500.0 : 250.0]; // TODO: maybe 80 % of screen width
            self.window.rootViewController = container;
            self.isAvantAppDisplayed = YES;
        }];

    }];
}

- (void)launchPinLoginScreen {
	//TODO:: create PIN login UI
    AMPINViewController *home = [[AMPINViewController alloc] initWithNibName:[XibHelper XibFileName:@"AMPINViewController"] bundle:nil];
	self.navController = [[UINavigationController alloc] initWithRootViewController:home];
	[self.navController setNavigationBarHidden:YES];
	self.isAvantAppDisplayed = NO;
	self.window.rootViewController = self.navController;
}

- (void)launchLoginScreen {
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:[XibHelper XibFileName: @"LoginViewController"] bundle:nil];
	self.navController = [[UINavigationController alloc] initWithRootViewController:login];
	[self.navController setNavigationBarHidden:YES];
	self.isAvantAppDisplayed = NO;
	self.window.rootViewController = self.navController;
}
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if TARGET_IPHONE_SIMULATOR == 0
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
#endif
    [self loadCustomSettings];
    
    [KeychainHelper moveUsernameAndPassword]; // move plaintext credentials from UserDefaults to keychain
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [Fabric with:@[[Crashlytics class]]];

    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    // hide the 1 px line at the bottom of navigation bar
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];

    
     NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	// Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.isAvantAppDisplayed = NO;
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace)
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:NSStringFromClass([GetBalanceResponse class])];
	NSString *savedEncrypt = [[NSUserDefaults standardUserDefaults] objectForKey:NSUSERDEFAULT_StoredEncryptedPass];
    
	if (savedEncrypt) {
        BOOL isPasswordOn = [[NSUserDefaults standardUserDefaults] boolForKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
        if (isPasswordOn) {
             [self launchPinLoginScreen];
        }
        else{
            [self launchAvantiMarkets];
        }
    }
	else {
		[self launchLoginScreen];
	}
    self.shouldSaveCard = NO;
	[self.window setBackgroundColor:[UIColor blackColor]];
	[self.window makeKeyAndVisible];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:)
	                                             name:kReachabilityChangedNotification object:nil];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeChanged:) name:UIApplicationSignificantTimeChangeNotification object:nil];

//    reach = [Reachability reachabilityWithHostName:AVANTI_SERVER_API_URL];
//    [reach startNotifier];

	internetReachable = [Reachability reachabilityForInternetConnection];
	[internetReachable startNotifier];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    [AMUtilities sharedUtilities].internetStatusActive = internetStatus;
	if (internetStatus == NO) {
	//	displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
	}

	UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
	UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
	UIImage *thumbImage = [UIImage imageNamed:@"slider-cap.png"];

	[[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
	[[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
	[[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
	[[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                DEFAULT_COLOR_THEME_NAVIGATION, NSForegroundColorAttributeName,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], NSForegroundColorAttributeName,
                                [UIFont fontWithName:FONT_Avenir_LT_Std_Black size:0.0], NSFontAttributeName,
                                nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    self.navController.navigationBar.backgroundColor = [UIColor clearColor];
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
 //   self.timer = nil;
	if (self.isAppInBackground && self.isAvantAppDisplayed) {
		self.isAvantAppDisplayed = NO;
	}
	self.isAppInBackground = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    dispatch_async(dispatch_get_main_queue(), ^{
//    if ([self.timer isValid])
//    {
//        NSLog(@"---Invalidating the Timer----");
//        [self.timer invalidate];
//    }});
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    self.localNoti = nil;
    self.retryCnt =0;
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
    
    NSLog(@"applicationDidEnterBackground");
    [AAMixpanel sessionEnd];

    BOOL isPasswordOn = [[NSUserDefaults standardUserDefaults] boolForKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
	self.isAppInBackground = YES;
    if (isPasswordOn && self.isAppInBackground && self.isAvantAppDisplayed) {
        AMPINViewController *home = [[AMPINViewController alloc] initWithNibName:[XibHelper XibFileName:@"AMPINViewController"] bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
        [nav setNavigationBarHidden:YES];
        [self.window.rootViewController presentViewController:nav animated:NO completion: ^{
            home.comingFromBackground = YES;
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    self.retrySFDCCount=0;
    self.tcAlertShow = NO;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.localNoti = nil;

    [self.timer invalidate];
    self.timer = nil;
    if (self.tcAlert.showing)
    {
        [self.tcAlert dismissAnimated:NO completionHandler:nil];
        self.tcAlert=nil;
        self.tcAlertShow = YES;
    }
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

    NSLog(@"applicationWillResignActive");
    BOOL isPasswordOn = [[NSUserDefaults standardUserDefaults] boolForKey:NSUSERDEFAULT_SET_PASSWORD_LOCK];
	self .isAppInBackground = YES;
    if (isPasswordOn && self.isAppInBackground && self.isAvantAppDisplayed) {
        AMPINViewController *home = [[AMPINViewController alloc] initWithNibName:[XibHelper XibFileName:@"AMPINViewController"] bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
        [nav setNavigationBarHidden:YES];
        [self.window.rootViewController presentViewController:nav animated:NO completion: ^{
            home.comingFromBackground = YES;
        }];
    }
}

- (void)reachabilityDidChange:(NSNotification *)notification {
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus) {
		case NotReachable:
		{
			NSLog(@"The internet is down.");
			[AMUtilities sharedUtilities].internetStatusActive = NO;
			//displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
			break;
		}

		case ReachableViaWiFi:
		{
			NSLog(@"The internet is working via WIFI.");
			[AMUtilities sharedUtilities].internetStatusActive = YES;
			break;
		}

		case ReachableViaWWAN:
		{
			NSLog(@"The internet is working via WWAN.");
			[AMUtilities sharedUtilities].internetStatusActive = YES;
			break;
		}
	}
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    [AAMixpanel sessionEnd];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[AMUtilities sharedUtilities] getServerUserbalance];
}

- (void)loadCustomSettings
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"customSettings" ofType:@"plist"];
    NSLog(@"%@", path);
    self.customSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"%@", self.customSettings);
}

@end

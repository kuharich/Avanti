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

#import "AMSideMenuViewController.h"

@class LGAlertView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (assign,nonatomic) BOOL reloadBool;
@property (assign,nonatomic) id WaysToPay;
@property (assign,nonatomic) BOOL shouldSaveCard;
@property (assign,nonatomic) BOOL tcAlertShow;
@property (assign,nonatomic) BOOL tcAlertShow1;
@property (assign,nonatomic) BOOL tcAlertShow2;
@property (assign,nonatomic) NSTimer *timer;
@property (strong,nonatomic) UILocalNotification *localNoti;
@property (strong, nonatomic) NSMutableDictionary* customSettings;

@property int retryCnt;
@property int retrySFDCCount;
@property int retrySFDCCount1;

@property (strong,nonatomic)LGAlertView *tcAlert;
@property (nonatomic, strong) AMSideMenuViewController *menuController;


+ (AppDelegate *)sharedDelegate;

- (void)setAvantAppDisplayed:(BOOL)isDisplay;
- (void)launchAvantiMarkets;
- (void)launchPinLoginScreen;
- (void)launchLoginScreen;

- (void)openControllerAtIndexPath:(NSIndexPath *)indexPath withBool:(BOOL)param ;

@end

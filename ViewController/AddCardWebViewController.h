//
//  AddCardWebViewController.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 7/13/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMViewController.h"
@class GlobalGateWayResponse;
@interface AddCardWebViewController : AMViewController<UIWebViewDelegate>
@property (nonatomic, strong)IBOutlet UIWebView* webView;
@property (nonatomic, strong) GlobalGateWayResponse* gateWay;
@property (nonatomic, assign) NSString *parenntViewController;;
@property(nonatomic,strong)UIAlertView *alert;

@end

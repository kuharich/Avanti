//
//  ContactViewController.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupportArticleListResponse;
@interface SupportArticleViewController : AMViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)IBOutlet UIWebView *webView;
@property(nonatomic)SupportArticleListResponse *articleResponseObj;
@property(nonatomic,strong)IBOutlet UILabel *articleTitle;
@property(nonatomic,strong)IBOutlet UITextView *txtViewArticleDtls;

@end

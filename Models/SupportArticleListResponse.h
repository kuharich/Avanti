//
//  SupportArticleListResponse.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/28/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportArticleListResponse : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *KnowledgeArticleId;
@property (strong, nonatomic) NSString *ArticleNumber;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Summary;
@property (strong, nonatomic) NSString *Body_Content__c;
@property (strong, nonatomic) NSString *Visible_in_Common_Issues__c;
@property (strong, nonatomic) NSString *Visible_in_Using_the_App__c;
@property (strong, nonatomic) NSString *Visible_in_Using_the_Market__c;
@property (strong, nonatomic) NSString *IsVisibleInApp;
@property (strong, nonatomic) NSString *IsVisibleInPkb;
@property (strong, nonatomic) NSString *ResponseDetails;

@property (strong, nonatomic) NSArray   *supportArticle;

@end

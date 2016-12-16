//
//  ArticleDetailsResponse.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 6/28/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleDetailsResponse : NSObject
//id: "ka0J00000000eiLIAQ"
//KnowledgeArticleId: "kA0J00000000WF7KAM"
//ArticleNumber: "000001065"
//Title: "How do I register my Market Card at the kiosk?"
//Summary: null
//Body_Content__c: "You can register your Market Card directly at the kiosk by following these steps: <ul><li>Scan your My MarketCard at the kiosk.</li><li>Enter your FIRST NAME then select NEXT.</li><li>Enter your LAST NAME then select NEXT.</li><li>Enter your EMAIL address then select NEXT.</li><li>At some kiosks you will need to agree to the terms and conditions.</li><li>Click DONE.</li></ul>"
//Visible_in_Common_Issues__c: "False"
//Visible_in_Using_the_App__c: "False"
//Visible_in_Using_the_Market__c: "True"
//IsVisibleInApp: "True"
//IsVisibleInPkb: "False"
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Body_Content__c;
@end

//
//  AvantiMarketTests.m
//  AvantiMarketTests
//
//  Created by Tero Jankko on 2/5/16.
//  Copyright © 2016 Byndl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AllSpecialTableViewController.h"
#import "AMUtilities.h"
#import "AuthenticateRequest.h"
#import "AccountHistoryViewController.h"
#import "GetHistoryResponse.h"
#import "AMUtilities.h"
#import "OHHTTPStubs.h"
#import "OHPathHelpers.h"
#import "Discount.h"


@interface AvantiMarketTests : XCTestCase

@end


@implementation AvantiMarketTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

    
- (void) testRegularOffAmount {
    NSString *text = @"$0.49 Off Doritos chips";
    NSString *result = [AllSpecialTableViewController getOffAmountText:text];
    XCTAssertTrue([result isEqualToString: @"$0.49 Off"]);
}

- (void) testRegularLowCaseOffAmount {
    NSString *text = @"$0.49 off Doritos chips";
    NSString *result = [AllSpecialTableViewController getOffAmountText:text];
    XCTAssertTrue([result isEqualToString: @"$0.49 off"]);
}

- (void) testAbsentOffAmount {
    NSString *text = @"Cheap Doritos chips";
    NSString *result = [AllSpecialTableViewController getOffAmountText:text];
    XCTAssertTrue([result isEqualToString: @""]);
}

- (void) testRegularDetailText {
    NSString *text = @"$0.49 Off Doritos chips";
    NSString *result = [AllSpecialTableViewController getDetailText: text];
    XCTAssertTrue([result isEqualToString: @"Doritos chips"]);
}

- (void) testRegularLowCaseDetailText {
    NSString *text = @"$0.49 off Doritos chips";
    NSString *result = [AllSpecialTableViewController getDetailText: text];
    XCTAssertTrue([result isEqualToString: @"Doritos chips"]);
}

- (void) testAbsentOffAmountDetailText {
    NSString *text = @"Cheap Doritos chips";
    NSString *result = [AllSpecialTableViewController getDetailText: text];
    XCTAssertTrue([result isEqualToString: @"Cheap Doritos chips"]);
}

NSString *bonusTransactionType = @"CreditBonus";
NSString *rechargeTransactionType = @"MMCCreditCardRecharge";

- (void) testHistoryWithBonuses {
    AccountHistoryViewController *vc = [[AccountHistoryViewController alloc] init];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    GetHistoryResponse *item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:1];
    item.transactionType = bonusTransactionType;
    [list addObject: item];

    item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:20];
    item.transactionType = rechargeTransactionType;
    [list addObject: item];
    
    item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:10];
    item.transactionType = rechargeTransactionType;
    [list addObject: item];
    
    [vc combineBonusesToActualTransactions: &list];
    
    XCTAssertTrue([list count] == 2);

    XCTAssertTrue([((GetHistoryResponse *)list[0]).transactionType isEqualToString:rechargeTransactionType]);
    XCTAssertTrue([((GetHistoryResponse *)list[0]).transactionAmount isEqualToNumber:[NSNumber numberWithInt:21]]);
    XCTAssertTrue([((GetHistoryResponse *)list[1]).transactionType isEqualToString:rechargeTransactionType]);

}

- (void) testHistoryWithLastItemBonus {
    AccountHistoryViewController *vc = [[AccountHistoryViewController alloc] init];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    GetHistoryResponse *item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:1];
    item.transactionType = bonusTransactionType;
    [list addObject: item];
    
    item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:20];
    item.transactionType = rechargeTransactionType;
    [list addObject: item];
    
    item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:10];
    item.transactionType = rechargeTransactionType;
    [list addObject: item];
    
    item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:1];
    item.transactionType = bonusTransactionType;
    [list addObject: item];
    
    [vc combineBonusesToActualTransactions: &list];
    
    XCTAssertTrue([list count] == 2);

    XCTAssertTrue([((GetHistoryResponse *)list[0]).transactionType isEqualToString:rechargeTransactionType]);
    XCTAssertTrue([((GetHistoryResponse *)list[0]).transactionAmount isEqualToNumber:[NSNumber numberWithInt:21]]);
    XCTAssertTrue([((GetHistoryResponse *)list[1]).transactionAmount isEqualToNumber:[NSNumber numberWithInt:10]]);

}


- (void) testHistoryWithNoBonuses {
    AccountHistoryViewController *vc = [[AccountHistoryViewController alloc] init];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];

    GetHistoryResponse *item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:10];
    item.transactionType = rechargeTransactionType;
    [list addObject: item];
    
    item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:10];
    item.transactionType = rechargeTransactionType;
    [list addObject: item];
    
    [vc combineBonusesToActualTransactions: &list];
    
    XCTAssertTrue([list count] == 2);
    
}

- (void) testHistoryWithoneBonusOneRecharge {
    AccountHistoryViewController *vc = [[AccountHistoryViewController alloc] init];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    GetHistoryResponse *item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:1];
    item.transactionType = bonusTransactionType;
    [list addObject: item];
    
    item = [[GetHistoryResponse alloc] init];
    item.transactionAmount = [NSNumber numberWithInteger:20];
    item.transactionType = rechargeTransactionType;
    [list addObject: item];
    
    [vc combineBonusesToActualTransactions: &list];
    
    XCTAssertTrue([list count] == 1);
    
}

- (NSDate *) getDateWithYear: (int) year month : (int) month  day : (int) day hour: (int) hour minute: (int) minute {
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    
    NSDate *testDate = [calendar dateFromComponents:components];
    return testDate;
}

-(void) testGetDiscountsShouldOnlyReturnCurrentlyValidOffers {
    AMUtilities *utilities = [[AMUtilities alloc] init];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"mobileapi.mykioskworld.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString* fixture = OHPathForFile(@"getdiscounts.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Discounts API call"];
    
    NSDate *testDate = [self getDateWithYear: 2016 month:11 day:15 hour:10 minute:59];
    
    [utilities getDiscounts: testDate block: ^(id obj){
        [expectation fulfill];
        NSMutableArray *result = (NSMutableArray *) obj;
        XCTAssertEqual(1, [result count]);
        XCTAssertTrue([((Discount *) [result objectAtIndex: 0]).name isEqualToString:@"current"]);
    }];

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) { }];
    
    [OHHTTPStubs removeAllStubs];
}



@end

//
//  AMUtilities.h
//  AvantiMarket
//
//  Created by Deepak Sahu on 14/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMCreditCardInfo.h"
#import "AMMarketCardInfo.h"
#import "ShowContactUsReponse.h"

@class GetBalanceResponse;
@class RKMappingResult;
@class SFToken;
@interface AMUtilities : NSObject

@property (nonatomic, assign, getter=isInternetWorking) BOOL internetStatusActive;
@property (nonatomic, assign, getter=isVideoPlaying)    BOOL videoPlaying;
@property (nonatomic, strong) NSMutableArray *loyalityArray;
@property (nonatomic, strong) ShowContactUsReponse *showContactUsReponse;
@property (nonatomic, strong) __block SFToken *token;
@property (nonatomic, strong) GetBalanceResponse *balance;
@property (nonatomic, strong) NSMutableArray     *savedCreditCardArray;
@property (nonatomic, strong) NSString *scanCode;
@property (nonatomic, strong) NSMutableArray     *allSpecialArray;
@property (nonatomic, strong) NSMutableArray *discounts;
@property (assign, nonatomic) BOOL hasDiscounts;


+ (AMUtilities *)sharedUtilities;

//Encyption: START
- (NSString *)generateKeyForPIN:(NSString *)pinValue withIteration:(NSUInteger)iteration;
- (void)storePassword:(NSString *)password pin:(NSString *)pin;
- (void)storePassword:(NSString *)password hexapin:(NSString *)pin;

- (BOOL)isValidPIN:(NSString *)pin ;
-(NSString *)getPasswordFromPin:(NSString *)pin;


-(void)createSFDC;
//Encyption: END

- (NSArray *)getCreditCards;
- (AMCreditCardInfo *)getPrimaryCreditCard:(NSString *)cardID;
- (void)deleteCreditCards;
- (void)saveCreditCard:(AMCreditCardInfo *)cardInfo;
- (void)updateCreditCard:(AMCreditCardInfo *)cardInfo;
- (void)deleteCreditCardByCardId:(NSString *)cardId;
- (void)deleteLastSavedStoredCard:(void (^)(id))block;
- ( void)getReloadDenominations:(void (^)(id))block;
- (void)deleteCreditCardByCardId:(NSString *)cardId withCompletion:(void (^)(id))block;
- (void)setUserPin:(NSString *)pin withBlock:(void (^)(id))block;
- (NSArray *)getMarketCards;
- (AMMarketCardInfo *)getPrimaryMarketCard;
- (void)deleteMarketCards;
- (void)saveMarketCard:(AMMarketCardInfo *)cardInfo;
- (void)updateMarketCard:(AMMarketCardInfo *)cardInfo;
- (void)deleteMarketCardByCode:(NSString *)code;
- (void)getContactsUs:(void(^)(id))block;
- (void)getHasDiscounts:(void (^)(id))block;


- (void)getServerStoredCreditCards:(void (^)(id))block;
- (void)getServerUserbalance;
- (void)getUserbalance:(void (^)(id))block;
- (void)getDiscounts:(NSDate *) withDate block: (void (^)(id))block;

+(UIImage *)imageWithColor:(UIColor *)color ;
-(void)checkAndCreateSFDC;
-(void)getSalesForceToken:(void (^)(id))block;
-(NSString *)base64PasswordWithUserName:(NSString *)userName andPassword:(NSString *)password;
-(void )getAllSpecials:(void(^)(id))block;
-(void)getServerScanMarketCards:(void (^)(id))block;
+(void) saveUsernameAndPassword: (NSString *) userName password:(NSString *) password;
+(NSString *) getUsername;
+(NSString *) getPassword;

@end

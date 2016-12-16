//
//  AMUtilities.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 14/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AMUtilities.h"
#import "AvantiCommon.h"
#import "PBKDF2-Wrapper.h"
#import "AmsIdResponse.h"
#import "Denomination.h"
#import "DenominationWithBouns.h"
#import "DenominationWithBns.h"
#import "ShowContactUsReponse.h"
#import "SFToken.h"
#import "AllSpecials.h"
#import "DateTools.h"
#import "Discount.h"
#import "HasDiscounts.h"

NSString *const AMCreditCardSaveSuccessNotification     = @"AMCreditCardSaveSuccessNotification";
NSString *const AMMarketCardSaveSuccessNotification     = @"AMMarketCardSaveSuccessNotification";
NSString *const AMGetBalanceSuccessNotification         = @"AMGetBalanceSuccessNotification";
NSString *const AMSignOutSuccessNotification            = @"AMSignOutSuccessNotification";
NSString *const AMGetDiscountsSuccessNotification       = @"AMGetDiscountsSuccessNotification";

@interface NSData (PBKDF2WrapperExample)

- (NSString *)hexString;

@end

@implementation NSData (PBKDF2WrapperExample)

- (NSString *)hexString {
    return [[[self description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
}

@end


@interface AMUtilities ()

@property (nonatomic, strong) PBKDF2Configuration *configuration;

@end

@implementation AMUtilities

@synthesize internetStatusActive;
@synthesize videoPlaying;

static AMUtilities *sharedInstance = nil;

+ (AMUtilities *)sharedUtilities {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.loyalityArray = [[NSMutableArray alloc]init];
        sharedInstance.showContactUsReponse = [[ShowContactUsReponse alloc]init];
        sharedInstance.savedCreditCardArray = [[NSMutableArray alloc]init];
        sharedInstance.allSpecialArray = [[NSMutableArray alloc]init];
    });
    return sharedInstance;
}

+ (NSString *)reversedStringFromString:(NSString *)string {
    NSUInteger count = [string length];
    
    if (count <= 1) { // Base Case
        return string;
    }
    else {
        NSString *lastLetter = [string substringWithRange:NSMakeRange(count - 1, 1)];
        NSString *butLastLetter = [string substringToIndex:count - 1];
        return [lastLetter stringByAppendingString:[self reversedStringFromString:butLastLetter]];
    }
}

+(void) saveUsernameAndPassword: (NSString *) username password:(NSString *) password {
    [KeychainHelper setStringWithKey:username forKey:@"username"];
    [KeychainHelper setStringWithKey:password forKey:@"password"];
}


+(NSString *) getUsername {
    // add caching later
    return [KeychainHelper getStringWithKey:@"username"];
}

+(NSString *) getPassword {
    // add caching later
    return [KeychainHelper getStringWithKey:@"password"];
}


//Encyption: START
- (NSString *)generateKeyForPIN:(NSString *)pinValue withIteration:(NSUInteger)iteration{
    
    
    NSString *secretKey = @"";
    
    
    NSString *saltText = [NSString stringWithFormat:@"%@avanti", [AMUtilities reversedStringFromString:pinValue]];
    
    NSData *salt = [saltText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger rounds = 4832;
    
    PBKDF2Configuration *configuration = [[PBKDF2Configuration alloc] initWithSalt:salt
                                          
                                                                  derivedKeyLength:iteration
                                          
                                                                            rounds:rounds
                                          
                                                              pseudoRandomFunction:PBKDF2DefaultPseudoRandomFunction];
    
    
    
    PBKDF2Result *result = [[PBKDF2Result alloc] initWithPassword:pinValue configuration:configuration];
    
    [result calculateDerivedKey];
    
    
    
    secretKey = [result.derivedKey base64EncodedStringWithOptions:0];
    
    NSString *trimmedString= [secretKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (iteration == 189)
    {
        NSLog(@"-----------------------------");
        NSLog(@"\nPinHash:%@", trimmedString);
        NSLog(@"-----------------------------");
        
        
    }
    else  {
        NSLog(@"-----------------------------");
        NSLog(@"\nPinHashHash:%@", trimmedString);
        NSLog(@"-----------------------------");
        
    }
    return trimmedString;
    
    
}

- (void)storePassword:(NSString *)password pin:(NSString *)pin{
    NSString *keyPinHash =[[AMUtilities sharedUtilities] generateKeyForPIN:pin withIteration:189];;
    NSString *keyPinHashHash = [[AMUtilities sharedUtilities] generateKeyForPIN:keyPinHash withIteration:32];
    NSLog(@"KeyPinHash:%@\nkeyPinHashHash:%@",keyPinHash,keyPinHashHash);
    NSString *encryptedPassword = [StringEncryption encryptString:password key:keyPinHashHash];
    [[NSUserDefaults standardUserDefaults] setObject:encryptedPassword forKey:NSUSERDEFAULT_StoredEncryptedPass];
}

- (void)storePassword:(NSString *)password hexapin:(NSString *)hexaPin{
    NSString *keyPinHashHash = [[AMUtilities sharedUtilities] generateKeyForPIN:hexaPin withIteration:32];
    NSString *encryptedPassword = [StringEncryption encryptString:password key:keyPinHashHash];
    [[NSUserDefaults standardUserDefaults] setObject:encryptedPassword forKey:NSUSERDEFAULT_StoredEncryptedPass];
}

- (BOOL)isValidPIN:(NSString *)pin {
    NSString *keyPinHash =[[AMUtilities sharedUtilities] generateKeyForPIN:pin withIteration:189];;
    NSLog(@"Created Pin Hash :%@",[NSDate date]);
    NSString *keyPinHashHash = [[AMUtilities sharedUtilities] generateKeyForPIN:keyPinHash withIteration:32];;
    NSLog(@"Created Pin Hashhash :%@",[NSDate date]);
    
    NSLog(@"KeyPinHash:%@\nkeyPinHashHash:%@",keyPinHash,keyPinHashHash);
    
    NSString *encryptedStoredPassword = [[NSUserDefaults standardUserDefaults] stringForKey:NSUSERDEFAULT_StoredEncryptedPass];
    NSString *storedPassword = [StringEncryption decryptString:encryptedStoredPassword key:keyPinHashHash];
    
    //TODO:: make a call to the auth api again to verifiy the pin was correct
    return [storedPassword isEqualToString:[AMUtilities getPassword]];
}

-(NSString *)getPasswordFromPin:(NSString *)pin
{
    NSString *keyPinHash =[[AMUtilities sharedUtilities] generateKeyForPIN:pin withIteration:189];;
    NSString *keyPinHashHash = [[AMUtilities sharedUtilities] generateKeyForPIN:keyPinHash withIteration:32];
    NSLog(@"KeyPinHash:%@\nkeyPinHashHash:%@",keyPinHash,keyPinHashHash);
    
    NSString *encryptedStoredPassword = [[NSUserDefaults standardUserDefaults] stringForKey:NSUSERDEFAULT_StoredEncryptedPass];
    NSString *storedPassword = [StringEncryption decryptString:encryptedStoredPassword key:keyPinHashHash];
    return storedPassword;
    
}
//Encyption: END

#pragma mark CreditCards
- (NSArray *)getCreditCards {
    return [AMUtilities sharedUtilities].savedCreditCardArray;
}

- (AMCreditCardInfo *)getPrimaryCreditCard:(NSString *)cardID{
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getCreditCards]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cardID ==%@",cardID];
    [cards filterUsingPredicate:predicate];
    if (cards.count ==1)
    {
        return [cards objectAtIndex:0];
    }
    else
        return nil;
}

- (void)deleteCreditCards {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_CREDIT_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveCreditCard:(AMCreditCardInfo *)cardInfo {
    if (cardInfo.cardID == nil) {
        NSInteger cardID = [[NSUserDefaults standardUserDefaults] integerForKey:@"LastCreditCardID"];
        cardID = cardID + 1;
        cardInfo.cardID = [NSString stringWithFormat:@"%ld", (long)cardID];
        [[NSUserDefaults standardUserDefaults] setInteger:cardID forKey:@"LastCreditCardID"];
    }
    
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getCreditCards]];
    
    if (cardInfo.isPrimary) {
        for (AMCreditCardInfo *card in cards) {
            card.primary = NO;
        }
    }
    
    [cards addObject:cardInfo];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cards];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:NSUSERDEFAULT_CREDIT_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateCreditCard:(AMCreditCardInfo *)cardInfo {
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getCreditCards]];
    
    NSInteger indexForUpdate = 0, index = 0;
    for (AMCreditCardInfo *card in cards) {
        if ([card.cardID isEqualToString:cardInfo.cardID]){
            indexForUpdate = index;
        }
        if (cardInfo.isPrimary) {
            card.primary = NO;
        }
        index++;
    }
    
    if (indexForUpdate < cards.count) {
        [cards replaceObjectAtIndex:indexForUpdate withObject:cardInfo];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cards];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:NSUSERDEFAULT_CREDIT_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)deleteLastSavedStoredCard:(void (^)(id))block
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    

    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    
    [manager deleteObject:nil path:kPathDeleteLastSavedStoredCard
               parameters:nil
                  success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         NSLog(@"Card Deleted Successfully.....");
         block(nil);
         
     }
                  failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                      
                      
                      if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                      {
                          NSLog(@"Card Deleted Successfully.....");
                          
                      }
                      block(nil);
                      
                      
                  }];
    
}

-(void)deleteCreditCardByCardId:(NSString *)cardId withCompletion:(void (^)(id))block
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    
    [manager deleteObject:nil path:kPathDeleteStoredCard
               parameters:@{@"cardID": cardId}
                  success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         NSLog(@"Card Deleted Successfully with card id :%@.....",cardId);
         block(nil);
         
     }
                  failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                      
                      
                      if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                      {
                          NSLog(@"Card Deleted Successfully with card id :%@.....",cardId);
                          
                      }
                      block(nil);
                      
                      
                  }];
}


- (void)deleteCreditCardByCardId:(NSString *)cardId {
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getCreditCards]];
    NSInteger indexForDelete = 0;
    for (AMCreditCardInfo *card in cards) {
        if ([card.cardID isEqualToString:cardId]) {
            break;
        }
        indexForDelete++;
    }
    if (indexForDelete < cards.count) {
        [cards removeObjectAtIndex:indexForDelete];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cards];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:NSUSERDEFAULT_CREDIT_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark MarketCards
- (NSArray *)getMarketCards {
    @try {
        return nil;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (AMMarketCardInfo *)getPrimaryMarketCard{
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getMarketCards]];
    if (cards.count==0) {
        return nil;
    }
    
    NSInteger indexPrimaryCard = 0;
    for (AMMarketCardInfo *card in cards) {
        if (card.isPrimary) {
            break;
        }
        indexPrimaryCard++;
    }
    if (cards.count > 1) {
        if (indexPrimaryCard >= cards.count) {
            indexPrimaryCard = 0;
        }
    }
    else{
        indexPrimaryCard = 0;
    }
    return [cards objectAtIndex:indexPrimaryCard];
}

- (void)deleteMarketCards {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUSERDEFAULT_MARKET_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveMarketCard:(AMMarketCardInfo *)cardInfo {
    if (cardInfo.mScanCode == nil) {
        NSInteger cardID = [[NSUserDefaults standardUserDefaults] integerForKey:@"LastMarketCardID"];
        cardID = cardID + 1;
        cardInfo.mScanCode = [NSString stringWithFormat:@"%ld", (long)cardID];
        [[NSUserDefaults standardUserDefaults] setInteger:cardID forKey:@"LastMarketCardID"];
    }
    
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getMarketCards]];
    if (cardInfo.isPrimary) {
        for (AMMarketCardInfo *card in cards) {
            card.primary = NO;
        }
    }
    [cards addObject:cardInfo];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cards];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:NSUSERDEFAULT_MARKET_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateMarketCard:(AMMarketCardInfo *)cardInfo {
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getMarketCards]];
    NSInteger indexForUpdate = 0, index = 0;
    for (AMMarketCardInfo *card in cards) {
        if ([card.mScanCode isEqualToString:cardInfo.mScanCode]) {
            indexForUpdate = index;
        }
        if (cardInfo.isPrimary) {
            card.primary = NO;
        }
        index++;
    }
    
    if (indexForUpdate < cards.count) {
        [cards replaceObjectAtIndex:indexForUpdate withObject:cardInfo];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cards];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:NSUSERDEFAULT_MARKET_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteMarketCardByCode:(NSString *)code {
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[self getMarketCards]];
    NSInteger indexForDelete = 0;
    for (AMMarketCardInfo *card in cards) {
        if ([card.mScanCode isEqualToString:code]) {
            break;
        }
        indexForDelete++;
    }
    if (indexForDelete < cards.count) {
        [cards removeObjectAtIndex:indexForDelete];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cards];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:NSUSERDEFAULT_MARKET_CARDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark Fetch server Cards
- (void)getServerStoredCreditCards:(void (^)(id))block {
    // Response
    
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[StoredCardsResponse class]];
    [authMapping addAttributeMappingsFromDictionary:@{
                                                      @"cardID" : @"cardID",
                                                      @"cardType" : @"cardType",
                                                      @"lastFour" : @"lastFour",
                                                      @"expDate" : @"expDate",
                                                      @"isAutoChargeCard" : @"isAutoChargeCard"
                                                      }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObject:nil path:kPathGetStoredCards
            parameters:nil
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSArray *cardsResponse = [mappingResult array];
                   [[AMUtilities sharedUtilities].savedCreditCardArray removeAllObjects];
                   for (StoredCardsResponse *sc in cardsResponse)
                   {
                       AMCreditCardInfo *am = [[AMCreditCardInfo alloc] initWithStoredCardResponse:sc];
                       [[AMUtilities sharedUtilities].savedCreditCardArray addObject:am];
                   }
                   block(cardsResponse);
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   block(nil);
                   
               }];
    
    
}

- (void)getServerScanMarketCards:(void (^)(id))block {
    // Response
    
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[ScanCodesResponse class]];
    [authMapping addAttributeMappingsFromDictionary:@{ @"scanCode" : @"scanCode" }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObject:nil path:kPathGetScanCodes
            parameters:nil
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSArray *cardsResponse = [mappingResult array];
                   ScanCodesResponse *scanCodeResponse = [cardsResponse objectAtIndex:0];
                   self.scanCode = scanCodeResponse.scanCode;
                   block(self.scanCode);
               }
               failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   self.scanCode = nil;
                   block(self.scanCode);
               }];
    
}

-(void)getContactsUs:(void(^)(id))block
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    AuthenticateResponse *authResp = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    RKObjectMapping *transactionMapping = [RKObjectMapping mappingForClass:[ShowContactUsReponse class]];
    [transactionMapping addAttributeMappingsFromDictionary:@{
                                                             
                                                             @"Show_Contact_Us__c" : @"Show_Contact_Us__c",
                                                             }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:transactionMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];
    
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObject:nil path:KPathGetShowContactUs
            parameters:@{@"amsId":authResp.operatorId}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         //sucess
         app.retrySFDCCount ++;
         
         [AMUtilities sharedUtilities];
         ShowContactUsReponse *shouldShowResponse = [mappingResult firstObject];
         if ([shouldShowResponse.Show_Contact_Us__c isEqualToString:@"True"])
         {
             self.showContactUsReponse.Show_Contact_Us__c =@"1";
             
         }
         if ([shouldShowResponse.Show_Contact_Us__c isEqualToString:@"true"])
         {
             self.showContactUsReponse.Show_Contact_Us__c =@"1";
             
         }
         if ([shouldShowResponse.Show_Contact_Us__c isEqualToString:@"nil"])
         {
             self.showContactUsReponse.Show_Contact_Us__c =@"2";
             
         }
         if ([shouldShowResponse.Show_Contact_Us__c isEqualToString:@"False"])
         {
             self.showContactUsReponse.Show_Contact_Us__c =@"2";
             
         }
         if ([shouldShowResponse.Show_Contact_Us__c isEqualToString:@"nil"])
         {
             self.showContactUsReponse.Show_Contact_Us__c =@"2";
             
         }
         if (!shouldShowResponse.Show_Contact_Us__c)
         {
             self.showContactUsReponse.Show_Contact_Us__c =@"2";
             
         }
         block(mappingResult);
     }
     
     
               failure: ^(RKObjectRequestOperation *operation, NSError *error)
     
     {
         [AMUtilities sharedUtilities];
         self.showContactUsReponse.Show_Contact_Us__c =@"3";
         app.retrySFDCCount ++;
         
         if (operation.HTTPRequestOperation.response.statusCode == 401 && app.retrySFDCCount<4) {
             
             [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
              {
                  if ([obj isKindOfClass:[SFToken class]])
                  {
                      [[AMUtilities sharedUtilities]getContactsUs:^(id obj){}];
                  }
                  else
                  {
                      NSLog(@"Failed to get Token");
                      // displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                      
                  }
              }];
             
         }
         
         else  if (![AMUtilities sharedUtilities].isInternetWorking)
         {
             displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
         }
         else{
         }
         
         block(nil);
     }];
    
}

-(void)getSalesForceToken:(void (^)(id))block
{
    AuthenticateRequest *authRequest = [AuthenticateRequest authenticateResuestWithData:
                                        [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateRequest class])]
                                        ];
    
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[SFToken class]];
    [authMapping addAttributeMappingsFromDictionary:@{
                                                      @"token" : @"token",
                                                      
                                                      }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"userName", @"userPassword"]];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:authRequest.userName password:authRequest.userPassword];
    
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [manager addResponseDescriptor:responseDescriptor];
    
    
    [manager getObject:nil path:KPathGetSalesForceToken
            parameters:@{@"userName": @"", @"userPassword": @""}
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   self.token = mappingResult.firstObject;
                   block(self.token);
                   
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   block(nil);
                   
               }];
    
}


- (void)getServerUserbalance
{
    @try {
        NSLog(@"-----GetBalanceCall-----");

        
        // Request
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromArray:@[@"userName", @"userPassword"]];
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[AuthenticateRequest class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodAny];
        
        // Response
        RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[GetBalanceResponse class]];
        [authMapping addAttributeMappingsFromDictionary:@{
                                                          @"userBalance" : @"userBalance",
                                                          }];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                                method:RKRequestMethodAny
                                                                                           pathPattern:nil keyPath:nil
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        // RESTManager
        [RKObjectManager setSharedManager:nil];
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
            [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
        [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
        [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        
        [manager addRequestDescriptor:requestDescriptor];
        [manager addResponseDescriptor:responseDescriptor];
        
        [manager getObject:nil path:kPathGetBalance
                parameters:@{@"userName": @"", @"userPassword": @""}
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       //sucess
                       self.balance  = [mappingResult firstObject];
                       [[NSNotificationCenter defaultCenter] postNotificationName:AMGetBalanceSuccessNotification object:[NSNumber numberWithBool:true]];
                       
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception Reason in GetUserBalance:%@",exception.reason);
    }
    
}


- (void)getUserbalance:(void (^)(id))block
{
    
    // Request
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"userName", @"userPassword"]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[AuthenticateRequest class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodAny];
    
    // Response
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[GetBalanceResponse class]];
    [authMapping addAttributeMappingsFromDictionary:@{
                                                      @"userBalance" : @"userBalance",}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObject:nil path:kPathGetBalance
            parameters:@{@"userName": @"", @"userPassword": @""}
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   NSLog(@"RESPONSE: %@", operation.HTTPRequestOperation.responseString);
                   self.balance  = [mappingResult firstObject];
                   NSLog(@"BALANCE: %@", self.balance);
                   [[NSNotificationCenter defaultCenter] postNotificationName:AMGetBalanceSuccessNotification object:[NSNumber numberWithBool:true]];
                   
                   block(mappingResult);
                   
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   block(nil);
                   
               }];
}



- (void)filterDiscountsFromMappingResult:(NSDate *)withDate mappingResult:(RKMappingResult *)mappingResult {
    for (NSManagedObject *object in [mappingResult array]) {
        Discount *discount = (Discount *) object;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        NSUInteger timeComps = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute);
        NSDateComponents *components = [calendar components:timeComps fromDate:discount.startDate];
        [components setHour:discount.startHour];
        [components setMinute:discount.startMin];
        discount.startDate = [calendar dateFromComponents:components];

        components = [calendar components:timeComps fromDate:discount.endDate];
        [components setHour:discount.endHour];
        [components setMinute:discount.endMin];
        discount.endDate = [calendar dateFromComponents:components];

        if ([withDate compare:discount.startDate] == NSOrderedDescending && [discount.endDate compare:withDate] == NSOrderedDescending) {
            [self.discounts addObject:discount];
        }
    }
}

- (void)getDiscounts:(NSDate *) withDate block: (void (^)(id))block {
    
    // Request
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"userName", @"userPassword"]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[AuthenticateRequest class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodAny];
    // Response
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[Discount class]];
    [authMapping addAttributeMappingsFromDictionary:@{
                                                      @"Id" : @"productId",
                                                      @"Name" : @"name",
                                                      @"ProductGroups" : @"productGroups",
                                                      @"StartDate" : @"startDate",
                                                      @"StartHour" : @"startHour",
                                                      @"StartMin" : @"startMin",
                                                      @"EndDate" : @"endDate",
                                                      @"EndHour" : @"endHour",
                                                      @"EndMin" : @"endMin",
                                                      @"Amount" : @"amount",
                                                      @"BuyQuantity" : @"buyQuantity",
                                                      @"GetQuantity" : @"getQuantity",
                                                      @"DiscountTypeId" : @"discountTypeId"
                                                      }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];

    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    self.discounts = [[NSMutableArray alloc] init];
    [manager getObject:nil path:kPathGetDiscounts
            parameters: nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   [self filterDiscountsFromMappingResult:withDate mappingResult:mappingResult];
                   [[NSNotificationCenter defaultCenter] postNotificationName:AMGetDiscountsSuccessNotification object:[NSNumber numberWithBool:false]];
                   block(self.discounts);
                   
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   
                   block(nil);
                   
               }];
}

- (void)getHasDiscounts:(void (^)(id))block
{

    
    // Request
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"userName", @"userPassword"]];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[AuthenticateRequest class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodAny];
    // Response
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[HasDiscounts class]];
    [authMapping addAttributeMappingsFromDictionary:@{
                                                      @"result" : @"hasDiscounts"
                                                    }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
        [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    

    [manager getObject:nil path:kPathGetHasDiscounts
            parameters: nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   self.hasDiscounts = ((HasDiscounts *)[mappingResult firstObject]).hasDiscounts;
                   //[[NSNotificationCenter defaultCenter] postNotificationName:AMGetDiscountsSuccessNotification object:[NSNumber numberWithBool:false]];
                   block((self.hasDiscounts) ? self.discounts : nil);
                   
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   
                   block(nil);
                   
               }];
}


-(void)checkAndCreateSFDC
{
    AppDelegate *a = (AppDelegate *) [UIApplication sharedApplication].delegate;
    a.retrySFDCCount1 = 0;
    [[AMUtilities sharedUtilities]checkForSFDCWithblock:^(id obj)
     {
         AppDelegate *a = (AppDelegate *) [UIApplication sharedApplication].delegate;
         a.retrySFDCCount1 = 0;
         if ([obj isKindOfClass:[AmsIdResponse class]])
         {
             AmsIdResponse *amsResponse = (AmsIdResponse *)obj;
             if ([amsResponse.idSfdc isEqualToString:@"null"]|| [amsResponse.idSfdc isEqualToString:@""]|| (amsResponse.idSfdc.length==0)) {
                 //Create SFDC Account
                 
             }
             [self createSFDC];
             
         }
         else [self createSFDC];
     }];
}
-(void)checkForSFDCWithblock:(void (^)(id))block
{
    
    //use api:3 wih Ams IS to get SFDC id if not created id:null else id will be there.
    // https://byndlsfint.azurewebsites.net/api/Consumer?amsId=57921
    AuthenticateResponse *authReq = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[AmsIdResponse class]];
    [authMapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"idSfdc",
                                                      @"FirstName" : @"firstName",
                                                      @"LastName" : @"lastName",
                                                      @"AMS_Contact_ID__c" : @"AMS_Contact_ID__c",
                                                      @"AccountId" : @"AccountId",
                                                      @"Phone" : @"phoneNumber",
                                                      @"MobilePhone" : @"mobilePhoneNo",
                                                      @"Email" : @"email",
                                                      @"Contact_Relationship__c" : @"Contact_Relationship__c",
                                                      }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:authMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];
    
    [manager addResponseDescriptor:responseDescriptor];
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    
    [manager getObject:nil path:KPathAMSid
            parameters:@{@"amsId":authReq.amsId}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   AmsIdResponse *authResponse = [mappingResult firstObject];
                   app.retrySFDCCount1 ++;
                   if (authResponse) {
                       
                       [[NSUserDefaults standardUserDefaults] setObject:[authResponse data] forKey:NSStringFromClass([AmsIdResponse class])];
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       
                   }
                   block(authResponse);
                   
                   
                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   app.retrySFDCCount1 ++;
                   
                   if (operation.HTTPRequestOperation.response.statusCode == 401 && app.retrySFDCCount1<4) {
                       
                       [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                        {
                            if ([obj isKindOfClass:[SFToken class]])
                            {
                                [[AMUtilities sharedUtilities]checkForSFDCWithblock:^(id obj){}];
                            }
                            else
                            {
                                NSLog(@"Failed to get Token");
                                // displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                
                            }
                            
                            
                            
                        }];
                       
                   }
                   else if ([operation.HTTPRequestOperation.responseString isEqualToString:@"null"] && operation.HTTPRequestOperation.response.statusCode ==200 )//No sfdc Account
                       block(nil);
                   else block(nil);
                   
               }];
    
}
-(void)createSFDC
{
    
    //  api/Consumer/Create?firstName={firstName}&lastName={lastName}&amsId={amsId}&operatorId={operatorId}&phone={phone}&mobilePhone={mobilePhone}&email={email}
    AuthenticateResponse *authRes = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    AuthenticateRequest *authReq = [AuthenticateRequest authenticateResuestWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateRequest class])]];
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];
    
    
    
    [manager getObject:nil path:KPathCreateSFDC
            parameters:@{@"firstName":authRes.firstName,@"lastName":authRes.lastName,@"amsId":authRes.amsId,@"operatorId":authRes.operatorId ,@"phone":authRes.phoneNumber,@"mobilePhone":authRes.phoneNumber,@"email":authReq.userName}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   app.retrySFDCCount1 ++;
                   AmsIdResponse *authResponse = [AmsIdResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
                   authResponse.idSfdc = [mappingResult firstObject];
                   if (authResponse) {
                       
                       [[NSUserDefaults standardUserDefaults] setObject:[authResponse data] forKey:NSStringFromClass([AmsIdResponse class])];
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       
                   }
                   
                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   app.retrySFDCCount1 ++;
                   
                   if (operation.HTTPRequestOperation.response.statusCode == 401 && app.retrySFDCCount1<4) {
                       
                       
                       [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                        {
                            
                            
                            if ([obj isKindOfClass:[SFToken class]])
                            {
                                [[AMUtilities sharedUtilities]createSFDC];
                            }
                            else
                            {
                                NSLog(@"Failed to get Token");
                                //  displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                
                            }
                            
                        }];
                       
                   }
                   else if ( operation.HTTPRequestOperation.response.statusCode ==200 )//No sfdc Account
                       NSLog(@"**** RESPONSE FOR SFDC ACCOUNT IS:%@",operation.HTTPRequestOperation.responseString);
                   
               }];
    
}
-( void)getReloadDenominations:(void (^)(id))block
{
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    
    [manager.HTTPClient getPath:kPathGetReloadDenominations
                     parameters:nil
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"sdsd");
                            if ([responseObject isKindOfClass:[NSDictionary class]])
                            {
                                [[AMUtilities sharedUtilities].loyalityArray removeAllObjects];
                                NSDictionary *dic = (NSDictionary *)responseObject;
                                id obj1 = [dic objectForKey:@"reloadDenomination" ];
                                //reloadDenominationsWithBonuses
                                id obj2 = [dic objectForKey:@"reloadDenominationsWithBonuses" ];
                                //
                                NSArray *denominationArray=nil,*denominaWithBonus =nil;
                                
                                if ([obj1 isKindOfClass:[NSArray class]])
                                {
                                    denominationArray = obj1;
                                }
                                if ([obj2 isKindOfClass:[NSArray class]])
                                {
                                    denominaWithBonus = obj2;
                                }
                                //
                                for (int i=0; i<denominationArray.count; i++)
                                {
                                    DenominationWithBns *denB = [[DenominationWithBns alloc]init];
                                    denB.denominAmount = [[denominationArray objectAtIndex:i] floatValue];
                                    denB.bouns = 0;
                                    for (int i=0; i<denominaWithBonus.count; i++)
                                    {
                                        //denB.denominAmount = [[denominationArray objectAtIndex:0] floatValue];
                                        id a=  [[denominaWithBonus objectAtIndex:i ]valueForKey:@"denomination"];
                                        
                                        if ([a floatValue]== denB.denominAmount)
                                        {
                                            denB.bouns =[[[denominaWithBonus objectAtIndex:i ]valueForKey:@"bonusAmount"] floatValue]/100;
                                            break;
                                        }
                                        
                                        
                                    }
                                    [[AMUtilities sharedUtilities].loyalityArray addObject:denB];
                                    
                                }
                                
                            }
                            
                            block([AMUtilities sharedUtilities].loyalityArray);
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            if (!([AMUtilities sharedUtilities].isInternetWorking))
                            {
                                displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                            }
                            
                            else
                            {
                                displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                
                            }
                            block(nil);
                        }];

    
}

-(void)setUserPin:(NSString *)userPin withBlock:(void (^)(id))block;
{
    if (AVANTI_SERVER_API_RUN)
    {
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
        
        // Request
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromArray:@[@"userPin"]];
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[ChargeStoredCardRequest class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodAny];
        
        // RESTManager
        
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
        [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
        
        [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
        [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [manager addRequestDescriptor:requestDescriptor];
        
        NSString *newUserPin = userPin;
        newUserPin = [[AMUtilities sharedUtilities] generateKeyForPIN:newUserPin withIteration:189];
        [manager putObject:nil path:kPathSetUserPin parameters:@{@"userPin": newUserPin}
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       //  displayAlertWithMessage(@"Pin  Success");
                       
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                       if ([newUserPin length]==4)
                       {
                           [[AMUtilities sharedUtilities] storePassword:[AMUtilities getUsername] pin:newUserPin];
                           
                       }
                       else
                           [[AMUtilities sharedUtilities] storePassword:[AMUtilities getPassword] hexapin:newUserPin];
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       block(userPin);
                   }
                   failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       if ([AMUtilities sharedUtilities].isInternetWorking){
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       }
                       else{
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       }
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                       block(nil);
                       
                   }
         ];
    }
    
    
}
static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(NSString *)base64PasswordWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", userName, password];
    return [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)];
}


-(void)getAllSpecials:(void(^)(id))block
{
    //
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"specials" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *cardsResponse = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectForKey:@"rewards"];
    [[AMUtilities sharedUtilities].allSpecialArray removeAllObjects];
    for (int i=0; i<cardsResponse.count; i++)
    {
        //        "CurrentAmount": "0",
        //        "EndDate": "12/10/2015",
        //        "Message": "",
        //        "OfferDesc": "$0.50 Off buffalo",
        //        "ProdName": "Synder Buffalo",
        //        "RequiredAmount": "0",
        //        "StartDate": "12/10/2015",
        //        "id": 2
        id a = [cardsResponse objectAtIndex:i];
        AllSpecials *sc = [[AllSpecials alloc]init];
        sc.EndDate = [a objectForKey:@"EndDate"];
        sc.CurrentAmount = [[a objectForKey:@"CurrentAmount"]floatValue ];
        sc.StartDate = [a objectForKey:@"StartDate"];
        sc.ProdName = [a objectForKey:@"ProdName"];
        sc.OfferDesc = [a objectForKey:@"OfferDesc"];
        sc.message = [a objectForKey:@"Message"];
        sc.pID = [a objectForKey:@"id"];
        sc.RequiredAmount = [[a objectForKey:@"RequiredAmount"]floatValue ];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        sc.dateEnd = [dateFormat dateFromString:sc.EndDate];
        sc.dateStart = [dateFormat dateFromString:sc.StartDate];
        
        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        sc.dateEnd = [sc.dateEnd dateByAddingTimeInterval:timeZoneSeconds];
        sc.dateStart = [sc.dateStart dateByAddingTimeInterval:timeZoneSeconds];
        
        
        sc.isExpired = NO;
        NSInteger daySpan =  [sc.dateEnd daysFrom:[NSDate date]];
        if (daySpan>=0)
        {
            daySpan= daySpan+1;
            if (daySpan ==1 &&[sc.dateEnd compare:[NSDate date]] == NSOrderedAscending) {
                sc.category=@"1";
                
            }
            else if (daySpan ==1)
            {
                sc.category=@"2";
            }
            
            else  if (daySpan<7) {
                sc.category=@"3";
            }
            else if (daySpan<=30) {
                sc.category=@"4";
            }
            else if (daySpan<=60) {
                sc.category=@"5";
            }
            else if (daySpan<=90) {
                sc.category=@"6";
            }
            else
                sc.category=@"7";
            
        }
        NSInteger daySpan1 =  [sc.dateStart daysFrom:[NSDate date]];
        
        
        if  (daySpan1==0)
        {
            sc.category1 =@"1";
        }
        else  if (daySpan1>=-7) {
            sc.category1=@"3";
        }
        else if (daySpan1>=-30) {
            sc.category1=@"4";
        }
        else if (daySpan1>=-60) {
            sc.category1=@"5";
        }
        else if (daySpan1>=-90) {
            sc.category1=@"6";
        }
        else
            sc.category1=@"7";
        
        
        
        
        [[AMUtilities sharedUtilities].allSpecialArray addObject:sc];
    }
    
    [self sortAllSpecialArrayWithAlp];
    
    [self sortAllSpecialArray];
    
    //[NSThread sleepForTimeInterval:14.0f];
    block([AMUtilities sharedUtilities].allSpecialArray);
    
}

-(id)sortAllSpecialArray
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateEnd" ascending:TRUE];
    [[AMUtilities sharedUtilities].allSpecialArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return [AMUtilities sharedUtilities].allSpecialArray;
}
-(id)sortAllSpecialArrayWithAlp
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ProdName" ascending:TRUE];
    [[AMUtilities sharedUtilities].allSpecialArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return [AMUtilities sharedUtilities].allSpecialArray;
}

- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}
@end

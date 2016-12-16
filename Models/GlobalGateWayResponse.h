//
//  GlobalGateWayResponse.h
//  AvantiMarket
//
//  Created by Mobility Bangalore on 7/13/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalGateWayResponse : NSObject
@property(nonatomic,strong)NSString *x_url;
@property(nonatomic,strong)NSString *x_login;
@property(nonatomic,strong)NSString *x_show_form;
@property(nonatomic,strong)NSString *x_fp_sequence;
@property(nonatomic,strong)NSString *x_fp_hash;
@property(nonatomic,strong)NSString *x_amount;
@property(nonatomic,strong)NSString *x_currency_code;
@property(nonatomic,strong)NSString *x_test_request;
@property(nonatomic,strong)NSString *x_relay_response;
@property(nonatomic,strong)NSString *donation_prompt;
@property(nonatomic,strong)NSString *button_code;
@property(nonatomic,strong)NSString *mmc_operatorid;
@property(nonatomic,strong)NSString *mmc_marketuserid;
@property(nonatomic,strong)NSString *mmc_transactionid;
@property(nonatomic,strong)NSString *mmc_requesthost;
@property(nonatomic,strong)NSString *mmc_save_card_info;
@property(nonatomic,strong)NSString *x_fp_timestamp;
@end

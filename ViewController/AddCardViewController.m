//
//  AddCardViewController.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 7/10/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AddCardViewController.h"
#import "AMHomeViewController.h"
#import "AddCardWebViewController.h"
#import "GlobalGateWayResponse.h"
#import "DenominationWithBns.h"
#import "AMUtilities.h"
@interface AddCardViewController ()
{
    GlobalGateWayResponse *gateWayResponse;
}
@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [self setTitle:@"WAYS TO PAY"];

    id vc = [self.navigationController.childViewControllers objectAtIndex:0];
    
    if ([vc isKindOfClass:[AMHomeViewController class]]) {
        [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];

    }
    else
    {
        [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemSideMenu];
        
        
    }
   
    [self getDenmonFromServer];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setAvantiSide
{
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemSideMenu];

}


inline static void formatButtonWithBorderr(UILabel *btn, UIColor *textColor, UIColor *backgroudColor, BOOL isDisabled)  {
    btn.textColor = [UIColor whiteColor];
    [btn setNumberOfLines:2];
    [btn setTextAlignment:NSTextAlignmentCenter];
    [btn setEnabled:!isDisabled];
   // addBorderInViewWithValuee(btn, textColor,backgroudColor, 1.0f, 1.0f);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}
-(void)getDenmonFromServer
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    id vc = [self.navigationController.childViewControllers objectAtIndex:0];
    
//    if ([vc isKindOfClass:[self class]] )
//        [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
    self.view.userInteractionEnabled     = NO;
    [[AMUtilities    sharedUtilities]getReloadDenominations:^(id obj)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled     = YES;
         [self.tbl reloadData];
     }];
 
}
 -(void)backSideMenuButtonPressed:(id)sender
{
    id vc = [self.navigationController.childViewControllers objectAtIndex:0];
    if ([[AMUtilities sharedUtilities] getCreditCards].count==0)
    {
            // TODO: what to do
    }
   
    if ([vc isKindOfClass:[self class]] )
    {
        [super leftSideMenuButtonPressed:sender];
    }
    else
        [super backSideMenuButtonPressed:sender];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)onClickDenomonation:(UIButton *)btnTag
{
    [self getURlForLoadingWithValue:btnTag.tag];
 
}
-(void)getURlForLoadingWithValue:(long)value
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


    RKObjectMapping *transactionMapping = [RKObjectMapping mappingForClass:[GlobalGateWayResponse class]];
    [transactionMapping addAttributeMappingsFromDictionary:@{
                                                             @"x_url" : @"x_url",
                                                             @"x_login" : @"x_login",
                                                             @"x_show_form" : @"x_show_form",
                                                             @"x_fp_sequence" : @"x_fp_sequence",
                                                             @"x_fp_hash" : @"x_fp_hash",
                                                             @"x_amount" : @"x_amount",
                                                             @"x_currency_code" : @"x_currency_code",
                                                             @"x_test_request" : @"x_test_request",
                                                             @"x_relay_response" : @"x_relay_response",
                                                             @"donation_prompt" : @"donation_prompt",
                                                             @"button_code" : @"button_code",
                                                             @"mmc_operatorid" : @"mmc_operatorid",
                                                             @"mmc_marketuserid" : @"mmc_marketuserid",
                                                             @"mmc_transactionid" : @"mmc_transactionid",
                                                             @"mmc_requesthost" : @"mmc_requesthost",
                                                             @"mmc_save_card_info" : @"mmc_save_card_info",
                                                             @"x_fp_timestamp" : @"x_fp_timestamp",
                                                           
                                                             }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:transactionMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager addResponseDescriptor:responseDescriptor];

    [manager getObject:nil path: [self getCustomPath:[NSString stringWithFormat:@"%@/%ld",kPathGetGlobalGetWay, value]]
            parameters:nil
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   if ([mappingResult array].count > 0) {
                       gateWayResponse = [[mappingResult array]objectAtIndex:0];
                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                       AddCardWebViewController *webViewAddCard = [[AddCardWebViewController alloc]initWithNibName:@"AddCardWebViewController" bundle:nil];
                       webViewAddCard.parenntViewController =self.parenntViewController;
                       webViewAddCard.gateWay = gateWayResponse;
                       [self.navigationController pushViewController:webViewAddCard animated:YES];
                   }
                   else{
                        if(!operation.HTTPRequestOperation.response.statusCode ) {
                            displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                       }
                       else{
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                       }
                
                   }
                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                   
                   if(!operation.HTTPRequestOperation.response.statusCode ) {
                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       
                   }

                   else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                   {
                       ;
                   }
                   else
                   {
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }
               }];
    

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AMUtilities sharedUtilities].loyalityArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UILabel *dataLabel;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        CGRect frame = cell.contentView.frame;
        cell.backgroundColor = [UIColor clearColor];
        frame.size.width = frame.size.width -62;
        dataLabel = [[UILabel alloc] initWithFrame:frame];
        dataLabel.tag = indexPath.row+344;
        //Align it
        dataLabel.textAlignment= NSTextAlignmentCenter;
        [cell addSubview:dataLabel];
    }
    dataLabel = (UILabel*)[cell viewWithTag:indexPath.row+344];
    dataLabel.font = [UIFont fontWithName:FONT_Avenir_LT_Std_Medium size:16];
    DenominationWithBns *dB   =  [[AMUtilities sharedUtilities].loyalityArray objectAtIndex:indexPath.row];
    NSLog(@"%f:%f",dB.denominAmount,dB.bouns);
    if (dB.bouns ==0.0)
    {
        [dataLabel setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:155.0f/255.0f blue:213.0f/255.0f alpha:1.0f]];
        dataLabel.text = [NSString stringWithFormat:@"$%d",(int)ceil(dB.denominAmount)];
        
        // dataLabel.text = [NSString stringWithFormat:@"$%f",dB.denominAmount];
        
    }
    else
    {
        [dataLabel setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:155.0f/255.0f blue:213.0f/255.0f alpha:1.0f]];
        dataLabel.text = [NSString stringWithFormat:@"$%d\n%.02f Bonus",(int)ceil(dB.denominAmount), dB.bouns];
        
        // dataLabel.text = [NSString stringWithFormat:@"$%f\n%$%f Bonus",dB.denominAmount,dB.bouns];
        
        
    }

   formatButtonWithBorderr(dataLabel,   [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f], DEFAULT_COLOR_THEME_WHITE, NO);
    dataLabel.textAlignment= NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DenominationWithBns *dB   =  [[AMUtilities sharedUtilities].loyalityArray objectAtIndex:indexPath.row];
    [self getURlForLoadingWithValue:dB.denominAmount];

}

@end

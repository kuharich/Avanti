//
//  TransactionDetailViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 29/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "TransactionTableViewCell.h"
#import "TransactionBottomCell.h"
#import "DetailTableViewCell.h"
@interface TransactionDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableTransaction;
- (IBAction)tapOnEmailReciept:(id)sender;
@end

@implementation TransactionDetailViewController
{
    int noOfrow;
    BOOL addeed;
}

- (IBAction)tapOnEmailReciept:(id)sender{


}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    // Do any additional setup after loading the view from its nib.
    self.tableTransaction.delegate = nil;
    self.tableTransaction.dataSource = nil;

    self.title = self.history.navigationTitle;
    addBorderInViewWithValue(self.tableTransaction, [UIColor lightGrayColor], [UIColor whiteColor], 0, 0.25f);
}

- (void)viewWillAppear:(BOOL)animated{
    self.tableTransaction.delegate = nil;
    self.tableTransaction.dataSource = nil;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
    [super viewWillAppear:animated];
    [self getHistoryDetails];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    //[self getHistoryDetails];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    addeed = NO;
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 3) { // Purchase items
        if (self.history.getTransactionType == TransactionTypePurchase )
            return (noOfrow=4 + [self.history.transactionsCount shortValue]);

        return (noOfrow=3 + [self.history.transactionsCount shortValue]);
    }
    if (section == 2) { // Purchase items
        //return 2;
        return 1;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        if (indexPath.section == 3){
            [tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 10)];
        }
        else{
            [tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 2){
        return 50.0f;
    }
    else if (indexPath.section ==2){
        if (self.history.getTransactionType == TransactionTypeCreditBonus || self.history.getTransactionType == TransactionTypeCreateCard) {
            return 0.0f;
        }
        return 50.0f;
    }
    else if (indexPath.section == 4){
        return 77.0f;
    }
    else if (self.history.getTransactionType == TransactionTypeRewardEarned || self.history.getTransactionType == TransactionTypeCreateCard) {
        return 0.0f;
    }
    else if((self.history.getTransactionType == TransactionTypeReload || self.history.getTransactionType == TransactionTypeCreditBonus) && indexPath.row == [self.history.transactionsCount integerValue] + 1 ){
        return 0.0f;
    }
    
    else if (indexPath.section == 3 && indexPath.row == [self.history.transactionsCount integerValue]+2)
        return 30.0f;
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section <= 2) {
        static NSString *cellIdentifier = @"TransactionTableViewCell";
        
        TransactionTableViewCell *cell = (TransactionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            [cell.lblTitle setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
            [cell.lblSubTitle setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:14]];
            
            cell.lblTitle.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;
            cell.lblSubTitle.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.section == 0) {
            cell.lblTitle.text = @"Transaction Date:";
            cell.lblSubTitle.text = self.history.transactionDate;
        }
        else if (indexPath.section == 1) {
            if (self.history.transactionID.length > 0) {
                cell.lblTitle.text = @"Transaction Number:";
                cell.lblSubTitle.text = self.history.transactionID;
            }
            else if(self.history.getTransactionType == TransactionTypeCreateCard){
                cell.lblTitle.text = @"Market Card:";
                cell.lblSubTitle.text = self.history.marketCard;
            }
            else {
                [cell.lblTitle setHidden:YES];
                [cell.lblSubTitle setHidden:YES];
            }
           
        }
        else if (indexPath.section == 2) {
//            if (indexPath.row ==0) {
//                cell.lblTitle.text = @"Card Name:";
//                cell.lblSubTitle.text = self.history.cardName;
//            }
//            else
//            {
            if (self.history.cardType.length > 0) {
                cell.lblTitle.text = @"Card Type:";
                cell.lblSubTitle.text = self.history.cardType;
            } else {
                [cell.lblTitle setHidden:YES];
                [cell.lblSubTitle setHidden:YES];
            }
//            }
        }
        
        return cell;
    }
    else if (indexPath.section == 4){
        static NSString *cellIdentifier = @"TransactionBottomCell";
        
        TransactionBottomCell *cell = (TransactionBottomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionBottomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (![[self.history.pointsEarned stringValue]isEqualToString:@"0"])//Fix for AA-114
        {
            [cell.lblPointEarned setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
            [cell.lblTextPointEarned setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
            [cell.btnEmailReciept.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:12]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblPointEarned setText:[self.history.pointsEarned stringValue]];
            [cell.lblTextPointEarned setText:@"Points Earned"];
            
        }
        else
        {
            [cell.lblPointEarned setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
            [cell.lblTextPointEarned setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
            [cell.btnEmailReciept.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:12]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblPointEarned setText:@""];
            [cell.lblTextPointEarned setText:@""];
            
        }
        return cell;
    }
    static NSString *cellIdentifier1 = @"DetailTableViewCell";
    DetailTableViewCell *cell1 = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell1 == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
        
        [cell1.lblText setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
        [cell1.lblDetailText setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
        
        cell1.lblText.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;
        cell1.lblDetailText.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;
    }
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    static NSString *cellIdentifier = @"TransactionItemCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        [cell.textLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:15]];
        
        cell.textLabel.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;
        cell.detailTextLabel.textColor = DEFAULT_COLOR_THEME_TEXT_GRAY;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (self.history.getTransactionType == TransactionTypeRewardEarned || self.history.getTransactionType == TransactionTypeCreateCard) {
        return cell;
    }
    
    if(indexPath.row == 0){
        //PURCHASE
        if (self.history.getTransactionType == TransactionTypeReload) {
            cell.textLabel.text = @" Reload:";
            cell.detailTextLabel.text = displayTransactionAmount(self.history.transactionAmount);
        }
        else if (self.history.getTransactionType == TransactionTypeCreditBonus) {
            cell.textLabel.text = @" Bonus:";
            cell.detailTextLabel.text = displayTransactionAmount(self.history.transactionAmount);
        }
        else if (self.history.getTransactionType == TransactionTypePurchase) {
           // cell.textLabel.text = @" Purchase:";
           // cell.detailTextLabel.text = displayTransactionAmount(self.history.transactionAmount);
        }
        else{
            if ( self.history.getTransactionType != TransactionTypeStartBalance) {
                cell.textLabel.text = @" Amount:";
                cell.detailTextLabel.text = displayTransactionAmount(self.history.transactionAmount);
            }
          
        }
    }
    else if(indexPath.row == [self.history.transactionsCount integerValue] + 1 ){//row 1
        //TAX
        if (self.history.getTransactionType != TransactionTypeReload && self.history.getTransactionType != TransactionTypeCreditBonus && self.history.getTransactionType != TransactionTypeStartBalance) {
            cell.textLabel.text = @"Tax";
            cell.detailTextLabel.text = displayTransactionAmount(self.history.totalTax);
            if (self.history.totalTax.intValue ==0 &&self.history.getTransactionType!=TransactionTypePurchase)
            {
                cell.textLabel.text = @"";
                cell.detailTextLabel.text = @"";
            }
            }
    }
        
    else if(indexPath.row == noOfrow    -2){//row 1
        //TAX
        if (self.history.getTransactionType != TransactionTypeReload && self.history.getTransactionType != TransactionTypeCreditBonus && self.history.getTransactionType != TransactionTypeStartBalance) {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = displayTransactionAmount(self.history.transactionAmount);
            CGPoint startPoint = CGPointMake(20, 1);
            CGPoint endPoint = CGPointMake(cell.frame.size.width-20, 1);
            
            CGMutablePathRef straightLinePath = CGPathCreateMutable();
            CGPathMoveToPoint(straightLinePath, NULL, startPoint.x, startPoint.y);
            CGPathAddLineToPoint(straightLinePath, NULL, endPoint.x, endPoint.y);
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = straightLinePath;
            UIColor *fillColor = [UIColor lightGrayColor];
            shapeLayer.fillColor = fillColor.CGColor;
            UIColor *strokeColor = [UIColor lightGrayColor];
            shapeLayer.strokeColor = strokeColor.CGColor;
            shapeLayer.lineWidth = 0.5f;
            shapeLayer.fillRule = kCAFillRuleNonZero;
            [cell.layer addSublayer:shapeLayer];
            addeed=YES;
        
        }
        
    }
    else if(indexPath.row == noOfrow    -1){
        //TOTAL
        if (!addeed) {
            CGPoint startPoint = CGPointMake(20, 1);
            CGPoint endPoint = CGPointMake(cell.frame.size.width-20, 1);
            
            CGMutablePathRef straightLinePath = CGPathCreateMutable();
            CGPathMoveToPoint(straightLinePath, NULL, startPoint.x, startPoint.y);
            CGPathAddLineToPoint(straightLinePath, NULL, endPoint.x, endPoint.y);
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = straightLinePath;
            UIColor *fillColor = [UIColor lightGrayColor];
            shapeLayer.fillColor = fillColor.CGColor;
            UIColor *strokeColor = [UIColor lightGrayColor];
            shapeLayer.strokeColor = strokeColor.CGColor;
            shapeLayer.lineWidth = 0.5f;
            shapeLayer.fillRule = kCAFillRuleNonZero;
            [cell.layer addSublayer:shapeLayer];
        }
      
        cell.textLabel.text = @" Balance:";
        cell.detailTextLabel.text = displayTotalAmount(self.history.balance);
        
      
        
        //addBorderInViewWithValue(cell, [UIColor lightGrayColor], [UIColor whiteColor], 0, 0.25f);
    }
    else{
        //PRODUCT
        NSLog(@"indexpath.row %ld", (long)indexPath.row);
        TransactionItem *item = [self.history.transactionItems objectAtIndex:indexPath.row-1];
        cell1.lblText.text =  item.productName;;
        cell1.lblDetailText.text = displayTransactionAmount(item.productPrice);
        return cell1;
    }
    return cell;

}
-(void)getHistoryDetails
{
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    
    // Response
    
    // Create product  mapping
    RKObjectMapping *itemMapping = [RKObjectMapping mappingForClass:[TransactionItem class] ];
    // NOTE: When your source and destination key paths are symmetrical, you can use addAttributesFromArray: as a shortcut instead of addAttributesFromDictionary:
    [itemMapping addAttributeMappingsFromArray:@[ @"productName", @"productPrice" ]];
    
    // configure the Transaction mapping
    RKObjectMapping *transactionMapping = [RKObjectMapping mappingForClass:[GetHistoryResponse class]];
    [transactionMapping addAttributeMappingsFromDictionary:@{
                                                             @"transactionID" : @"transactionID",
                                                             @"transactionDate" : @"transactionDate",
                                                             @"transactionAmount" : @"transactionAmount",
                                                             @"transactionType" : @"transactionType",
                                                             @"location" : @"location",
                                                             @"balance" : @"balance",
                                                             @"kiosk" : @"kiosk",
                                                             @"marketCard" : @"marketCard",
                                                             @"pointsEarned" : @"pointsEarned",
                                                             @"totalTax" : @"totalTax",
                                                             @"cardType" : @"cardType",
                                                             @"cardName" : @"cardName",
                                                             @"transactionItems.@count": @"transactionsCount",
                                                             }];
    // Define the relationship mapping
    [transactionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"transactionItems"
                                                                                       toKeyPath:@"transactionItems"
                                                                                     withMapping:itemMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:transactionMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // RESTManager
    [RKObjectManager setSharedManager:nil];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:AVANTI_SERVER_API_URL]];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:[AMUtilities getUsername] password:[AMUtilities getPassword]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    //[manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    NSString *path = [NSString stringWithFormat:@"%@%@",kPathGetHistoryDetailsByID,self.transactionID];

    [manager getObject:nil path:path
            parameters:nil//@{ @"userName": authRequest.userName, @"userPassword": authRequest.userPassword }
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                   if ([mappingResult array].count > 0) {
                       self.tableTransaction.delegate = self;
                       self.tableTransaction.dataSource = self;

                       self.history =[mappingResult firstObject];
                      
                       [self.tableTransaction reloadData];
                   }
                   else{
                       
                       //displayAlertWithTitleMessage(HISTORY_NO_RECORD_ALERT_TITLE, HISTORY_NO_RECORD_ALERT_MESSAGE);
                   }
                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   if(!operation.HTTPRequestOperation.response.statusCode )
                   {
                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       
                   }
                   else{
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

               }];
}

@end

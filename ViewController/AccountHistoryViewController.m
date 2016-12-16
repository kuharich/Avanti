//
//  AccountHistoryViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 29/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AccountHistoryViewController.h"
#import "TransactionDetailViewController.h"
#import "LoadMoreCell.h"
@interface AccountHistoryViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIRefreshControl *refreshControl;
   __block int page;
    BOOL shouldLaodMore;
    BOOL navigatingToDetailscreen;
    LoadMoreCell * loadMoreCell;
}

@property (strong, nonatomic) NSMutableArray  *transactionHistoryItems;
@property (weak, nonatomic) IBOutlet UITableView *tableHistory;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;

@end

@implementation AccountHistoryViewController

#define ROWS_ON_PAGE   120

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"ACCOUNT HISTORY"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    self.tableHistory.delegate = nil;
    self.tableHistory.dataSource = nil;
    shouldLaodMore = YES;
    page = 0;
    self.lblNoRecords.text = @"";
    navigatingToDetailscreen= NO;
}



- (void)viewWillAppear:(BOOL)animated{
    
    if (navigatingToDetailscreen==NO) {
        self.tableHistory.hidden =YES;

        self.lblNoRecords.text = @"";
        [self setTitle:@"ACCOUNT HISTORY"];
        shouldLaodMore = YES;
        page = 0;
        [self.transactionHistoryItems removeAllObjects];
        [self getHistoryTransaction];
        [self.tableHistory setHidden:NO];
        [super viewWillAppear:animated];
    }
    else
        navigatingToDetailscreen =NO;

    [self orangeGradient];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
    [self customGradient];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
       if (navigatingToDetailscreen==NO) {
       //    [self.tableHistory setContentOffset:CGPointZero animated:YES];
}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (page ==0) {
        return 0;
    }
    return 1;

}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSLog(@".....No Of data in history is :%lu.....",(unsigned long)self.transactionHistoryItems.count);
    /*if (shouldLaodMore==YES)
    {
        return self.transactionHistoryItems.count+1;

    }
    else*/
    return self.transactionHistoryItems.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 20)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.textLabel.textColor = color;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor whiteColor] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:DEFAULT_COLOR_THEME_TEXT_GRAY ForCell:cell]; //normal color
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"historyCellIdentifier";
    static NSString *moreCellId = @"LoadMoreCell";
    UITableViewCell *cell = nil;
    NSLog(@"Index Path .row = %ld",(long)indexPath.row);
    
     

    if (indexPath.row == self.transactionHistoryItems.count)
    {
        
       loadMoreCell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
        if (loadMoreCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:nil];
            loadMoreCell = [nib objectAtIndex:0];
        }
        loadMoreCell.lblLoadMore.textColor = DEFAULT_COLOR_THEME_DARK_BLUE;
        loadMoreCell.lblLoadMore.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:18];;
        loadMoreCell.activityView.hidden = NO;
        if (page !=0)
        [loadMoreCell.activityView startAnimating];
        else
        {
            [loadMoreCell.activityView stopAnimating];
            NSLog(@"------CHECK-------");
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self getHistoryTransaction];
        return loadMoreCell;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        @try {
            GetHistoryResponse *history = [self.transactionHistoryItems objectAtIndex:indexPath.row];
            cell.textLabel.text = history.tableCellTitle;

        }
        @catch (NSException *exception) {
            ;
        }
      
        // Configure the cell...
        //NSLog(@"Index Path .row = %d",indexPath.row);
    }
    
    //[cell.textLabel setBounds:CGRectMake(50, 0, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height)];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleNone;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == self.transactionHistoryItems.count)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    TransactionDetailViewController *detailViewController = [[TransactionDetailViewController alloc] initWithNibName:@"TransactionDetailViewController" bundle:nil];
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    GetHistoryResponse *history = [self.transactionHistoryItems objectAtIndex:indexPath.row];
    detailViewController.history = history;
    detailViewController.transactionID = history.transactionID;
    navigatingToDetailscreen= YES;
}



-(void)getHistoryTransaction
{    self.tableHistory.hidden =NO;

    if (page ==0) {
        [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];

    }
    

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
    page = 0;
    NSString *path = [NSString stringWithFormat:@"%@%d",kPathGetHistoryByPage,page];

    [manager getObject:nil path:path
            parameters:nil//@{ @"userName": authRequest.userName, @"userPassword": authRequest.userPassword }
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   //sucess
                   self.tableHistory.delegate = self;self.tableHistory.dataSource = self;
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   [self.loadingIndicator stopAnimating];

                   if ([mappingResult array].count > 0) {
                       if ([mappingResult array].count == ROWS_ON_PAGE)
                       {
                           shouldLaodMore = YES;
                       }
                       if ([mappingResult array].count < ROWS_ON_PAGE)
                       {
                           shouldLaodMore = NO;
                       }
                       if (!self.transactionHistoryItems)
                       {
                           self.transactionHistoryItems = [[NSMutableArray alloc]init];
                       }
                       if (page ==0)
                       {
                           [self.transactionHistoryItems removeAllObjects];
                       }
                       [self.transactionHistoryItems addObjectsFromArray:[mappingResult array]];
                       NSMutableArray *history = self.transactionHistoryItems;
                       [self combineBonusesToActualTransactions: &history];
                       self.transactionHistoryItems = history;
                       page++;

                       [self.tableHistory reloadData];
                       [self.tableHistory setHidden:NO];
                   }
                   
                   else if(([mappingResult array].count==0) && (self.transactionHistoryItems.count ==0)){
                       shouldLaodMore = NO;
                       [self.tableHistory reloadData];

                       [self.loadingIndicator stopAnimating];
                       self.lblNoRecords.text = HISTORY_NO_RECORD_ALERT_MESSAGE;
                       [self.tableHistory setHidden:YES];
                       //displayAlertWithTitleMessage(HISTORY_NO_RECORD_ALERT_TITLE, HISTORY_NO_RECORD_ALERT_MESSAGE);
                   }
                 //
                   else if ([mappingResult array].count==0)
                   {
                       shouldLaodMore = NO;
                       [self.tableHistory reloadData];
                       [self.loadingIndicator stopAnimating];

                   }
                   
               } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   [self.loadingIndicator stopAnimating];
                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                    if(!operation.HTTPRequestOperation.response.statusCode ) {
                       self.lblNoRecords.text = NETWORK_ERROR_ALERT_MESSAGE;
                       [self.tableHistory setHidden:YES];

                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                   }
                   else{
                       [self.tableHistory setHidden:YES];

                       self.lblNoRecords.text = SERVER_ERROR_ALERT_MESSAGE;
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                   }
               }];
}



// Bug 2511 in VSO - if a there is a bonus immediately after a reload transaction, add the bonus amount to the reload transaction

NSString *bonusTransactionType = @"CreditBonus";
NSString *rechargeTransactionType = @"MMCCreditCardRecharge";

-(void) combineBonusesToActualTransactions: (NSMutableArray **) historyItems {
    if ( [*historyItems count] < 2) {
        return;
    }
    
    NSMutableArray *newResultArray = [[NSMutableArray alloc] init];
    int newIndex = 0;
    
    if ([((GetHistoryResponse *) [*historyItems lastObject]).transactionType isEqualToString: rechargeTransactionType]) {
        [newResultArray addObject: [*historyItems lastObject]];
        newIndex++;
    }
        
    for (long i=[*historyItems count]-2; i>=0; i--) {

        NSString *transactionType = ((GetHistoryResponse *) (*historyItems)[i]).transactionType;
        NSString *previousTransactionType = ((GetHistoryResponse *) (*historyItems)[i+1]).transactionType;

        if (![transactionType isEqualToString: bonusTransactionType]) {
            [newResultArray addObject: (*historyItems)[i]];
            newIndex++;
            continue;
        }
        if ([transactionType isEqualToString: bonusTransactionType] && [previousTransactionType isEqualToString: rechargeTransactionType]) {
            // TODO: maybe other conditions
            NSDecimalNumber *rechargeAmount = [NSDecimalNumber decimalNumberWithDecimal:[((GetHistoryResponse *) newResultArray[newIndex-1]).transactionAmount decimalValue]];
            NSDecimalNumber *bonusAmount = [NSDecimalNumber decimalNumberWithDecimal:[((GetHistoryResponse *) (*historyItems)[i]).transactionAmount decimalValue]];
            NSDecimalNumber *newAmount = [rechargeAmount decimalNumberByAdding: bonusAmount];
            ((GetHistoryResponse *) newResultArray[newIndex-1]).transactionAmount = (NSNumber *) newAmount;
        }
    }
    // newResultArray is now in reverse order
    *historyItems = [[NSMutableArray alloc] init];
    for (long i=[newResultArray count]-1; i >= 0; i--) {
        [*historyItems addObject: newResultArray[i]];
    }
}

@end

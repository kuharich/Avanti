//
//  AllSpecialTableViewController.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 11/17/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "AllSpecialTableViewController.h"
#import "AllSpecials.h"
#import "AMUtilities.h"
#import "MBProgressHUD.h"
#import "AllSpecialTableViewCell.h"
#import "AllBGTableViewCell.h"
#import "Discount.h"

@interface AllSpecialTableViewController ()
{
    NSMutableArray  *justAddedArry;
    UIColor *backgroundColor;
}

@end

@implementation AllSpecialTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    backgroundColor = [UIColor colorWithRed:232.0/255. green:235./255. blue:238./255. alpha:1.0];
    justAddedArry = [AMUtilities sharedUtilities].discounts;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true];
    [justAddedArry sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:TRUE];
    [justAddedArry sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
    
    [self.tableView reloadData];
    [super viewWillAppear:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AMUtilities sharedUtilities].discounts.count;

}

-(CALayer *) getSeparator {
    CALayer *separator = [CALayer layer];
    separator.backgroundColor = backgroundColor.CGColor;
    separator.frame = CGRectMake(0, 87, self.view.frame.size.width, 14);
    return separator;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AllSpecial";
    AllSpecialTableViewCell *cell = nil;
    static NSString *cellIdentifier1 = @"Cell";
    AllBGTableViewCell  *cell1 = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllSpecialTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
   
        // Configure the cell...
    Discount *discount = [justAddedArry objectAtIndex:indexPath.row];
    if (([discount.productGroups rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([discount.productGroups rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound)){
        cell.lblText.text = discount.name;
        cell.productGroups = [AllSpecialTableViewController getDetailText:discount.productGroups];
        cell.amountOff = [AllSpecialTableViewController getOffAmountText:discount.amount];
        cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",discount.endDate];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.endDate = discount.endDate;
        [cell.layer addSublayer:[self getSeparator]];
        
        return cell;

    } else {
        cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllBGTableViewCell" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        cell1.lblDetailText.text = discount.productGroups;
        cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
        cell1.endDate = discount.endDate;

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell1.layer addSublayer:[self getSeparator]];
        
        return cell1;

    }
 
}

+(NSString *) getOffAmountText:(NSString *) text {
    unsigned long pos = [[text lowercaseString] rangeOfString: @"off"].location;
    if (pos != NSNotFound) {
        return [text substringWithRange:NSMakeRange(0, pos + 3)];
    }
    return @"";
}

+(NSString *) getDetailText:(NSString *) text {
    unsigned long pos = [[text lowercaseString] rangeOfString: @"off"].location;
    if (pos != NSNotFound) {
        return [text substringFromIndex:pos + 4];
    }
    return text;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
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

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

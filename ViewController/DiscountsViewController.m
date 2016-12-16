//
//  DiscountsViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "DiscountsViewController.h"
#import "AllSpecialTableViewCell.h"
#import "AllSpecials.h"
#import "AMUtilities.h"
#import "AllBGTableViewCell.h"
#import "Discount.h"
#import "AAMixpanel.h"


@interface DiscountsViewController () {
    NSMutableArray  *justAddedArry;
    UIColor *backgroundColor;
}

@property (nonatomic, strong) NSArray *arrDiscounts;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation DiscountsViewController

@synthesize lblNoData;
@synthesize tableView;


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.lblNoData setHidden:[AMUtilities sharedUtilities].discounts.count > 0];
    [self.tableView setHidden:[AMUtilities sharedUtilities].discounts.count <= 0];
    
    backgroundColor =  [UIColor colorWithRed:232.0/255. green:235./255. blue:238./255. alpha:1.0];
    [self setTitle:@"OFFERS"];
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:19]}];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
    [self setCustomLabelColor: self.currentOffers];
    [self setCustomLightBackgroundColor:self.backgroundView];
    [AAMixpanel discountSuccess];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    justAddedArry = [AMUtilities sharedUtilities].discounts;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true];
    [justAddedArry sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:TRUE];
    [justAddedArry sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];

    [self.tableView reloadData];
    [self tallerGreenGradient:self.topBackgroundView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self tallerCustomGradient:self.topBackgroundView];
    
    [super viewWillAppear:YES];
    
}

-(CALayer *) getSeparator {
    CALayer *separator = [CALayer layer];
    separator.backgroundColor = backgroundColor.CGColor;
    separator.frame = CGRectMake(0, 87, self.view.frame.size.width, 8);
    return separator;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AMUtilities sharedUtilities].discounts.count;
}


- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AllSpecial";
    AllSpecialTableViewCell *cell = nil;
    static NSString *cellIdentifier1 = @"Cell";
    AllBGTableViewCell  *cell1 = nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[XibHelper XibFileName:@"AllSpecialTableViewCell"] owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [self setCustomLabelColor:cell.lblText];
    }
    
    // Configure the cell...

    Discount *discount = [justAddedArry objectAtIndex:indexPath.row];
    if (([discount.productGroups rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([discount.productGroups rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound)){
        cell.lblText.text = discount.name;
        cell.productGroups = discount.productGroups;
        cell.amountOff = discount.amount;
        cell.discountTypeId = discount.discountTypeId;
        cell.endDate = discount.endDate;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.endDate = discount.endDate;
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
        
    } else {
        cell1 = [t dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllBGTableViewCell" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        cell1.lblDetailText.text = discount.productGroups;
        cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
        cell.endDate = discount.endDate;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //[cell1.layer addSublayer:[self getSeparator]];
        
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
- (void)tableView:(UITableView *) t commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [t deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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



@end

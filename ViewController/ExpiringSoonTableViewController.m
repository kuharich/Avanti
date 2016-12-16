//
//  ExpiringSoonTableViewController.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 11/17/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "ExpiringSoonTableViewController.h"
#import "AllSpecials.h"
#import "AMUtilities.h"
#import "AllSpecialTableViewCell.h"
#import "DateTools.h"
#import "AllBGTableViewCell.h"

@interface ExpiringSoonTableViewController ()
{
    NSMutableArray *category1;
    NSMutableArray *category2;
    NSMutableArray *category3;
    NSMutableArray  *justAddedArry;

}

@end

@implementation ExpiringSoonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated

{
    category1 = [[NSMutableArray alloc]init];
    category2 = [[NSMutableArray alloc]init];
    category3 = [[NSMutableArray alloc]init];
    justAddedArry = [AMUtilities sharedUtilities].allSpecialArray;

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ProdName" ascending:true];
    [justAddedArry sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    for (AllSpecials *sc in justAddedArry)
    {
        if ([sc.category isEqualToString:@"1"]) {
            [category1 addObject:sc];
            continue    ;
        }
        else if ([sc.category isEqualToString:@"2"]||[sc.category isEqualToString:@"3"]) {
            [category2 addObject:sc];
            continue    ;

        }
        else if ([sc.category isEqualToString:@"4"]) {
            [category3 addObject:sc];
            continue    ;

        }
        
    }
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"dateEnd" ascending:TRUE];
    [category1 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
    [category2 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
    [category3 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];

    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0)
    {
        return category1.count;
    }
    else if (section ==1)
    {
        return category2.count;
    }
    else if (section ==2)
    {
        return category3.count;
    }
    return 0;
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
    cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell1 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllBGTableViewCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    // Configure the cell...
      
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;

    
    AllSpecials *allSPecail = nil;
    if (indexPath.section ==0) {
        allSPecail = [category1 objectAtIndex:indexPath.row];
        if (([allSPecail.OfferDesc rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([allSPecail.OfferDesc rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound))
        {
            cell.lblText.text = allSPecail.ProdName;
            cell.lblDetailText.text = allSPecail.OfferDesc;

            cell.lblDate.text = @"Only 1 day left!";
            cell.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];
            return cell;
        }
        else
        {
            cell1.lblDetailText.text = allSPecail.OfferDesc;
            cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
            cell1.lblDate.text = @"Only 1 day left!";
            cell1.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];

            return cell1;
        }
    }
    else if(indexPath.section ==1)
    {
        allSPecail = [category2 objectAtIndex:indexPath.row];
        if (([allSPecail.OfferDesc rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([allSPecail.OfferDesc rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound))
        {
            cell.lblDate.text = @"Only 1 day left";
            cell.lblText.text = allSPecail.ProdName;
            cell.lblDetailText.text = allSPecail.OfferDesc;

            NSInteger daySpan =  [allSPecail.dateEnd daysFrom:[NSDate date]];
            if  ([allSPecail.category isEqualToString:@"1"])
            {
                daySpan =1;
            
            }
            else if  ([allSPecail.category isEqualToString:@"2"])
                daySpan =2;

            else daySpan=daySpan+2;
            
            if (daySpan ==1)
                cell.lblDate.text = [NSString stringWithFormat:@"Only %ld day left!",daySpan];
            else
                cell.lblDate.text = [NSString stringWithFormat:@"Only %ld days left!",daySpan];
            cell.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];
            return cell;
        }
        else
        {
            cell1.lblDate.text = @"Only 1 day left";
            cell1.lblDetailText.text = allSPecail.OfferDesc;
            cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
            NSInteger daySpan =  [allSPecail.dateEnd daysFrom:[NSDate date]];
            if  ([allSPecail.category isEqualToString:@"1"]) {
                daySpan =1;
                
            }
            else if  ([allSPecail.category isEqualToString:@"2"])
                daySpan =2;
            
            else daySpan=daySpan+2;
            if (daySpan ==1)
                cell1.lblDate.text = [NSString stringWithFormat:@"Only %ld day left!",daySpan];
            else
                cell1.lblDate.text = [NSString stringWithFormat:@"Only %ld days left!",daySpan];
            cell1.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];
            return cell1;

        }
    }
    else if(indexPath.section ==2)
    {
        allSPecail = [category3 objectAtIndex:indexPath.row];

        if (([allSPecail.OfferDesc rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([allSPecail.OfferDesc rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound))
        {
            cell.lblText.text = allSPecail.ProdName;
            cell.lblDetailText.text = allSPecail.OfferDesc;
            cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",allSPecail.EndDate ];
            cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];

            //cell.lblDate.textColor =[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
            return cell;
        }
        else
        {
            cell1.lblDetailText.text = allSPecail.OfferDesc;
            cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
            allSPecail = [category3 objectAtIndex:indexPath.row];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",allSPecail.EndDate ];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];

           // cell1.lblDate.textColor =[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
            return cell1;

        }

    }
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section ==0)
//    {
//        return @"EXPIRING TODAY";
//    }
//    else if (section ==1)
//    {
//        return @"EXPIRING IN 7 DAYS";
//    }
//    else if (section ==2)
//    {
//        return @"EXPIRING IN 30 Days";
//    }
//    else  if (section ==3)
//    {
//        return @"EXPIRING IN 60 Days";
//    }
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((category1.count ==0)&& (section==0))
        return 0;
    if ((category2.count ==0)&& (section==1))
        return 0;
    if ((category3.count ==0)&& (section==2))
        return 0;
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((category1.count ==0)&& (section==0))
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 1)];
    if ((category2.count ==0)&& (section==1))
        return [[UIView alloc]initWithFrame:CGRectZero];
    if ((category3.count ==0)&& (section==2))
        return [[UIView alloc]initWithFrame:CGRectZero];
    UILabel *label = [[UILabel alloc]init];
    [label setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:FONT_Avenir_LT_Std_Medium size:10]];
    [label setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]];
    [label setTextColor:[UIColor blackColor]];

    if(section ==0)
    {
        label.text= @"  EXPIRING TODAY";
    }
    else if (section ==1)
    {
        label.text= @"  EXPIRING IN 7 DAYS";
    }
    else if (section ==2)
    {
        label.text= @"  EXPIRING IN 30 DAYS";
    }
    else  if (section ==3)
    {
        label.text= @"EXPIRING IN 60 Days";
    }
    
     return label;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

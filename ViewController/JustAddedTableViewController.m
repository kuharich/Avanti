//
//  JustAddedTableViewController.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 11/17/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "JustAddedTableViewController.h"
#import "AllSpecialTableViewCell.h"
#import "AllSpecials.h"
#import "AMUtilities.h"
#import "DateTools.h"
#import "AllBGTableViewCell.h"
#import "Discount.h"

@interface JustAddedTableViewController ()
{
    NSMutableArray *category1;
    NSMutableArray *category2;
    NSMutableArray *category3;
    NSMutableArray  *justAddedArry;

}

@end

@implementation JustAddedTableViewController

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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateStart" ascending:false];
    NSSortDescriptor *sortDescriptor1    = [[NSSortDescriptor alloc] initWithKey:@"ProdName" ascending:TRUE];


    [justAddedArry sortUsingDescriptors:@[sortDescriptor1,sortDescriptor]];
    for (Discount *sc in justAddedArry)
    {
        if ([sc.category1 isEqualToString:@"3"]||[sc.category1 isEqualToString:@"1"]) {
            [category1 addObject:sc];
            continue;
        }
        else if ([sc.category1 isEqualToString:@"4"]) {
            [category2 addObject:sc];
            continue;

        }
        else if ([sc.category1 isEqualToString:@"5"]) {
            [category3 addObject:sc];
            continue;

        }
        
    }
//    [category1 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    [category2 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    [category3 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AllSpecial";
    AllSpecialTableViewCell *cell = nil;
     static NSString *cellIdentifier1 = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllSpecialTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    AllBGTableViewCell  *cell1 = nil;
    cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell1 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllBGTableViewCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    // Configure the cell...
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    AllSpecials *allSPecail = nil;
    if (indexPath.section ==0) {
        allSPecail = [category1 objectAtIndex:indexPath.row];
          if (([allSPecail.OfferDesc rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([allSPecail.OfferDesc rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound)){
        cell.lblText.text = allSPecail.ProdName;
        cell.lblDetailText.text = allSPecail.OfferDesc;
        cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];
              cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];

      //  cell.lblDate.textColor =[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
              return cell;
          }
        else
        {  cell1.lblDetailText.text = allSPecail.OfferDesc;
            cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];
           // cell1.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];

            return cell1;

            
        }
    }
    else if(indexPath.section ==1)
    {
        allSPecail = [category2 objectAtIndex:indexPath.row];
          if (([allSPecail.OfferDesc rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([allSPecail.OfferDesc rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound)){
        cell.lblText.text = allSPecail.ProdName;
        cell.lblDetailText.text = allSPecail.OfferDesc;
        cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",allSPecail.EndDate ];
              cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];
              return cell;
          }
        else
        {
            cell1.lblDetailText.text = allSPecail.OfferDesc;
            cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",allSPecail.EndDate ];
            //cell1.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];
            return cell1;

        }
        
    }
    else if(indexPath.section ==2)
    {
        allSPecail = [category3 objectAtIndex:indexPath.row];
          if (([allSPecail.OfferDesc rangeOfString:@"buy" options:NSCaseInsensitiveSearch].location == NSNotFound) && ([allSPecail.OfferDesc rangeOfString:@"get" options:NSCaseInsensitiveSearch].location == NSNotFound)){
        cell.lblText.text = allSPecail.ProdName;
        cell.lblDetailText.text = allSPecail.OfferDesc;
        cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",allSPecail.EndDate ];
              cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];
              return cell;
          }
        else
        {
            cell1.lblDetailText.text = allSPecail.OfferDesc;
            cell1.lblDetailText.text = [cell1.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell1.lblDetailText.text length])];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",allSPecail.EndDate ];
            cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];
            
            return cell1;
        }
    }
  
    return cell;
}

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
        return [[UIView alloc]initWithFrame:CGRectZero];
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
        label.text= @"  ADDED IN THE LAST 7 DAYS";
    }
    else if (section ==1)
    {
        label.text= @"  ADDED IN THE LAST 30 DAYS";
    }
    else if (section ==2)
    {
        label.text= @"  ADDED IN THE LAST 60 DAYS";
    }
        
    return label;
}

@end

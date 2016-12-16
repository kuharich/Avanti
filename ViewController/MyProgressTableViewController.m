//
//  MyProgressTableViewController.m
//  AvantiMarket
//
//  Created by Mobility Bangalore on 11/17/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "MyProgressTableViewController.h"
#import "MyProgressTableViewCell.h"
#import "AMUtilities.h"
#import "AllSpecials.h"
#import "DateTools.h"
#import "CircleProgressBar.h"
#import "AllSpecialTableViewCell.h"
#import "MyProgressBGTableViewCell.h"
@interface MyProgressTableViewController ()
{
    NSMutableArray *category1;
    NSMutableArray *category2;
    NSMutableArray *category3;
    BOOL isPromotionForUSer ;
    NSMutableArray  *justAddedArry;
    NSMutableArray *category0;

}

@end

@implementation MyProgressTableViewController

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
    category0 = [[NSMutableArray alloc]init];

    category1 = [[NSMutableArray alloc]init];
    category2 = [[NSMutableArray alloc]init];
    category3 = [[NSMutableArray alloc]init];
    isPromotionForUSer = NO;
    justAddedArry = [AMUtilities sharedUtilities].allSpecialArray;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ProdName" ascending:true];
    [justAddedArry sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    for (AllSpecials *sc in justAddedArry)
    {
        if (sc.CurrentAmount!=0) {
            isPromotionForUSer = YES;
            break;
        }
    }
    //Make isPromotionForUSer == YES/NO two see both the screen here
  //  isPromotionForUSer = NO;
    if (isPromotionForUSer == NO)
    {

    
        for (AllSpecials *sc in justAddedArry)
        {
            if (sc.RequiredAmount==0)
            {
            
                continue;
            }
            else
            {
                [category1 addObject:sc];

            }
        }
    }
    if (isPromotionForUSer == YES){
    for (AllSpecials *sc in [AMUtilities sharedUtilities].allSpecialArray)
    {
        if (sc.RequiredAmount==0 || sc.message.length>0)
        {
            continue;
        }
        if ([sc.category isEqualToString:@"1"]||[sc.category isEqualToString:@"2"]||[sc.category isEqualToString:@"3"]) {
            [category1 addObject:sc];
            continue;

        }
       
        else if ([sc.category isEqualToString:@"4"]||[sc.category isEqualToString:@"5"]) {
            [category2 addObject:sc];
            continue;

            
        }
        else if ([sc.category isEqualToString:@"6"]|| [sc.category isEqualToString:@"7"]) {
            [category3 addObject:sc];
            continue;

        }
    }
    }
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"dateEnd" ascending:TRUE];
    [category1 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
    [category2 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
    [category3 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
    
    for (AllSpecials *sc in [AMUtilities sharedUtilities].allSpecialArray)
    {
        if (sc.message.length)
        {
            [category0 addObject:sc];
        }
    }
    [category0 sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (isPromotionForUSer == NO)
    
    {
        return 2;
    }
    int noOfScetion = 0;
    
    if (category1.count!=0) {
        noOfScetion ++;
    }
    if (category2.count!=0) {
        noOfScetion ++;
    }
    if (category3.count!=0) {
        noOfScetion ++;
    }
   // return noOfScetion;
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isPromotionForUSer == NO)
        
    {
        if (section ==1)
        {
            return category1.count;
        }
        if  (section ==0)
            return 0;
    
    }

    if (section ==0)
    {
        return category0.count;
    }
    else if (section ==1)
    {
        return category1.count;
    }
    else if (section ==2)
    {
        return category2.count;
    }
    else if (section ==3)
    {
        return category3.count;
    }
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyProgressBGTableViewCell";
    static NSString *cellIdentifier2 = @"MyProgressTableViewCell";

    MyProgressBGTableViewCell *cell = nil;
    MyProgressTableViewCell *cell2 = nil;
    
    if (isPromotionForUSer == NO)
        
    {
        AllSpecialTableViewCell *cell1 = nil;
        
        cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllSpecialTableViewCell" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        // Configure the cell...
        AllSpecials *allSPecail = [category1 objectAtIndex:indexPath.row];;
        cell1.lblText.text = allSPecail.ProdName;
        cell1.lblDetailText.text = allSPecail.OfferDesc;
        cell1.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5]];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
 
    }
 

    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyProgressBGTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    if (cell2 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyProgressTableViewCell" owner:self options:nil];
        cell2 = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    AllSpecials *allSPecail = nil;
    if (indexPath.section ==0) {
        allSPecail = [category0 objectAtIndex:indexPath.row];
     //   cell2.lblDate.text = @"Only 1 day left";
        cell2.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];
        NSInteger daySpan =  [allSPecail.dateEnd daysFrom:[NSDate date]];
        if  ([allSPecail.category isEqualToString:@"1"]) {
            daySpan =1;
            
        }
        else if  ([allSPecail.category isEqualToString:@"2"])
            daySpan =2;
        else daySpan=daySpan+2;
//        if (daySpan ==1)
//            cell2.lblDate.text = [NSString stringWithFormat:@"Only %ld day left!",daySpan];
//        else
//            cell2.lblDate.text = [NSString stringWithFormat:@"Only %ld days left!",daySpan];
        __block float pro = (float)(allSPecail.CurrentAmount/allSPecail.RequiredAmount);
        cell2.progressView.startAngle = 90.0;
        [cell2.progressView setProgress:pro animated:NO];
        cell2.lblDescription.text = allSPecail.message;
        [cell2.progressView setHintTextGenerationBlock:^NSString *(CGFloat progress) {
            return [NSString stringWithFormat:@"%d/%d",(int)allSPecail.CurrentAmount,(int)allSPecail.RequiredAmount];;
        }];
        cell2.lblDetailText.text = allSPecail.OfferDesc;
        cell2.lblDetailText.text = [cell2.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell2.lblDetailText.text length])];
        return cell2;
    }
    else if (indexPath.section ==1) {
        allSPecail = [category1 objectAtIndex:indexPath.row];
        cell.lblDate.text = @"Only 1 day left";
        cell.lblDate.textColor =[UIColor colorWithRed:213.0/255.0 green:95.0/255.0 blue:0.0/255.0 alpha:1.0];
        NSInteger daySpan =  [allSPecail.dateEnd daysFrom:[NSDate date]];
        if  ([allSPecail.category isEqualToString:@"1"]) {
            daySpan =1;
            
        }
        else if  ([allSPecail.category isEqualToString:@"2"])
            daySpan =2;
        else daySpan=daySpan+2;
        if (daySpan ==1)
            cell.lblDate.text = [NSString stringWithFormat:@"Only %ld day left!",daySpan];
        else
        cell.lblDate.text = [NSString stringWithFormat:@"Only %ld days left!",daySpan];
        __block float pro = (float)(allSPecail.CurrentAmount/allSPecail.RequiredAmount);
        cell.progressView.startAngle = 90.0;
        [cell.progressView setProgress:pro animated:NO];
        cell.lblDescription.text = allSPecail.message;
        [cell.progressView setHintTextGenerationBlock:^NSString *(CGFloat progress) {
            return [NSString stringWithFormat:@"%d/%d",(int)allSPecail.CurrentAmount,(int)allSPecail.RequiredAmount];;
        }];
        
    }
    else if(indexPath.section ==2)
    {
        allSPecail = [category2 objectAtIndex:indexPath.row];
        cell.lblDate.text = @"Only 1 day left";
        cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",[allSPecail.EndDate substringToIndex:5] ];
      //  cell.lblDate.textColor =[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
        float pro = allSPecail.CurrentAmount/allSPecail.RequiredAmount;
        cell.progressView.startAngle = 90.0;
        [cell.progressView setProgress:pro animated:NO];
        cell.lblDescription.text = allSPecail.message;

       // cell.progressView.progressLabel.text =[NSString stringWithFormat:@"%d/%d",(int)allSPecail.CurrentAmount,(int)allSPecail.RequiredAmount];
        [cell.progressView setHintTextGenerationBlock:^NSString *(CGFloat progress) {
            return [NSString stringWithFormat:@"%d/%d",(int)allSPecail.CurrentAmount,(int)allSPecail.RequiredAmount];;
        }];
    }
    else if(indexPath.section ==3)
    {
        allSPecail = [category3 objectAtIndex:indexPath.row];
        cell.lblDate.text = [NSString stringWithFormat:@"Ends %@",allSPecail.EndDate];
       // cell.lblDate.textColor =[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
        float pro = allSPecail.CurrentAmount/allSPecail.RequiredAmount;
        cell.progressView.startAngle = 90.0;
        [cell.progressView setProgress:pro animated:NO];
        cell.lblDescription.text = allSPecail.message;

        //cell.progressView.progressLabel.text =[NSString stringWithFormat:@"%d/%d",(int)allSPecail.CurrentAmount,(int)allSPecail.RequiredAmount];
        [cell.progressView setHintTextGenerationBlock:^NSString *(CGFloat progress) {
            return [NSString stringWithFormat:@"%d/%d",(int)allSPecail.CurrentAmount,(int)allSPecail.RequiredAmount];;
        }];
    }
    cell.lblDetailText.text = allSPecail.OfferDesc;
       cell.lblDetailText.text = [cell.lblDetailText.text stringByReplacingOccurrencesOfString:@"get" withString:@"\nget" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cell.lblDetailText.text length])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isPromotionForUSer == NO)
        
    {
        if(section ==0)
        {
            return self.NoDataView.frame.size.height;
        }
        else return 25;
        
    }
    if (section==0) {
        return 0;
    }
    if ((category1.count ==0)&& (section==1))
        return 0;
    if ((category2.count ==0)&& (section==2))
        return 0;
    if ((category3.count ==0)&& (section==3))
        return 0;

    return 25;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    
    return UITableViewCellEditingStyleNone;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((category1.count ==0)&& (section==1))
        return [[UIView alloc]initWithFrame:CGRectZero];
    if ((category2.count ==0)&& (section==2))
        return [[UIView alloc]initWithFrame:CGRectZero];
    if ((category3.count ==0)&& (section==3))
        return [[UIView alloc]initWithFrame:CGRectZero];
    
    UILabel *label = [[UILabel alloc]init];
    [label setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:FONT_Avenir_LT_Std_Medium size:10]];
    [label setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]];
    [label setTextColor:[UIColor blackColor]];

    if (isPromotionForUSer == NO)
        
    {
        if(section ==0)
        {
            return self.NoDataView;
        }
        else if (section ==1)
        {
            label.text= @"  YOUR MARKET CURRENT SPECIAL";
        }
        
    }
    
    if (section==0)
        return [[UIView alloc]initWithFrame:CGRectZero];
  else   if(section ==1)
    {
        label.text= @"  EXPIRING THIS WEEK";
    }
    else if (section ==2)
    {
        label.text= @"  EXPIRING IN 60 DAYS";
    }
    else if (section ==3)
    {
        label.text= @"  EXPIRING IN 90+ DAYS";
    }
   
    
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (category0.count && indexPath.section==0)
    {
        return 125;
    }
    else return 101;
}
@end

//
//  PayViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 31/03/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "PayViewController.h"
#import "AvantiCommon.h"
#import "AMUtilities.h"
@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblPrimary;
@property (weak, nonatomic) IBOutlet UILabel *lblMyBusinessCard;
@property (weak, nonatomic) IBOutlet UIView *viewBarcode;

@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBarCode;

@property (weak, nonatomic) IBOutlet UILabel *lblScanToPay;

@property (weak, nonatomic) IBOutlet UILabel *lblBalanceHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *lblBarCodeValue;//ISBN 978 - 3 -16 - 148410 - 0
@property (weak, nonatomic) IBOutlet UILabel *lblBarCodeValueBottom;//9    783161 484100
- (IBAction)tapOnDone:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *myMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *myMarketLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnDone:)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    [self.viewBarcode addGestureRecognizer:self.tapRecognizer];
    
    [self setTitle:@"PAY"];
    
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:243.0/255.0 green:241.0/255.0 blue:234.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:[self quicksandFontName] size:21]}];
    
    [self.lblBalanceHeader setFont:[UIFont fontWithName:[self quicksandFontName] size:self.lblBalanceHeader.font.pointSize]];
    [self.lblBalanceHeader setFont:[UIFont fontWithName:[self quicksandBoldFontName] size:self.lblBalanceHeader.font.pointSize] range:NSMakeRange(0, 6)];
    [self setCustomBodyTextColor:self.btnDone.titleLabel];
    [self setCustomTitleTextColorAttribute:self.navigationController.navigationBar];
    [self tallerGreenGradient:self.topBackgroundView];
    [self tallerCustomGradient: self.topBackgroundView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setCustomLabelColor: self.myMobileLabel];
    [self setCustomLabelColor: self.myMarketLabel];
    [self setCustomLabelColor: self.lblBalance];
    [self setCustomTitleColor: self.lblBalanceHeader];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadMarketCardDetail {
    [[AMUtilities sharedUtilities] getUserbalance:^(id obj){
        if ([AMUtilities sharedUtilities].scanCode != nil) {
            GetBalanceResponse *balance = [AMUtilities sharedUtilities].balance;
            
            self.lblBalance.text = displayBalance(balance.userBalance);
        }
        else{
            self.lblBalance.text = displayBalance([NSNumber numberWithInteger:0]);
        }
        NSString *mScanCode = [AMUtilities sharedUtilities].scanCode;
        NSLog(@"Scan code is: %@", mScanCode);
        
        if (mScanCode.length==11) {
            //  ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
            ZXUPCAWriter *writer = [[ZXUPCAWriter alloc]init];
            ZXBitMatrix *result = [writer encode:mScanCode
                                          format:kBarcodeFormatUPCA
                                           width:self.imgViewBarCode.frame.size.width
                                          height:self.imgViewBarCode.frame.size.height-20.0f
                                           error:nil];
            if (result) {
                ZXImage *image = [ZXImage imageWithMatrix:result];
                self.imgViewBarCode.image = [UIImage imageWithCGImage:image.cgimage];
                self.imgViewBarCode.hidden = NO;
            } else {
                self.imgViewBarCode.image = nil;
                self.imgViewBarCode.hidden = YES;
            }
            self.lblBarCodeValue.text = [NSString stringWithFormat:@"ISBN %@ - %@ -%@ - %@  ",
                                         [mScanCode substringWithRange:NSMakeRange(0, 3)],
                                         [mScanCode substringWithRange:NSMakeRange(3, 1)],
                                         [mScanCode substringWithRange:NSMakeRange(4, 2)],
                                         [mScanCode substringWithRange:NSMakeRange(6, 5)]
                                         ];//400035452322
            self.lblBarCodeValueBottom.text = [NSString stringWithFormat:@"%@    %@ %@",
                                               [mScanCode substringWithRange:NSMakeRange(0, 1)],
                                               [mScanCode substringWithRange:NSMakeRange(1, 6)],
                                               [mScanCode substringWithRange:NSMakeRange(7, 4)]
                                               ];
        }
        else  if (mScanCode.length==12) {
            ZXUPCAWriter *writer = [[ZXUPCAWriter alloc]init];
            ZXBitMatrix *result = [writer encode:mScanCode
                                          format:kBarcodeFormatUPCA
                                           width:self.imgViewBarCode.frame.size.width
                                          height:self.imgViewBarCode.frame.size.height-20.0f
                                           error:nil];
            if (result) {
                
                if (result) {
                    ZXImage *image = [ZXImage imageWithMatrix:result];
                    self.imgViewBarCode.image = [UIImage imageWithCGImage:image.cgimage];
                    self.imgViewBarCode.hidden = NO;
                } else {
                    self.imgViewBarCode.image = nil;
                    self.imgViewBarCode.hidden = YES;
                }
                self.lblBarCodeValue.text = [NSString stringWithFormat:@"ISBN %@ - %@ -%@ - %@  ",
                                             [mScanCode substringWithRange:NSMakeRange(0, 3)],
                                             [mScanCode substringWithRange:NSMakeRange(3, 1)],
                                             [mScanCode substringWithRange:NSMakeRange(4, 2)],
                                             [mScanCode substringWithRange:NSMakeRange(6, 6)]
                                             ];//4000 3545 2322
                self.lblBarCodeValueBottom.text = [NSString stringWithFormat:@"%@    %@ %@",
                                                   [mScanCode substringWithRange:NSMakeRange(0, 1)],
                                                   [mScanCode substringWithRange:NSMakeRange(1, 6)],
                                                   [mScanCode substringWithRange:NSMakeRange(7, 5)]
                                                   ];
            }
        }
        else{
            self.imgViewBarCode.hidden = YES;
            self.lblBarCodeValue.text = @"";
            self.lblBarCodeValueBottom.text = @"";
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    // AMMarketCardInfo *amCard = [[AMUtilities sharedUtilities] getPrimaryMarketCard];
    //self.imgViewBarCode.image = nil;
    [super viewWillAppear:animated];
    [[AMUtilities sharedUtilities] getServerScanMarketCards:^(id obj){
        [self loadMarketCardDetail];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBalanceNotification:)
                                                 name:AMGetBalanceSuccessNotification object:nil];
}

- (void)getBalanceNotification:(id)noti{
    NSNumber *respose = [noti object];
    if ([respose boolValue]) {
        GetBalanceResponse *balance = [AMUtilities sharedUtilities].balance;
        self.lblBalance.text = displayBalance(balance.userBalance);
    }
}


- (void)getDiscountsNotification:(id)noti{
    NSNumber *respose = [noti object];
    if ([respose boolValue]) {
        GetBalanceResponse *balance = [AMUtilities sharedUtilities].balance; // TODO: hmm why is this called
        
        self.lblBalance.text = displayBalance(balance.userBalance);
    }
}

- (void)viewDidAppear:(BOOL)animated{
    //    [[AMUtilities sharedUtilities] getServerUserbalance];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [PayViewController cancelPreviousPerformRequestsWithTarget:self];
    [super viewWillDisappear:animated];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)tapOnDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //    [[AMUtilities sharedUtilities] getServerUserbalance];
    
    //    [UIView  beginAnimations:nil context:NULL];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationDuration:0.75];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    //    [UIView commitAnimations];
}
@end

//
//  MarketCardView.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 08/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "MarketCardView.h"

@interface MarketCardView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgCardbackground;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCard;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) AMMarketCardInfo *myMarketCard;
- (IBAction)tapOnDelete:(id)sender;

@end

@implementation MarketCardView

@synthesize mScanCode;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnDelete addTarget:self.delegate action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMarketCardDetail:(AMMarketCardInfo *)cardInfo balance:(NSNumber *)tBalance{
    self.mScanCode = cardInfo.mScanCode;
    self.myMarketCard = cardInfo;
    self.lblTitleCard.text = @"";//cardInfo.cardName;
    self.lblBalance.text = displayBalance(tBalance);
    
    switch (cardInfo.color) {
        case MarketCardColorAqua:
            [self.imgCardbackground setImage:[UIImage imageNamed:@"bgCardAqua.png"]];
            break;
            
        case MarketCardColorBlue:
            [self.imgCardbackground setImage:[UIImage imageNamed:@"bgCardBlue.png"]];
            break;
        default:
            [self.imgCardbackground setImage:[UIImage imageNamed:@"bgCardGreen.png"]];
            break;
    }

}

- (IBAction)tapOnDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonPressed:)]) {
        [self.delegate deleteButtonPressed:self];
    }
}

@end

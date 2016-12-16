 //
//  CreditCardView.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 13/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "CreditCardViewController.h"

@interface CreditCardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIImageView *imgCardType;


@property (weak, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblExpiryDate;
@property (weak, nonatomic) IBOutlet UILabel *lblZipCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCardTypeLabel;

@property(nonatomic, strong) AMCreditCardInfo *cardInfo;

@property (weak, nonatomic) IBOutlet UIButton *btnCardArea;


@end

@implementation CreditCardViewController

BOOL iamSelected = NO;

@synthesize delegate;


- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle selected: (BOOL) selected
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self == nil) {
        return nil;
    }
    iamSelected = selected;
    return self;
}


- (NSString *)cardID{
    if (self.cardInfo) {
        return self.cardInfo.cardID;
    }
    return nil;
}

- (void)loadCreditCardDetail:(AMCreditCardInfo *)ccInfo{
    self.cardInfo = ccInfo;
    self.lblCardNumber.text = self.cardInfo.creditCardInfo.redactedCardNumber;
    self.lblZipCode.text = self.cardInfo.creditCardInfo.cardTypeOne;
    self.lblExpiryDate.text = [NSString stringWithFormat:@"Expires: %@", self.cardInfo.expiryDate];
    self.imgCardType.image = [AMCreditCardInfo logoForCardType:ccInfo.creditCardInfo.cardType];//CardIOCreditCardInfo
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnDelete addTarget:self.delegate action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCardArea addTarget:self.delegate action:@selector(cardTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewWillAppear: (BOOL) animated {
    [self.borderImage setHidden:!iamSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cardTapped:(id)sender {
}

-(void) selectCard {
    [self.borderImage setHidden:NO];
    NSLog(@"Selected card: %@", self.cardID);
    // has no effect [self.view setNeedsDisplay];
}

-(void) deselectCard {
    [self.borderImage setHidden:YES];
    NSLog(@"Deselected card: %@", self.cardID);
    // has no effect [self.view setNeedsDisplay];
}

@end

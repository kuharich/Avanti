//
//  FeedbackViewController.m
//  AvantiMarket
//
//  Created by Deepak Sahu on 21/04/15.
//  Copyright (c) 2016 Byndl. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Feedback.h"
#import "FeedBackRequest.h"
#import "AAMixpanel.h"
#import "SFToken.h"
@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblContactTitle;

@property (strong, nonatomic) NSArray *arrCategory;
@property (strong, nonatomic) NSString *selectedCategory;

@property (strong, nonatomic) NIDropDown *dropDownCategory;

@property (weak, nonatomic) IBOutlet UIButton *btnCategoty;
- (IBAction)tapOnCategory:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)tapOnNext:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewConfirmation;

@end

@implementation FeedbackViewController

#define PLACEHODER_TEXT     @"Please share your feedback and suggestions here"

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.txtDescription.text.length == 0){
        self.txtDescription.textColor = [UIColor lightGrayColor];
        self.txtDescription.text = PLACEHODER_TEXT;
        [self.txtDescription resignFirstResponder];
    }
    
    [self resignView:self.view];
}


- (void) niDropDown:(NIDropDown *)dropDown didSelectIndexPath:(NSIndexPath *)indexPath{
    self.selectedCategory = [self.arrCategory objectAtIndex:indexPath.row];
    self.dropDownCategory = nil;
    [self setNextButtonActiveInactive];
}

- (void)setNextButtonActiveInactive{
    
    BOOL isActive = (self.selectedCategory.length > 0);
    self.txtDescription.editable = isActive;
    self.txtDescription.selectable = isActive;
    
    BOOL submitIsEnabled = (isActive && ![self.txtDescription.text isEqualToString:PLACEHODER_TEXT]);
    self.btnNext.alpha = (submitIsEnabled) ? 1.0 : 0.66;
    self.btnNext.userInteractionEnabled = submitIsEnabled;
    
}

- (void)viewDidLoad {
    [self setTitle:@"SHARE YOUR FEEDBACK"];
    [super viewDidLoad];
    
    [self setupMenuBarButtonItemsShow:LeftMenuBarButtonItemBackItem];
    
//    self.arrCategory = [NSArray arrayWithObjects:@"App Features and Reliability", @"Market Product Selection and Prices", @"Market Product Quality", @"Market Appearance and Condition", @"Customer Support", nil];
    self.selectedCategory = nil;

    self.txtDescription.textColor = [UIColor lightGrayColor];
    [self setNextButtonActiveInactive];

    [self setCustomRegularButtonTextColor:self.btnNext];
    [self setCustomRegularButtonBackgroundColor: self.btnNext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOnCategory:(id)sender {

    if(self.dropDownCategory == nil) {
        self.dropDownCategory = [[NIDropDown alloc] showDropDown:self.btnCategoty height:self.arrCategory.count * 50 list:self.arrCategory
                                                         imgList:nil direction:@"down"];
        self.dropDownCategory.delegate = self;
    }
    else {
        [self.dropDownCategory hideDropDown:sender];
        self.dropDownCategory = nil;
    }
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.textColor == [UIColor lightGrayColor]) {
        textView.text = @"";
        textView.textColor = [UIColor grayColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = PLACEHODER_TEXT;
        [textView resignFirstResponder];
    }
    [self setNextButtonActiveInactive];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(textView.text.length == 0){
            textView.textColor = [UIColor lightGrayColor];
            textView.text = PLACEHODER_TEXT;
            [textView resignFirstResponder];
        }
        return NO;
    }
    NSString *updateString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (updateString.length > 500) {
        return NO;
    }
    return YES;
}

- (IBAction)tapOnNext:(id)sender {
    
    if (self.selectedCategory && self.txtDescription.text.length>0) {
        //next
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        app.retrySFDCCount = 0;
        [self postFeedBack];
          }
    
}
//Added By Jyoti
-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    app.retrySFDCCount = 0;
        [AAMixpanel pageView:@"Share Your Feedback"];
    if (self.arrCategory.count>0) {
        ;
    }
    else
    [self getFeedbackType];
}
#pragma mark - Get FeedBack list
-(void)getFeedbackType
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];

        NSLog(@"**************************");
        NSLog(@"GET ALL FEEDBACKS TYPE:");
        NSLog(@"*************************");
    
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];

        [manager.HTTPClient getPath:kGetFeedbackList
                 parameters:nil
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        app.retrySFDCCount++;
                         self.arrCategory = responseObject;
                        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                        
//                        self.btnCategoty.titleLabel.textColor  = [UIColor blackColor];

                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
                        app.retrySFDCCount++;
                        if (operation.response.statusCode == 401 && app.retrySFDCCount<4) {
                            
                            [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                             {
                                 if ([obj isKindOfClass:[SFToken class]])
                                 {
                                     [self getFeedbackType];
                                 }
                                 else
                                 {
                                     NSLog(@"Failed to get Token");
                                     displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                     
                                 }
                             }];
                            
                        }
                        if (app.retrySFDCCount  >=4)
                        {
                            if(!operation.response.statusCode )

                                displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);

                        else
                            displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                        [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                        }
                        else
                        {
                            if(!operation.response.statusCode )
                            {
                                displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                            }
                            else
                                displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                        }
                    }];



}
#pragma mark - CREATE FeedBack
-(void)postFeedBack
{
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

    //check for Valid SFDC Account
    // [[AMUtilities sharedUtilities]checkAndCreateSFDC];
    
    //api/Case/CreateFeedback?consumerAmsId={consumerAmsId}&feedbackCategory={feedbackCategory}&feedbackDetails={feedbackDetails}
    AuthenticateResponse *authRes = [AuthenticateResponse authenticateResponseWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([AuthenticateResponse class])]];
    [MBProgressHUD showHUDAddedTo:[[AppDelegate sharedDelegate] window] animated:YES];
    NSLog(@"**************************");
    NSLog(@"CREATE FEEDBACKS :");
    NSLog(@"*************************");
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SDFC_SERVER_URL]];
    [manager.HTTPClient setDefaultHeader:@"Accept" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[AMUtilities sharedUtilities].token.token]];

    
    [manager getObject:nil path:kPathPostFeedback
            parameters:@{@"consumerAmsId": authRes.amsId, @"feedbackCategory":  self.selectedCategory,@"feedbackDetails":self.txtDescription.text}
               success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   app.retrySFDCCount++;

                   //Mixpanel
                   [AAMixpanel submitFeedbackSuccess:self.selectedCategory];
                   //sucess
                   if ([mappingResult array].count > 0) {
                       self.arrCategory = mappingResult.firstObject;
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                       self.viewConfirmation.hidden = NO;
                       [self.view bringSubviewToFront:self.viewConfirmation];
                       [AAMixpanel pageView:@"Feedback Success Screen"];
                   }
               }
     
               failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                   app.retrySFDCCount++;

                   [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                   if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                   {
                       [AAMixpanel submitFeedbackSuccess:self.selectedCategory];
                       NSLog(@"***** Feedback id= %@***** ",operation.HTTPRequestOperation.responseString);
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                       self.viewConfirmation.hidden = NO;
                       [self.view bringSubviewToFront:self.viewConfirmation];
                   }
                   if (operation.HTTPRequestOperation.response.statusCode == 401&& app.retrySFDCCount<4) {
                       
                       [[AMUtilities sharedUtilities] getSalesForceToken:^(id obj)
                        {
                            if ([obj isKindOfClass:[SFToken class]])
                            {
                                [self postFeedBack];
                            }
                            else
                            {
                                NSLog(@"Failed to get Token");
                                displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                                
                            }

                        }];
                       
                   }

                   if (app.retrySFDCCount  >=4)
                   {
                    if(!operation.HTTPRequestOperation.response.statusCode )
                   {
                       [AAMixpanel submitFeedbackFailure:self.selectedCategory errortype:@"Network Error" witherrorCode:nil];
                       displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                   }
                   else if  (operation.HTTPRequestOperation.responseString.length && operation.HTTPRequestOperation.response.statusCode ==200 )//Not server error actually
                   {
                       [AAMixpanel submitFeedbackSuccess:self.selectedCategory];
                       NSLog(@"***** Feedback id= %@***** ",operation.HTTPRequestOperation.responseString);
                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];
                       self.viewConfirmation.hidden = NO;
                       [self.view bringSubviewToFront:self.viewConfirmation];
                   }
                   else
                   {
                       if(!operation.HTTPRequestOperation.response.statusCode )
                           
                       {
                           displayAlertWithTitleMessage(NETWORK_ERROR_ALERT_TITLE, NETWORK_ERROR_ALERT_MESSAGE);
                       }
                       
                       else
                           displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);

                       [MBProgressHUD hideAllHUDsForView:[[AppDelegate sharedDelegate] window] animated:YES];

                       [AAMixpanel submitFeedbackFailure:self.selectedCategory errortype:@"Server Error" witherrorCode:[@(operation.HTTPRequestOperation.response.statusCode) stringValue]];
                       displayAlertWithTitleMessage(SERVER_ERROR_ALERT_TITLE, SERVER_ERROR_ALERT_MESSAGE);
                       
                   }
                   }
                  
               }];
    
    
    
}



@end

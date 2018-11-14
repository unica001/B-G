//
//  BGOrderSummaryViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 30/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferViewController.h"
#import "ApplyPromoCode.h"
#import "Remove.h"
#import "BGRegistrationViewController.h"
#import "BGPaymentTypeViewController.h"
#import "BGThankYouViewController.h"
#import "PayPalPayment.h"
#import "PayPalMobile.h"

#define kPayPalEnvironment PayPalEnvironmentSandbox

typedef enum PaymentStatuses {
    PAYMENTSTATUS_SUCCESS,
    PAYMENTSTATUS_FAILED,
    PAYMENTSTATUS_CANCELED,
} PaymentStatus;



@interface BGOrderSummaryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,promoCodeDelegare,ApplyPromoCodeRequestDelegate,RemovePromoCodeRequestDelegate,PayPalPaymentDelegate,UIPopoverControllerDelegate,ConfirmOrderRequestDelegate,SWRevealViewControllerDelegate>{

    __weak IBOutlet UITableView *orderSummaryTabel;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    NSMutableDictionary *promocodeDictionary;
    BOOL removePromo;
    BOOL invalidCoupon;
    BOOL applyPromo;
    
    UIButton *applyButton;
    UITextField *promocodeTextField;
    MyinfoView *myView;
    BOOL show_thank;
    
@private
    CGFloat y;
    BOOL resetScrollView;
    PaymentStatus status;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;
@property (nonatomic,retain) NSMutableDictionary *summaryDictionary;
@property (nonatomic,strong) NSString *dateText;
@property (nonatomic) BOOL orderExists;
@property(nonatomic,strong)NSString *dateString,*totalPrice;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) NSString *resultText;

- (IBAction)paymentButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;

@end

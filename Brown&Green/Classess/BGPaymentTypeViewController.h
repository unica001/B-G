//
//  BGPaymentTypeViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 02/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentTypeCell.h"
#import "ConfirmOrder.h"
#import "MyinfoView.h"
#import "BGThankYouViewController.h"
#import "PayPalPayment.h"
#import "PayPalMobile.h"

//#define kPayPalEnvironment PayPalEnvironmentNoNetwork
//
//typedef enum PaymentStatuses {
//    PAYMENTSTATUS_SUCCESS,
//    PAYMENTSTATUS_FAILED,
//    PAYMENTSTATUS_CANCELED,
//} PaymentStatus;

@interface BGPaymentTypeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ConfirmOrderRequestDelegate,PayPalPaymentDelegate, UIPopoverControllerDelegate>{
    __weak IBOutlet UITableView *_paymentType;
    __weak IBOutlet UIButton *_payNowButton;
    NSInteger onlinePayment;
    MyinfoView *myView;
    BOOL show_thank;


//@private
//    CGFloat y;
//    BOOL resetScrollView;
//    PaymentStatus status;

}
@property (nonatomic,retain)NSMutableDictionary *summaryDicationary;
@property (nonatomic,strong) NSString *dateText;
@property (nonatomic) BOOL orderExists;
@property(nonatomic,strong)NSString *dateString,*totalPrice;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) NSString *resultText;



- (IBAction)payNowButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
@end

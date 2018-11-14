//
//  BGDeliveryScheduleViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 30/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetDeliverySlotRequest.h"
#import "MyinfoView.h"
#import "DateWiseOrderSummary.h"
#import "PlaceOrder.h"
#import "BGOrderSummaryViewController.h"
#import "MyCartViewController.h"


@interface BGDeliveryScheduleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GetDeliverySlotRequestDelegate,continueDelegate,PlaceOrderRequestDelegate,SWRevealViewControllerDelegate>{
    NSMutableArray *timeSlotArray;
    IOFDB *iofDB;

    NSMutableDictionary *selectedSlotDictionary;
    NSMutableDictionary *selectedWitnin2HourDictionary;

    
    // week days
    __weak IBOutlet UIView *_slotView;
    __weak IBOutlet UIView *_sunView;
    __weak IBOutlet UIView *_monView;
    __weak IBOutlet UIView *_tueView;
    __weak IBOutlet UIView *_wedView;
    __weak IBOutlet UIView *_thuView;
    __weak IBOutlet UIView *_friView;
    __weak IBOutlet UIView *_satView;
    __weak IBOutlet UIImageView *_sectionCheckMarkImage;
    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UIBarButtonItem *bucketButton;
    __weak IBOutlet UITableView *_deliveyTable;
    
     NSString *deliveryDateAfterLogin,*deliverySlotIdAfterLogin,*DeliverySlotAfterLogin;
    
    __weak IBOutlet UIView *lineView;
        
    NSInteger selectedDate;

    MyinfoView *myView;
    
   
    NSDate* tomorrow ;
    NSDateFormatter* theDateFormatter;
    NSString *errorMsg;
    UIAlertView *alretConfirmLabel;
    NSDate *preselectedDate;
    NSString *dateString;

}
@property (nonatomic) BOOL isFromOnline;
@property (nonatomic) BOOL isForDefault;;
@property (nonatomic) BOOL isFromConfirm;
@property (nonatomic) BOOL isFromDateSelected;
@property (nonatomic) BOOL isFromFailed;

- (IBAction)sectionButton_clicked:(id)sender;
- (IBAction)bucketButton_clicked:(id)sender;

- (IBAction)slotButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)continueButton_clicked:(id)sender;

@property (nonatomic) NSMutableArray * productListArr;
@property (nonatomic) NSMutableArray * holiDayArr;
@end

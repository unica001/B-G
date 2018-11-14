//
//  MyCartViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGDeliveryScheduleViewController.h"
#import "GetCutOffTimeRequest.h"
#import "MyinfoView.h"
#import "BGHomeViewController.h"
#import "UpdateOneTimeOrderRequest.h"
#import "BGSignInViewController.h"

@interface MyCartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GetCutOffTimeRequestDelegate,continueDelegate,SWRevealViewControllerDelegate,UpdateOneTimeOrderRequestDelegate>
{

    __weak IBOutlet UITableView *myCartTable;
    NSMutableArray *myCartArray;
    IOFDB *iofDB;
    NSMutableDictionary *cutOffDict;

    
    MyinfoView *myView;

    __weak IBOutlet UIBarButtonItem *backButton;
    __weak IBOutlet UILabel *totalPriceLabel;
    __weak IBOutlet UILabel *totalItemLabel;
//    __weak IBOutlet UIBarButtonItem *bucketButton;
    __weak IBOutlet UIButton *checkoutButton;
    __weak IBOutlet UIButton *addMoreButton;
    
}
@property(nonatomic,strong)NSString *payTotalPrice;
@property(nonatomic,strong)NSString *incomingType;


- (IBAction)backButton_clicked:(id)sender;
//- (IBAction)bucketButton_clicked:(id)sender;
- (IBAction)searchButton_clicked:(id)sender;
- (IBAction)checkoutButton_clicked:(id)sender;
- (IBAction)addMoreButton_clicked:(id)sender;
-(void)getMyCartData;

@end

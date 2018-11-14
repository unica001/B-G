//
//  BGRegistrationViewController.h
//  Unica
//
//  Created by vineet patidar on 03/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"
#import "SignupUserServerRequest.h"
#import "UpdateProfileRequest.h"
#import "GetMyCredit.h"
#import "GetAccDetail.h"
#import "GetSummaryDetail.h"


@interface BGRegistrationViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate,MKMapViewDelegate,SignupUserServerRequestDelegate,UpdateProfileRequestDelegate,GetMyCreditRequestDelegate,GetAccDetailRequestDelegate,GetSummaryDetailRequestDelegate>{

    __weak IBOutlet UITableView *_registerTable;
    __weak IBOutlet UIButton *_profileButton;
    __weak IBOutlet UIButton *_registerButton;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    NSMutableArray *transactionArray;
    
    NSMutableDictionary *selectedAddressDictionary;
    NSString  *localityID;
    NSString  *locationID;

    NSMutableDictionary *subrubDictionary;
    
    UILabel *countryCodeLabel;
    NSString *_countryID;
    NSString *_countryCode;
    NSString *_minimum_value;
    NSString *maximum_value ;
    
    BOOL showPassword;
    BOOL oldPassword;
    BOOL showConfirmPassword;
    
    UIButton *_hintButton;
    UIButton *_hintButtonConfirmPassword;


    
    __weak IBOutlet UIImageView *_profileImage;
    __weak IBOutlet UIButton *_checkMarkButton;
    __weak IBOutlet UIWebView *_webView;
    CLGeocoder *geocoder;

    
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UIView *_cashBalanceView;
    __weak IBOutlet UILabel *_syncDate;

    __weak IBOutlet UIView *_bottomView;
    __weak IBOutlet NSLayoutConstraint *_chemarkButtonHeight;
    __weak IBOutlet NSLayoutConstraint *_webViewHeight;
    __weak IBOutlet UISegmentedControl *_segment;
    __weak IBOutlet MKMapView *_mapView;
    
    NSMutableDictionary *cashDictionary;
    
    __weak IBOutlet NSLayoutConstraint *registerButtonHeight;
    __weak IBOutlet NSLayoutConstraint *_bottomViewHeight;
    __weak IBOutlet NSLayoutConstraint *_skipButonHeight;
    __weak IBOutlet NSLayoutConstraint *_continueButtonHeight;
    BOOL isEdit;
}

@property (nonatomic,retain) NSString *modeType;
@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *confirmPasswordTextField;
//@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *zipCodeTextField;
@property (strong, nonatomic) UITextField *locationTextField;
@property (strong, nonatomic) UITextField *localityTextField;
@property (strong, nonatomic) UITextField *stateTextField;

@property (nonatomic,retain) NSString *loginType;


@property (nonatomic) BOOL isAgreeTerms;

@property (strong, nonatomic) GetMyCredit *getMyCredit;
@property(nonatomic)NSMutableArray *getAccArr;

@property (strong, nonatomic) GetAccDetail *getAccountDetail;
@property(nonatomic,retain) NSMutableDictionary *infoDictionary;
- (IBAction)continueButtonClicked:(id)sender;

- (IBAction)skipButton_clicked:(id)sender;

- (IBAction)profileButton_clicked:(id)sender;
- (IBAction)registerButton_clicked:(id)sender;
- (IBAction)checkMarkButton_clicked:(id)sender;
- (IBAction)segment_clicked:(id)sender;

- (IBAction)backButton_clicked:(id)sender;
@end

//
//  BGRegistrationViewController.m
//  Unica
//
//  Created by vineet patidar on 03/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGRegistrationViewController.h"
#import "SignInCell.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "PhoneNumberFormatter.h"
#import "UtilityPlist.h"
#import "BGOTPViewController.h"
#import "BGSelectionViewController.h"
#import "TransactionCell.h"
#import "BGWebViewController.h"


@interface BGRegistrationViewController ()<GKActionSheetPickerDelegate,NSURLSessionDelegate,userSelectionDelegate>{
    NSMutableArray *_imageArray;
    AppDelegate *appDelegate;
    NSMutableDictionary *_loginDictionary;
    NSMutableDictionary *updateDictionary;
    
}
// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

@end

typedef enum _BGProfileFieldType {
    BGProfileFirstName = 0,
    BGProfileLasttName = 1,
    BGProfileEmail = 2,
    BGProfilePhoneNumber = 3,
    BGProfilePassword = 4,
    BGProfileConfirmPassword = 5,
    BGAddress = 1,
    BGPostCode = 2,
    BGSubrub = 0,
    BGStateName = 3
    
} BGProfileFieldType;

@implementation BGRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"My Profile";
    
    // make profile button round up
    
    _loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    [_profileImage.layer setMasksToBounds:YES];
    
    _registerTable.layer.cornerRadius = 5.0;
    [_registerTable.layer setMasksToBounds:YES];
    
    
    _imageArray = [[NSMutableArray alloc]initWithObjects:@"user",@"user",@"mail",@"call" ,@"password",@"password",nil];
    
    
    [self setupInitialLayout];
    _mapView.delegate = self;
    
    // hide map view and botton button  view
    _bottomView.hidden = YES;
    _mapView.hidden = YES;
    _cashBalanceView.hidden = YES;
    isEdit = NO;
    _mapView.delegate = self;
    
    if ([self.title isEqualToString:kMyProfile]) {
        
        // hide term and conditions
        _webView.hidden = NO;
        _checkMarkButton.hidden = NO;
        
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [_backButton setImage:[UIImage imageNamed:@"menu"]];
                [_backButton setTarget: self.revealViewController];
                [_backButton setAction: @selector( revealToggle: )];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
        }
        self.revealViewController.delegate = self;
        
    }
    else if ([self.modeType isEqualToString:kOrderSummary]){
        
        // order summary
        _webView.hidden = NO;
        _checkMarkButton.hidden = NO;
        _bottomView.hidden = YES;
        _mapView.hidden = NO;
        
        
        self.title = @"Update Delivery Address";
        _segment.selectedSegmentIndex = 1;
        
    }
    else{
        
        _webView.hidden = NO;
        _checkMarkButton.hidden = NO;
        
        [_webView loadHTMLString:@"<font face = 'arial'><span style='font-size:14px;color:#3B455D'><p>I agree with the app<a href='' style='color:#8FC215;'>Terms & Conditions</a></p></span></font> "baseURL:nil];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    
    
    CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(-37.814251,144.9631);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cord, 800, 800);
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = cord;
    [_mapView addAnnotation:point];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

/****************************
 * Function Name : - setUPInitialLayout
 * Create on : - 03 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function initilization all the basic control before screen load
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)setupInitialLayout{
    //Intilize Common Options for TextField
    CGRect frame = CGRectMake(55,10 , kiPhoneWidth-75, 30);
    
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    
    
    //Setup  first name Field
    CGRect stateFrame = frame;
    stateFrame.size.width = kiPhoneWidth-60;
    
    [optionDictionary setValue:@"First Name" forKey:kTextFeildOptionPlaceholder];
    self.firstNameTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.firstNameTextField.textColor = [UIColor blackColor];
    
    self.firstNameTextField.tag = BGProfileFirstName+100;
    
    // setup last name
    [optionDictionary setValue:@"Last Name" forKey:kTextFeildOptionPlaceholder];
    self.lastNameTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.lastNameTextField.textColor = [UIColor blackColor];
    self.lastNameTextField.tag = BGProfileLasttName+100;
    
    // setup  email
    [optionDictionary setValue:@"Email Id" forKey:kTextFeildOptionPlaceholder];
    self.emailTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.emailTextField.textColor = [UIColor blackColor];
    self.emailTextField.tag = BGProfileEmail+100;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    
    
    //Setup Password Field
    
    stateFrame.size.width = kiPhoneWidth-100;
    
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Password" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:1] forKey:kTextFeildOptionIsPassword];
    self.passwordTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.tag = BGProfilePassword+100;
    
    
    // confirm password
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Confirm Password" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:1] forKey:kTextFeildOptionIsPassword];
    [optionDictionary setValue:[NSNumber numberWithInt:9] forKey:kTextFeildOptionReturnType];
    self.confirmPasswordTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.confirmPasswordTextField.textColor = [UIColor blackColor];
    self.confirmPasswordTextField.tag = BGProfileConfirmPassword+100;
    
    
    
    CGRect phoneNoFrame = frame;
    phoneNoFrame.size.width = 40;
    frame.origin.x = 20;
    
    // country code label
    
    countryCodeLabel = [[UILabel alloc]initWithFrame:frame];
    countryCodeLabel.font = kDefaultFontForTextField;
    countryCodeLabel.text  = @"+61";
    countryCodeLabel.textColor = [UIColor lightGrayColor];
    
    
    //Setup last name Field
    phoneNoFrame.origin.x = 65;
    phoneNoFrame.size.width = kiPhoneWidth-75;
    
    // phone number field
    [optionDictionary setValue:@"Phone Number" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeNumberPad] forKey:kTextFeildOptionKeyboardType];
    self.phoneNumberTextField = [Control newTextFieldWithOptions:optionDictionary frame:phoneNoFrame delgate:self];
    self.phoneNumberTextField.inputAccessoryView  = [self addToolBarOnKeyboard:BGProfilePhoneNumber+100];
    self.phoneNumberTextField.textColor = [UIColor blackColor];
    
    
    frame = CGRectMake(20,10 , kiPhoneWidth-40, 30);
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    
    // setup office number
    [optionDictionary setValue:@"Postcode" forKey:kTextFeildOptionPlaceholder];
    self.zipCodeTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.zipCodeTextField.textColor = [UIColor blackColor];
    self.zipCodeTextField.secureTextEntry = false;
    self.zipCodeTextField.keyboardType = UIKeyboardTypePhonePad;
    
    
    // location
    [optionDictionary setValue:@"Address" forKey:kTextFeildOptionPlaceholder];
    self.locationTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.locationTextField.textColor = [UIColor blackColor];
    self.locationTextField.secureTextEntry = false;
    
    
    // city
    [optionDictionary setValue:@"Suburb" forKey:kTextFeildOptionPlaceholder];
    self.localityTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.localityTextField.textColor = [UIColor blackColor];
    self.localityTextField.secureTextEntry = false;
    
    
    // state
    [optionDictionary setValue:@"State " forKey:kTextFeildOptionPlaceholder];
    self.stateTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.stateTextField.textColor = [UIColor blackColor];
    self.stateTextField.secureTextEntry = false;
    self.stateTextField.returnKeyType = UIReturnKeyNext;
    
    
    if ([self.loginType isEqualToString:@"S"]) {
        [self setSocialDataInTextField:self.infoDictionary];
        
    }
    else if ([self.title isEqualToString:kMyProfile]|| [self.modeType isEqualToString:kOrderSummary]){
        
        [self setSocialDataInTextField:[Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]]];
    }
}

-(void)setSocialDataInTextField:(NSMutableDictionary *)dictionary{
    
    // check incomming view type
   // [self SetSuberbDic: dictionary];
    NSLog(@"%@",self.infoDictionary);
    //    self.loginType = [kUserDefault valueForKey:kRegister_type];
    
    
    if ([self.loginType isEqualToString:@"S"] ) {
        
        // first name
        if (![[dictionary valueForKey:kfirstname] isKindOfClass:[NSNull class]]) {
            self.firstNameTextField.text = [dictionary valueForKey:kfirstname];
        }
        
        // last name
        if (![[dictionary valueForKey:klastname] isKindOfClass:[NSNull class]]) {
            self.lastNameTextField.text = [dictionary valueForKey:klastname];
        }
        
        // email
        if (![[dictionary valueForKey:kEmail] isKindOfClass:[NSNull class]]) {
            self.emailTextField.text = [dictionary valueForKey:kEmail];
        }
        
        // Number
        if (![[dictionary valueForKey:kMobileNumber] isKindOfClass:[NSNull class]]) {
            self.phoneNumberTextField.text = [Utility makePhoneNumberFormate:[dictionary valueForKey:kMobileNumber]];
        }
        
        // image
        NSString *imageName =[dictionary objectForKey:@"profile_image"];
      
        if(imageName == nil)
        {
            _profileImage.image=[UIImage imageNamed:@"profile"];
        }
        else{
            NSString *finalImageUrl = [NSString stringWithFormat:@"%@%@",kProfileImageBaseUrl,imageName];
            
[[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@",finalImageUrl] fromDisk:YES];
            
            [_profileImage sd_setImageWithURL:[NSURL URLWithString:finalImageUrl] placeholderImage:[UIImage imageNamed:@"profile"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType SDImageCacheTypeNone, NSURL *imageURL) {
                
                if (error) {
                    
                    
                }
            }];
            
            //options:SDWebImageRefreshCached];
            
        }
        
    }
    
    else  if ([self.title isEqualToString:kMyProfile] || [self.modeType isEqualToString:kOrderSummary]) {
        
        [_registerButton setTitle:@"UPDATE" forState:UIControlStateNormal];
        
        _bottomView.hidden = YES;
        //        _registerButton.hidden = YES;
        _chemarkButtonHeight.constant = 0;
        _webViewHeight.constant = 0;
        
        _cashBalanceView.hidden = NO;
        [_segment insertSegmentWithTitle:@"Account Balance" atIndex:2 animated:NO];
        // [self disAbleUserInteration];
        
        selectedAddressDictionary = [[NSMutableDictionary alloc]init];
        
        self.emailTextField.userInteractionEnabled = NO;
        self.phoneNumberTextField.userInteractionEnabled =  NO;
        
        // first name
        if (![[dictionary valueForKey:kfirstname] isKindOfClass:[NSNull class]]) {
            self.firstNameTextField.text = [dictionary valueForKey:kfirstname];
        }
        
        // last name
        if (![[dictionary valueForKey:klastname] isKindOfClass:[NSNull class]]) {
            self.lastNameTextField.text = [dictionary valueForKey:klastname];
        }
        
        // email
        if (![[dictionary valueForKey:@"CustomerID"] isKindOfClass:[NSNull class]]) {
            
            if ([dictionary valueForKey:kEmail]) {
                self.emailTextField.text = [dictionary valueForKey:kEmail];
            }
            else{
                self.emailTextField.text = [dictionary valueForKey:kCustomerEmail];
            }
        }
        
        
        // Number
        if (![[dictionary valueForKey:kMobileNumber] isKindOfClass:[NSNull class]]) {
            
            NSString *mobileNumber = [dictionary valueForKey:kMobileNumber];
            _phoneNumberTextField.text = mobileNumber;
        }
        
        
        // Locality
        if (![[dictionary valueForKey:@"LocalityId"] isKindOfClass:[NSNull class]]) {
            
            if([ Utility replaceNULL:[dictionary valueForKey:@"StateName"] value:@""].length>0)
            {
                [selectedAddressDictionary setValue:[dictionary valueForKey:@"LocationId"] forKey:@"LocalityId"];
                localityID = [dictionary valueForKey:@"LocationId"];
                NSString *location = [dictionary valueForKey:@"Location"];
                _localityTextField.text = location;
            }
//            [selectedAddressDictionary setValue:[dictionary valueForKey:@"LocationId"] forKey:@"LocalityId"];
//            localityID = [dictionary valueForKey:@"LocationId"];
//            NSString *location = [dictionary valueForKey:@"Location"];
//            _localityTextField.text = location;

            
        }
        
        // state
        if (![[dictionary valueForKey:@"StateName"] isKindOfClass:[NSNull class]]) {
            _stateTextField.text = [dictionary valueForKey:@"StateName"];
        }
        
        // Address
        if (![[dictionary valueForKey:kAddress1] isKindOfClass:[NSNull class]]) {
            _locationTextField.text = [dictionary valueForKey:kAddress1];
        }
        
        // zipcode
        
        if ((![[dictionary valueForKey:kZipCode] isKindOfClass:[NSNull class]]) && [dictionary valueForKey:kZipCode]) {
            _zipCodeTextField.text = [dictionary valueForKey:kZipCode];
        }
        else{
        
            // zipcode
            if (![[dictionary valueForKey:@"Zipcode"] isKindOfClass:[NSNull class]]) {
                _zipCodeTextField.text = [dictionary valueForKey:@"Zipcode"];
            }

        }
        
        
        if (_zipCodeTextField.text.length>4) {
            _zipCodeTextField.text = [_zipCodeTextField.text substringToIndex:4];
        }
        
        // image
        NSString *imageName =[dictionary objectForKey:@"Photo"];
        NSString *url = [NSString stringWithFormat:@"%@%@",kProfileImageBaseUrl,imageName];
        
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@",url] fromDisk:YES];
        [_profileImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"profile"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType SDImageCacheTypeNone, NSURL *imageURL) {
            
            if (error) {
                
                
            }
        }];
        
        
        
        
        
        
        [self getLatLongFromAddress];
    }
    
}

-(void) setProfileImage :(NSString*)finalImageUrl{
    
}

-(void)disAbleUserInteration{
    _firstNameTextField.userInteractionEnabled = NO;
    _lastNameTextField.userInteractionEnabled = NO;
    _zipCodeTextField.userInteractionEnabled = NO;
    _locationTextField.userInteractionEnabled = NO;
    _localityTextField.userInteractionEnabled = NO;
    _stateTextField.userInteractionEnabled = NO;
    _emailTextField.userInteractionEnabled = NO;
    _phoneNumberTextField.userInteractionEnabled = NO;
}

/****************************
 * Function Name : - addToolBarOnKeyboard
 * Create on : - 29th Nov 2016
 * Developed By : - Ramniwas
 * Description : - This Function is used for add tool bar on keyboard in case of number keyboard open
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(UIToolbar *)addToolBarOnKeyboard :(NSInteger) tag{
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    doneButton.tag = tag;
    doneButton.tintColor = [UIColor lightGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    return keyboardToolbar;
}

-(void)keyboardDoneButtonPressed:(UIBarButtonItem*) sender{
    
    if ([self.loginType isEqualToString:@"S"]) {
        [_phoneNumberTextField resignFirstResponder];
    }else{
        [_passwordTextField becomeFirstResponder];
    }
    
}

#pragma  mark - webviw delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
         [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:nil];
        
        return NO;
    }
    return YES;
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_segment.selectedSegmentIndex == 0) {
        if ([self.loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile] || [self.modeType isEqualToString:kOrderSummary]) {
            
            return 4;
        }
        return 6;
    }
    else if (_segment.selectedSegmentIndex ==2){
        
        return [transactionArray count];
    }
    return 4;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_segment.selectedSegmentIndex ==2) {
        
        _chemarkButtonHeight.constant = 0;
        _webViewHeight.constant = 0;
        _bottomViewHeight.constant = 0;
        registerButtonHeight.constant = -100;
        _skipButonHeight.constant = 0;
        _continueButtonHeight.constant = 0;
        
        static NSString *cellIdentifier3  =@"cell";
        
        
        TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TransactionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setData:[transactionArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else{
        
        static NSString *cellIdentifier3  =@"signIn";
        
        
        SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SignInCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell._imageView.hidden = NO;
        
        _bottomViewHeight.constant = 50;
        registerButtonHeight.constant = 40;
        _skipButonHeight.constant = 50;
        _continueButtonHeight.constant = 50;
        
        
        // for profile
        
        if (_segment.selectedSegmentIndex ==0) {
            
            if (indexPath.row == BGProfileFirstName) {
                [cell.textField removeFromSuperview];
                cell.textField = self.firstNameTextField;
                [cell.contentView addSubview:cell.textField];
            }
            else  if (indexPath.row == BGProfileLasttName) {
                [cell.textField removeFromSuperview];
                cell.textField = self.lastNameTextField;
                [cell.contentView addSubview:cell.textField];
                
            }
            else  if (indexPath.row == BGProfileEmail) {
                [cell.textField removeFromSuperview];
                cell.textField = self.emailTextField;
                [cell.contentView addSubview:cell.textField];
                
            }
            
            else  if (indexPath.row == BGProfilePhoneNumber) {
                [cell.textField removeFromSuperview];
                cell.textField = self.phoneNumberTextField;
                [cell.contentView addSubview:cell.textField];
                [cell.contentView addSubview:countryCodeLabel];
                self.phoneNumberTextField.secureTextEntry = NO;
                cell._imageView.hidden = YES;
                
            }
            
            
            else  if (indexPath.row == BGProfilePassword) {
                [cell.textField removeFromSuperview];
                cell.textField = self.passwordTextField;
                cell.textField.secureTextEntry = true;
                [cell.contentView addSubview:cell.textField];
                // _hintButton  button
                _hintButton = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-40, 10, 30, 30)];
                _hintButton.titleLabel.font = [UIFont systemFontOfSize:14];
                _hintButton.backgroundColor = [UIColor clearColor];
                _hintButton.tag = indexPath.row;
                [_hintButton addTarget:self action:@selector(hintButtonButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
                _hintButton.tag = indexPath.row;
                [_hintButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
                [cell.contentView addSubview:_hintButton];
                
            }
            else  if (indexPath.row == BGProfileConfirmPassword) {
                [cell.textField removeFromSuperview];
                
                cell.textField = self.confirmPasswordTextField;
                cell.textField.secureTextEntry = true;
                [cell.contentView addSubview:cell.textField];
                // _hintButton  button
                _hintButtonConfirmPassword = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-40, 10, 30, 30)];
                _hintButtonConfirmPassword.titleLabel.font = [UIFont systemFontOfSize:14];
                _hintButtonConfirmPassword.backgroundColor = [UIColor clearColor];
                _hintButtonConfirmPassword.tag = indexPath.row;
                [_hintButtonConfirmPassword addTarget:self action:@selector(hintButtonButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
                _hintButtonConfirmPassword.tag = indexPath.row;
                [_hintButtonConfirmPassword setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
                [cell.contentView addSubview:_hintButtonConfirmPassword];
                
            }
            
            cell.lineView.backgroundColor = [UIColor lightGrayColor];
            cell._imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_imageArray objectAtIndex:indexPath.row]]];
        }
        else{ // for address
            
            
            cell.textField.secureTextEntry = false;
            
            if (indexPath.row == BGPostCode) { // post code
                [cell.textField removeFromSuperview];
                cell.textField = self.zipCodeTextField;
                [cell.contentView addSubview:cell.textField];
            }
            else  if (indexPath.row == BGAddress) { // Address
                [cell.textField removeFromSuperview];
                cell.textField = self.locationTextField;
                [cell.contentView addSubview:cell.textField];
                
            }
            else  if (indexPath.row == BGSubrub) { // city name
                [cell.textField removeFromSuperview];
                cell.textField = self.localityTextField;
                self.localityTextField.userInteractionEnabled = NO;
                
                [cell.contentView addSubview:cell.textField];
            }
            else  if (indexPath.row == BGStateName) { // state name
                [cell.textField removeFromSuperview];
                cell.textField = self.stateTextField;
                self.stateTextField.userInteractionEnabled = NO;
                [cell.contentView addSubview:cell.textField];
            }
            
        }
        
        // hide header laber
        
        if (([self.loginType isEqualToString:@"S"] ) &&( indexPath.row == BGProfilePassword||  indexPath.row == BGProfileConfirmPassword)) {
            self.confirmPasswordTextField.hidden = YES;
            self.passwordTextField.hidden = YES;
            
        }
        
        return cell;
    }
    
    return nil;
    
    
}


#pragma  mark - button clicked

-(void)hintButtonButton_clicked:(UIButton *)sender{
    
    if (sender.tag == 4) {
        if (showPassword == true) {
            _passwordTextField.secureTextEntry = NO;
            showPassword = false;
            [_hintButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        }
        else{
            _passwordTextField.secureTextEntry = YES;
            showPassword = true;
            [_hintButton setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
            
        }
    }
    else if (sender.tag == 5) {
        if (showConfirmPassword == true) {
            _confirmPasswordTextField.secureTextEntry = NO;
            showConfirmPassword = false;
            [_hintButtonConfirmPassword setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        }
        else{
            _confirmPasswordTextField.secureTextEntry = YES;
            showConfirmPassword = true;
            [_hintButtonConfirmPassword setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
        }
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (isEdit ==NO && ([self.modeType isEqualToString:kOrderSummary] ||[self.title isEqualToString:kMyProfile])) {
    //        return;
    //    }
    
    if (_segment.selectedSegmentIndex ==1) {
        if (indexPath.row == 0) {
            
            
            [self performSegueWithIdentifier:kuserSelectionSegueIdentifier sender:kOtherLocation];
        }
        //      else  if (indexPath.row == 0) {
        //            [self performSegueWithIdentifier:kuserSelectionSegueIdentifier sender:kOtherCity];
        //        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (([self.loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile] || [self.modeType isEqualToString:kOrderSummary])&& (indexPath.row == BGProfilePassword || indexPath.row == BGProfileConfirmPassword) && !_segment.selectedSegmentIndex ==2) {
        
        return 0;
    }
    else if (_segment.selectedSegmentIndex ==2){
        return 60;
    }
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    UIImagePickerControllerSourceType type;
    
    if(buttonIndex==0){
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else{
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate   = self;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[_profileButton setBackgroundImage:image forState:UIControlStateNormal];
    
   // _profileImage.image = image;
    CGRect rect = CGRectMake(0,0,200,200);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    _profileImage.image = picture1;
   [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark -
#pragma TextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField == self.firstNameTextField) {
        
        [self.lastNameTextField becomeFirstResponder];
    }
    else if (textField == self.lastNameTextField) {
        
        [self.emailTextField becomeFirstResponder];
    }
    else if (textField == self.emailTextField) {
        
        [self.phoneNumberTextField becomeFirstResponder];
    }
    
    else if (textField == self.passwordTextField) {
        
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordTextField) {
        
        [self.confirmPasswordTextField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *strQueryString;
    if((range.length == 0) && (string.length > 0)){
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        strQueryString = [NSString stringWithFormat:@"%@%@%@",strStarting,string,strEnding];
    }
    else{
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        if(strEnding.length > 0)
            strEnding = [strEnding substringFromIndex:range.length];
        strQueryString = [NSString stringWithFormat:@"%@%@",strStarting,strEnding];
    }
    
    if(strQueryString.length == 0){
        return YES;
    }
    
    if(textField == _phoneNumberTextField )
    {
        
        
        // All digits entered
        if (range.location == 12) {
            return NO;
        }
        
        /*
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"(" withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
         
         PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
         NSLog(@"%@",[formatter formatForUS:strQueryString]);
         
         textField.text = [formatter formatForUS:strQueryString];*/
        
        
        textField.text = _phoneNumberTextField.text;
        
        
        return YES;
    }
    
    else if(textField == _firstNameTextField ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    else if(textField == _lastNameTextField ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    
    else if(textField == _zipCodeTextField ){
        
        // All digits entered
        if (range.location == 4) {
            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    //    if (textField == _zipCodeTextField) {
    //        [self getLatLongFromAddress];
    //    }
    [self getLatLongFromAddress];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma  mark - button clicked

- (IBAction)checkMarkButton_clicked:(id)sender {
    
    self.isAgreeTerms = !self.isAgreeTerms;
    UIButton *button = (UIButton *)sender;
    
    //Check Wether button state is selected or unselcted and set the desire image
    if (self.isAgreeTerms == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        _isAgreeTerms = true;
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        _isAgreeTerms = false;
    }
}

- (IBAction)segment_clicked:(id)sender {
    
    if ([self.title isEqualToString:kMyProfile]) {// update profile
        _bottomView.hidden = YES;
        _chemarkButtonHeight.constant = 0;
        _webViewHeight.constant = 0;
        _registerButton.hidden = YES;
        _cashBalanceView.hidden = YES;
        _mapView.hidden = YES;
        
        
        if (_segment.selectedSegmentIndex == 0 && isEdit == YES) {
            _registerButton.hidden = NO;
            
        }
        else if (_segment.selectedSegmentIndex == 1 && isEdit == YES) {
            _registerButton.hidden = NO;
            _mapView.hidden = NO;
        }
        else  if (_segment.selectedSegmentIndex == 0 ) {
            _registerButton.hidden = NO;
            
        }
        else if (_segment.selectedSegmentIndex == 1 ) {
            _registerButton.hidden = NO;
            _mapView.hidden = NO;
        }
        else if (_segment.selectedSegmentIndex ==2){
            _bottomView.hidden = YES;
            _mapView.hidden = YES;
            _cashBalanceView.hidden = NO;
            _registerButton.hidden = YES;
            [self getCreditDetails];
        }
        
        
    }
    
    else if ([self.modeType isEqualToString:kOrderSummary]){
        if (_segment.selectedSegmentIndex ==0 || _segment.selectedSegmentIndex ==2) {
            _segment.selectedSegmentIndex = 1;
            return;
        }
        else{
            if (isEdit==true) {
                _registerButton.hidden = NO;
            }
            
        }
    }
    
    else{ // register
        if (_segment.selectedSegmentIndex ==0) {
            _bottomView.hidden = YES;
            _mapView.hidden = YES;
            _cashBalanceView.hidden = YES;
            _registerButton.hidden = NO;
            _chemarkButtonHeight.constant = 20;
            _webViewHeight.constant = 30;
        }
        else if (_segment.selectedSegmentIndex ==1) {
            
            if (![self validatePassword]) {
                _segment.selectedSegmentIndex = 0;
                return;
            }
            _chemarkButtonHeight.constant = 0;
            _webViewHeight.constant = 0;
            
            _bottomView.hidden = NO;
            _mapView.hidden = NO;
            _cashBalanceView.hidden = YES;
            _registerButton.hidden = NO;
        }
    }
    
    
    [_registerTable reloadData];
}

-(void)checkAllFieldFillUpForRegistration{
    
    
}

- (IBAction)continueButtonClicked:(id)sender {
    
    if ([self validation] && [self validatePassword]) {
        [self registerUser];
    }
}

- (IBAction)skipButton_clicked:(id)sender {
    
    if ([self validatePassword]) {
        [self registerUser];
    }
}

- (IBAction)profileButton_clicked:(id)sender {
   
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Set Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Upload from Gallery", @"Take Camera Picture", nil];
    [sheet showInView:self.view.window];
}

- (IBAction)registerButton_clicked:(id)sender {
    
    if ([self validatePassword]) {
        
        
        if ((([self.modeType isEqualToString:kOrderSummary] ||[self.title isEqualToString:kMyProfile]))){
            
            if (_segment.selectedSegmentIndex == 0) { // for register
                
                if ([self validatePassword]) {
                    [self updateProfile];
                    
                }
            }
            else{ // for update
                
                if ([self validation]) {
                    [self updateProfileAddress];
                    
                }
            }
        }
        
        else{
            
            if (_segment.selectedSegmentIndex == 0) { // for register
                // [self registerUser];
                
                _segment.selectedSegmentIndex = 1;
                _chemarkButtonHeight.constant = 0;
                _webViewHeight.constant = 0;
                
                _bottomView.hidden = NO;
                _mapView.hidden = NO;
                _cashBalanceView.hidden = YES;
                _registerButton.hidden = YES;
                
                [_registerTable reloadData];
            }
            
            
        }
        
    }
}

-(void)registerUser{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_firstNameTextField.text forKey:@"FirstName"];
    [dict setObject:_lastNameTextField.text forKey:@"LastName"];
    [dict setObject:_emailTextField.text forKey:@"Email"];
    [dict setObject:@"iOS" forKey:@"DeviceType"];
    [dict setObject:_phoneNumberTextField.text forKey:@"MobileNumber"];
    [dict setObject:@"" forKey:@"FamilyCode"];
    
    [dict setObject:_passwordTextField.text forKey:@"Password"];
    [dict setObject:@"" forKey:@"CityId"];
    [dict setObject:@"" forKey:@"ReferralCode"];
    
    NSString *deviceToken = [kUserDefault valueForKey:@"devicetoken"];
    if(deviceToken!=nil){
        [dict setObject:deviceToken forKey:@"deviceId"];
        [dict setObject:deviceToken forKey:@"DeviceId"];
    }
    
    [dict setObject:@"jpg" forKey:@"ImageName"];
    [dict setObject:_locationTextField.text forKey:@"Address1"];
    [dict setObject:_zipCodeTextField.text forKey:@"Zipcode"];
    
    if([self.loginType isEqualToString:@"S"])
    {
        if ([[self.infoDictionary valueForKey:kStype] isEqualToString:@"F"]) {
            [dict setObject:[NSString stringWithFormat:@"%@",[self.infoDictionary valueForKey:kSocialId]] forKey:kFbUserID];
        }
        else{
            [dict setObject:[NSString stringWithFormat:@"%@",[self.infoDictionary valueForKey:kSocialId]] forKey:kGoogleUserID];
        }
        [dict setObject:@"" forKey:kPassword];
        
    }else{
        [dict setObject:_passwordTextField.text forKey:kPassword];
    }
    
    
    if (_segment.selectedSegmentIndex ==1) {
        if (localityID) {
            [dict setObject:localityID forKey:@"LocalityId"];
        }
        else{
           // [dict setObject:@"1" forKey:@"LocalityId"];
             [dict setObject:@"0" forKey:@"LocalityId"];
        }
        
        if ([subrubDictionary valueForKey:@"RefCityId"]) {
            [dict setObject:[subrubDictionary valueForKey:@"RefCityId"] forKey:kCityId];
        }
        else{
            [dict setObject:@"0" forKey:kCityId];
        }
    }
    
    
    
    
    
    //   NSData *imageData = UIImageJPEGRepresentation(_profileImage.image, 0.1);
    //    NSString *encodedString = [Utility base64forData:imageData];
    NSString *encodedString = [Utility encodeToBase64String:_profileImage.image];
    
    [dict setObject:encodedString forKey:@"ImageBase64String"];
    [self callRegisterAPI:dict];
    
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editButtonButton_Clicked:(UIButton*)sender{
    
    _firstNameTextField.userInteractionEnabled = YES;
    _lastNameTextField.userInteractionEnabled = YES;
    _zipCodeTextField.userInteractionEnabled = YES;
    _locationTextField.userInteractionEnabled = YES;
    _localityTextField.userInteractionEnabled = NO;
    _stateTextField.userInteractionEnabled = NO;
    _emailTextField.userInteractionEnabled = NO;
    _phoneNumberTextField.userInteractionEnabled = NO;
    _bottomView.hidden = YES;
    
    if (_segment.selectedSegmentIndex ==1 ||_segment.selectedSegmentIndex ==0) {
        _registerButton.hidden = NO;
    }
    else{
        _registerButton.hidden = YES;
        
    }
    
    isEdit  = YES;
}


/****************************
 * Function Name : - validatePassword
 * Create on : - 3 march 2017
 * Developed By : -  Ramniwas
 * Description : -  This funtion are use for check validation in registration form
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    if(![Utility validateField:_firstNameTextField.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter first name" block:^(int index) {
            
        }];
        return false;
    }
    else if(![Utility validateField:_lastNameTextField.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter last name" block:^(int index) {
            
        }];
        return false;
    }
    
    else if(![Utility validateField:_emailTextField.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter email Id" block:^(int index) {
            
        }];
        return false;
    }
    else  if(![Utility validateEmail:_emailTextField.text] ){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid email Id" block:^(int index) {
            
        }];
        return false;
    }
    
    
    else if(![Utility validateField:_phoneNumberTextField.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter mobile number" block:^(int index) {
            
        }];
        return false;
    }
    else if(_phoneNumberTextField.text.length < 4 || _phoneNumberTextField.text.length > 12){
        
        NSString *message = [NSString stringWithFormat:@"Please enter valid mobile number"];
        
        [Utility showAlertViewControllerIn:self title:BGError message:message block:^(int index) {
            
        }];
        return false;
    }
    
    else if(![Utility validateField:_passwordTextField.text] && !([self.loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile]|| [self.modeType isEqualToString:kOrderSummary])){
        
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter password" block:^(int index) {
            
        }];
        return false;
    }
    
    else if( !(_passwordTextField.text.length>5 && _passwordTextField.text.length<16) && !( [self.loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile]|| [self.modeType isEqualToString:kOrderSummary])){
        
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid password. Password length should be between 6 to 15 character" block:^(int index) {
            
        }];
        return false;
    }
    
    else if(![Utility validateField:_confirmPasswordTextField.text] && !([self.loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile]|| [self.modeType isEqualToString:kOrderSummary])){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Confirm password can't be left blank" block:^(int index) {
            
        }];
        return false;
    }
    else if(![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text] && !([self.loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile]|| [self.modeType isEqualToString:kOrderSummary])){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Password and Confirm password do not match" block:^(int index) {
            
        }];
        return false;
    }
    else if(_isAgreeTerms == false && !([self.title isEqualToString:kMyProfile]|| [self.modeType isEqualToString:kOrderSummary])){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Before proceeding to profile, you should accept terms and conditions" block:^(int index) {
            
        }];
        return false;
    }
    
    return true;
}
- (BOOL)validation{
    
    
    if(![Utility validateField:_localityTextField.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please select City" block:^(int index) {
            
        }];
        return false;
    }
    else  if(![Utility validateField:_locationTextField.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter Address" block:^(int index) {
            
        }];
        return false;
    }
    
    
    else if(![Utility validateField:_zipCodeTextField.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter Postcode" block:^(int index) {
            
        }];
        return false;
    }
    
    return true;
}

/****************************
 * Function Name : - getMobileNumber
 * Create on : - 03 march 2016
 * Developed By : - Ramniwas
 * Description : - This function are used for remove phone number formate
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(NSString *)getMobileNumber:(NSString *)string{
    
    NSString *strQueryString = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return strQueryString;
}

#pragma mark - APIS
-(void)callRegisterAPI:(NSMutableDictionary*)dictionary{
    
    SignupUserServerRequest *signup = [[SignupUserServerRequest alloc] initWithDict:dictionary];
    signup.requestDelegate=self;
    [signup startAsynchronous];
    [Utility ShowMBHUDLoader];
    
}

-(void)SignupUserServerRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    
    NSMutableDictionary *payLoad = [inData valueForKey:kAPIPayload];
    
    [payLoad setValue:[payLoad valueForKey:@"MemberShipId"] forKey:@"MembershipID"];
    
    [kUserDefault setValue:[Utility archiveData:payLoad] forKey:kLoginInfo];
    [self performSegueWithIdentifier:kverifyOTPSegueIdentifier sender:nil];
    
}
-(void)SignupUserServerRequestFailedWithErrorMessage:(NSString *)inFailedData

{
    [Utility hideMBHUDLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma  mark - update profile

-(void)updateProfileAddress{
    
    NSMutableDictionary *loginDicationary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:[loginDicationary valueForKey:@"RefMembershipID"] forKey:@"MembershipId"];
    
    [updateDictionary setObject:_locationTextField.text forKey:@"Address1"];
    [updateDictionary setObject:_zipCodeTextField.text forKey:@"ZipCode"];
    
    
    if (_segment.selectedSegmentIndex ==1) {
        if (localityID) {
            [updateDictionary setObject:localityID forKey:@"LocalityId"];
        }
        else{
            [updateDictionary setObject:@"0" forKey:@"LocalityId"];
        }
    }
    if ([subrubDictionary valueForKey:@"RefCityId"]) {
        [updateDictionary setObject:[subrubDictionary valueForKey:@"RefCityId"] forKey:kCityId];
    }
    else{
        NSString *CityId;
        if([[loginDicationary  valueForKey:@"CityId"] integerValue]>0)
        {
            CityId = [NSString stringWithFormat:@"%@",[loginDicationary  valueForKey:@"CityId"]];
        }
        else
        {
            CityId = [NSString stringWithFormat:@"%@",[loginDicationary  valueForKey:@"CityID"]];
        }
        if(CityId>0)
        {
            [updateDictionary setObject:CityId forKey:kCityId];
        }
        else
        {
            [updateDictionary setObject:@"0" forKey:kCityId];
        }
        
    }
    
    UpdateProfileRequest *cancel = [[UpdateProfileRequest alloc] initWithDict:updateDictionary];
    cancel.requestDelegate=self;
    [cancel startAsynchronous];
    [Utility ShowMBHUDLoader];
}

#pragma  mark - update profile

-(void)updateProfile{
    
    NSMutableDictionary *loginDicationary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    updateDictionary = [[NSMutableDictionary alloc] init];
    
    [updateDictionary setObject:[loginDicationary valueForKey:@"RefMembershipID"] forKey:@"MembershipId"];
    [updateDictionary setObject:_firstNameTextField.text forKey:@"FirstName"];
    [updateDictionary setObject:_lastNameTextField.text forKey:@"LastName"];
    [updateDictionary setObject:_emailTextField.text forKey:@"Email"];
    [updateDictionary setObject:_phoneNumberTextField.text forKey:@"MobileNumber"];
    [updateDictionary setObject:_phoneNumberTextField.text forKey:@"MobileNumber"];
    
    
    if (localityID) {
        [updateDictionary setObject:localityID forKey:@"LocalityId"];
    }
    else{
        [updateDictionary setObject:@"0" forKey:@"LocalityId"];
    }
    
    if ([subrubDictionary valueForKey:@"RefCityId"]) {
        [updateDictionary setObject:[subrubDictionary valueForKey:@"RefCityId"] forKey:kCityId];
    }
    else{
        NSString *CityId;
        if([[loginDicationary  valueForKey:@"CityId"] integerValue]>0)
        {
            CityId = [NSString stringWithFormat:@"%@",[loginDicationary  valueForKey:@"CityId"]];
        }
        else
        {
            CityId = [NSString stringWithFormat:@"%@",[loginDicationary  valueForKey:@"CityID"]];
        }
        if(CityId>0)
        {
            [updateDictionary setObject:CityId forKey:kCityId];
        }
        else
        {
            [updateDictionary setObject:@"0" forKey:kCityId];
        }

       // [updateDictionary setObject:@"0" forKey:kCityId];
    }
    
    [updateDictionary setObject:@"jpg" forKey:@"ImageName"];
    
    
    
    NSString *encodedString = [Utility encodeToBase64String:_profileImage.image];
    
    
    [updateDictionary setObject:encodedString forKey:@"ImageBase64String"];
    
    UpdateProfileRequest *cancel = [[UpdateProfileRequest alloc] initWithDict:updateDictionary ];
    cancel.requestDelegate=self;
    [cancel startAsynchronous];
    [Utility ShowMBHUDLoader];
    
}


-(void)UpdateProfileRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    // [self disAbleUserInteration];
    
    isEdit = NO;
    //    _registerButton.hidden = YES;
    
    NSMutableDictionary *loginDicationary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *payload = [inData valueForKey:kAPIPayload];
    
    if (_segment.selectedSegmentIndex ==0) {
        [loginDicationary setObject:[payload valueForKey:@"Photo"] forKey:@"Photo"];
        [loginDicationary setObject:_firstNameTextField.text forKey:kfirstname];
        [loginDicationary setObject:_lastNameTextField.text forKey:klastname];
    }
    else{
        
        if (![[updateDictionary valueForKey:kZipCode] isKindOfClass:[NSNull class]]) {
            [loginDicationary setObject:[updateDictionary valueForKey:kZipCode] forKey:kZipCode];
        }
        NSLog(@"%@",[subrubDictionary valueForKey:@"RefCityId"]);
        if ([[Utility replaceNULL:[subrubDictionary valueForKey:@"RefCityId"] value:@""] integerValue]>0) {
            
             [loginDicationary setObject:[Utility replaceNULL:[subrubDictionary valueForKey:@"RefCityId"] value:@"0"] forKey:kCityId];
        }
        else{
            NSString *CityId;
            if([[loginDicationary  valueForKey:@"CityId"] integerValue]>0)
            {
                CityId = [NSString stringWithFormat:@"%@",[loginDicationary  valueForKey:@"CityId"]];
            }
            else
            {
                CityId = [NSString stringWithFormat:@"%@",[loginDicationary  valueForKey:@"CityID"]];
            }
            if(CityId>0)
            {
                [loginDicationary setObject:CityId forKey:kCityId];
            }
            else
            {
                [loginDicationary setObject:@"0" forKey:kCityId];
            }

           //[loginDicationary setObject:@"0" forKey:kCityId];
        }
        
        [loginDicationary setObject:_locationTextField.text forKey:kLocationName];
        [loginDicationary setObject:_locationTextField.text forKey:@"Address1"];
        [loginDicationary setObject:localityID forKey:@"LocalityId"];
        [loginDicationary setObject:_stateTextField.text forKey:@"StateName"];
        [loginDicationary setObject:_localityTextField.text forKey:@"Location"];
    }
    
    [kUserDefault setValue:[Utility archiveData:loginDicationary] forKey:kLoginInfo];
    
    
    NSString *msg = [inData objectForKey:@"Message"];
    
    [Utility showAlertViewControllerIn:self title:@"" message:msg block:^
     (int index){
         if ([self.modeType isEqualToString:kOrderSummary]) {
             [self.navigationController popViewControllerAnimated: YES];
         }
     }];
    
}
-(void)UpdateProfileRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}


#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"

-(void)sendOTP:(NSString*)phoneNumber{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:[self getMobileNumber:phoneNumber] forKey:@"mobilenumber"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"otp-login-student.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //   NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    _emailTextField.text = @"";
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:BGError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}


#pragma  mark map view delegate

-(void)getLatLongFromAddress{
    
    NSString *address;
    if (_locationTextField.text.length>0) {
        
        address = [NSString stringWithFormat:@"%@,%@,%@",_locationTextField.text,_localityTextField.text,_stateTextField.text];
    }
    else{
        address = [NSString stringWithFormat:@"%@,%@",_localityTextField.text,_stateTextField.text];
    }
    
    
    if (geocoder) {
        [geocoder cancelGeocode];
    }
    geocoder = [[CLGeocoder alloc] init] ;
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(!error)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             appDelegate.lat = placemark.location.coordinate.latitude;
             appDelegate.lon = placemark.location.coordinate.longitude;
             
             [_mapView reloadInputViews];
             NSLog(@"%f",placemark.location.coordinate.latitude);
             NSLog(@"%f",placemark.location.coordinate.longitude);
             NSLog(@"%@",[NSString stringWithFormat:@"%@",[placemark description]]);
             
             [_mapView removeAnnotations:_mapView.annotations];
             CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
             
             MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cord, 800, 800);
             [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
             
             
             
             MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
             point.coordinate = cord;
             point.title = @"The Location";
             point.subtitle = @"Sub-title";
             [_mapView addAnnotation:point];
         }
         else
         {
             NSLog(@"There was a forward geocoding error\n%@",[error localizedDescription]);
         }
     }
     ];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString* myIdentifier = @"myIndentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
    
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = NO;
    }
    return pinView;
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kverifyOTPSegueIdentifier]) {
        
        BGOTPViewController *_OTPViewController = segue.destinationViewController;
        _OTPViewController.incomingType = kRegistration;
    }
    else if ([segue.identifier isEqualToString:kuserSelectionSegueIdentifier]) {
        
        BGSelectionViewController *userSelectionViewController = segue.destinationViewController;
        userSelectionViewController.delegate = self;
        userSelectionViewController.cityID = localityID;
        userSelectionViewController.userType = sender;
        
    }
    else  if ([segue.identifier isEqualToString:kwebviewSegueIdentifier]) {
        BGWebViewController *_wevView = segue.destinationViewController;
        _wevView.webviewMode = BGTermAndConditions;
    }
}

#pragma mark - selection delegate

-(void)selectData:(NSMutableDictionary *)dictionary type:(NSString *)type{
    
    subrubDictionary = dictionary;
    if ([type isEqualToString:kOtherLocation]) {
        _localityTextField.text = [dictionary valueForKey:@"LocationName"];
        
        if ([dictionary valueForKey:@"LocationID"]) {
            localityID = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"LocationID"]];
            _stateTextField.text = [dictionary valueForKey:@"RefStateName"];
        }
        
        [_loginDictionary valueForKey:@"RefMembershipID"];
        [_loginDictionary setValue:[dictionary valueForKey:@"RefCityName"] forKey:@"CityName"];
       
        [kUserDefault setValue:[Utility archiveData:_loginDictionary] forKey:kLoginInfo];
    }
    
    [self getLatLongFromAddress];
}

#pragma  mark - Cash
-(void) getCreditDetails{
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[_loginDictionary valueForKey:@"RefMembershipID"] forKey:@"MembershipId"];
    GetMyCredit *placeOrder = [[GetMyCredit alloc] initWithDict:dict];
    placeOrder.requestDelegate=self;
    [placeOrder startAsynchronous];
    [Utility ShowMBHUDLoader];
}

-(void)GetMyCreditrRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    cashDictionary = [inData objectForKey:@"Payload"];
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ AUD",[cashDictionary valueForKey:@"DueAmount"]];
    [Utility hideMBHUDLoader];
    [self getAccDetail];
    
}
-(void)GetMyCreditRequestFailedWithErrorMessage:(NSString *)inFailedData{
    [Utility hideMBHUDLoader];
}

-(void) getAccDetail{
    
    if (!self.getAccountDetail){
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"AccountDetail"])
        {
            NSData *myData = [[NSUserDefaults standardUserDefaults] valueForKey:@"AccountDetail"];
            NSDictionary *dic = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
            
            if ([[_loginDictionary valueForKey:@"RefMembershipID"] isEqual:[dic valueForKey:@"MembershipID"]])
            {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            }
            else
            {
                [Utility ShowMBHUDLoader];
            }
        }
        else{
            [Utility ShowMBHUDLoader];
            
        }
        
        NSNumber *memID = [_loginDictionary objectForKey:@"RefMembershipID"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:memID forKey:@"membershipId"];
        [dict setObject:@"60"forKey:@"days"];
        self.getAccountDetail = [[GetAccDetail alloc] initWithDict:dict];
        self.getAccountDetail.requestDelegate=self;
        [self.getAccountDetail startAsynchronous];
    }
}
-(void) GetAccDetailRequestFailedWithErrorMessage:(NSString *)inFailedData {
    [Utility hideMBHUDLoader];
    
}

-(void) GetAccDetailRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData {
    [Utility hideMBHUDLoader];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMM-yyyy hh:mm aa"];
    NSString *strDate = [df stringFromDate:[NSDate date]];
    NSString *strMessage = [NSString stringWithFormat:@"%@\nLast updated on %@",[inData valueForKey:@"Message"],strDate];
    [inData setValue:strMessage forKey:@"Message"];
    
    
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    
    [dictionary setObject:inData forKey:@"AccountDetail"];
    NSData *myData=[NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:myData forKey:@"AccountDetail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    transactionArray = [inData valueForKey:kAPIPayload];
    [_registerTable reloadData];
}

-(void)getSummary{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[_loginDictionary valueForKey:@"RefMembershipID"] forKey:@"MembershipId"];
    //[dict setObject:@"60"forKey:@"days"];
    GetSummaryDetail *sum_det = [[GetSummaryDetail alloc] initWithDict:dict];
    sum_det.requestDelegate=self;
    [sum_det startAsynchronous];
    [Utility ShowMBHUDLoader];
}

-(void)GetSummaryDetailRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    transactionArray=[inData objectForKey:@"Payload"];
    [Utility hideMBHUDLoader];
}
-(void)GetSummaryDetailRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];
}

/*-(void)SetSuberbDic:(NSMutableDictionary*)dic
{
    NSMutableDictionary *cityDictionary = (NSMutableDictionary *)[UtilityPlist  getData:kCityList];
    NSMutableArray *cityList = [cityDictionary valueForKey:kAPIPayload];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"LocationID = %@",[NSString stringWithFormat:@"%@",[dic valueForKey:@"LocalityId"]]];
    NSArray *filterArray = [cityList filteredArrayUsingPredicate:predicate];
    
    if (filterArray.count>0) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[filterArray objectAtIndex:0]];
        subrubDictionary = dictionary;
        _localityTextField.text = [dictionary valueForKey:@"LocationName"];
        
        if ([dictionary valueForKey:@"LocationID"]) {
            localityID = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"LocationID"]];
            _stateTextField.text = [dictionary valueForKey:@"RefStateName"];
        }
        
        [self getLatLongFromAddress];
    }

}*/
@end

//
//  BGSignInViewController.m
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGSignInViewController.h"
#import "SignInCell.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BGRegistrationViewController.h"

@interface BGSignInViewController (){
    NSMutableDictionary *_loginDictionary;
}
@end

typedef enum
{   email = 0,
    password
    
} textFieldType;

@implementation BGSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    //[[GIDSignIn sharedInstance] signInSilently];
    
    _infoDictionary = [[NSMutableDictionary alloc]init];
    
    // set remember me
    
    _loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    // set initial layout
    [self setupInitialLayout];
    
   if (![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kguestLoginTutorial] value:@""] isEqualToString:@"NO"]) {
        SSTutorialViewController *tutorialView = [[SSTutorialViewController alloc]initWithNibName:@"SSTutorialViewController" bundle:[NSBundle mainBundle]];
        tutorialView.incomingViewType = kguestLoginTutorial;
        [self presentViewController:tutorialView animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/****************************
 * Function Name : - setUPInitialLayout
 * Create on : - 02 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function initilization all the basic control before screen load
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)setupInitialLayout{
    
    //Intialize Common Options for TextField
    
    CGRect frame = CGRectMake(55,10 , kiPhoneWidth-75, 30);
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    //Setup  email Field
    [optionDictionary setValue:@"Email ID/ Phone Number" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:kTextFeildOptionKeyboardType];

    _emailText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    
    //Setup  password Field
    frame = CGRectMake(55,10 , kiPhoneWidth-150, 30);
    
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Password" forKey:kTextFeildOptionPlaceholder];
    _passwordText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _passwordText.returnKeyType = UIReturnKeyDone;
    
    
    // forgot password button
    _forgotPasswordButton = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-90, 10, 90, 30)];
    _forgotPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forgotPasswordButton setTitleColor:kDefaultLightGreen forState:UIControlStateNormal];    [_forgotPasswordButton setTitle:@"Forgot?" forState:UIControlStateNormal];
    [_forgotPasswordButton addTarget:self action:@selector(forgotPasswordButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_webView loadHTMLString:@"<font face = 'arial'><span style='font-size:14px;text-align: center; color:#3B455D'><p>New user?<a href='' style='color:#3B455D;'>Click here to Register Now!</a></p></span></font>" baseURL:nil];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
}

#pragma mark - GPPSignInDelegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    NSString *userId = user.userID;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    CGSize thumbSize=CGSizeMake(300, 300);
    NSURL *imageURL;
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage){
        
        NSUInteger dimension = round(thumbSize.width * [[UIScreen mainScreen] scale]);
        imageURL = [user.profile imageURLWithDimension:dimension];
        NSLog(@"image url=%@",imageURL);
    }
    
    if (userId.length>0 && ![userId isKindOfClass:[NSNull class]]) {
        [_infoDictionary setObject:familyName forKey:klastname];
        [_infoDictionary setObject:givenName forKey:kfirstname];
        [_infoDictionary setObject:userId forKey:kSocialId];
        [_infoDictionary setObject:email forKey:kEmail];
        [_infoDictionary setObject:[NSString stringWithFormat:@"%@",imageURL] forKey:kProfile_image];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:userId forKey:@"value"];
        [dic setObject:@"google" forKey:@"field"];
        
        CheckUserExistanceRequest *checkRequest = [[CheckUserExistanceRequest alloc] initWithDict: dic];
        checkRequest.requestDelegate=self;
        [checkRequest startAsynchronous];
        [Utility ShowMBHUDLoader];
        
    }
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"signIn";
    
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SignInCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == email) {
        
        [cell.textField removeFromSuperview];
        cell.textField = _emailText;
        [cell.contentView addSubview:cell.textField];
        
        _forgotPasswordButton.hidden = YES;
        cell._imageView.image = [UIImage imageNamed:@"mail"];
    }
    else  if (indexPath.row == password) {
        
        [cell.textField removeFromSuperview];
        cell.textField = _passwordText;
        cell.textField.secureTextEntry = true;
        [cell.contentView addSubview:cell.textField];
        
        [cell.contentView addSubview:_forgotPasswordButton];
        _forgotPasswordButton.hidden = NO;
        
        cell._imageView.image = [UIImage imageNamed:@"password"];
        
        // _hintButton  button
        _hintButton = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-105, 10, 30, 30)];
        _hintButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _hintButton.backgroundColor = [UIColor clearColor];
        _hintButton.tag = indexPath.row;
        [_hintButton addTarget:self action:@selector(hintButtonButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        _hintButton.tag = indexPath.row;
        [_hintButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        [cell.contentView addSubview:_hintButton];
    }
    
    NSString *rememberMe = [Utility replaceNULL:[kUserDefault valueForKey:krememberMe] value:@""];
    
    if ([rememberMe integerValue] == 1) {
        
        if ([_loginDictionary valueForKey:kEmail]) {
            _emailText.text = [_loginDictionary valueForKey:kEmail];
        }
        else{
            _emailText.text = [_loginDictionary valueForKey:kCustomerEmail];
            
        }
        _passwordText.text = [_loginDictionary valueForKey:kPassword];
        [rememberMeButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma  mark - button clicked

-(void)hintButtonButton_clicked:(UIButton *)sender{
    
    if (showPassword == true) {
        _passwordText.secureTextEntry = YES;
        showPassword = false;
        [_hintButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    }
    else{
        _passwordText.secureTextEntry = NO;
        showPassword = true;
        [_hintButton setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
    }
}

#pragma mark - Text Field delegate

-(void)textFieldDidChange:(UITextField *)text{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _emailText) {
        [_passwordText becomeFirstResponder];
    }
    if (textField == _passwordText) {
        [_passwordText resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == _emailText ){
        
        // All digits entered
        if (range.location == 50) {
            return NO;
        }
    }
    else if(textField == _passwordText ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        _loginType = @"";
        [_infoDictionary setValue:@"" forKey:kRegister_type];
        [_infoDictionary setValue:@"" forKey:kStype];
        [kUserDefault setValue:@"" forKey:kRegister_type];
        [self performSegueWithIdentifier:kregistrationSegueIdentifier sender:nil];
        
        return NO;
    }
    return YES;
}

/****************************
 * Function Name : - validatePassword
 * Create on : - 2 march 2017
 * Developed By : -  Ramniwas
 * Description : -  This funtion are use for check validation in registration form
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    if(![Utility validateField:_emailText.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter email Id/ Phone Number" block:^(int index) {
            
        }];
        return false;
    }
    
    else if(![Utility validateField:_passwordText.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please Enter Password" block:^(int index) {
            
        }];
        return false;
    }
    
    return true;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;
    
    if ([segue.identifier isEqualToString:kregistrationSegueIdentifier]) {
        BGRegistrationViewController *registrationController = segue.destinationViewController;
        registrationController.loginType = _loginType;
        registrationController.infoDictionary = sender;
    }
    else if ([segue.identifier isEqualToString:kverifyOTPSegueIdentifier]){
        
        BGOTPViewController *_OTPViewController = segue.destinationViewController;
        _OTPViewController.incomingType = sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Google Logout
// If there is an option for Google Logout use this
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

#pragma mark - Button Clicked

- (IBAction)loginButton_clicked:(id)sender {
    
    if ([self validatePassword]) {
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        
        [dictionary setValue:_emailText.text forKey:@"email"];
        [dictionary setValue:_passwordText.text forKey:@"password"];
        [dictionary setObject:@"" forKey:@"MobileNo"];
        [dictionary setValue:@"ios" forKey:@"deviceType"];
        NSString *deviceToken = [kUserDefault valueForKey:@"devicetoken"];
        if(deviceToken!=nil){
            [dictionary setObject:deviceToken forKey:@"deviceId"];
            [dictionary setObject:deviceToken forKey:@"DeviceId"];
        }
        
        [self login:dictionary];
    }
}

- (IBAction)googlePluseButton_clicked:(id)sender {
    _loginType = @"S";
    [kUserDefault setValue:@"S" forKey:kRegister_type];
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)guestButton_clicked:(id)sender {
    
    [kUserDefault setValue:kGuestUser forKey:kGuestUser];
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BGHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    BGRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    revealController.delegate = self;
    
    self.revealViewController = revealController;
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    self.window.backgroundColor = [UIColor redColor];
    
    self.window.rootViewController =self.revealViewController;
    [self.window makeKeyAndVisible];
}

- (IBAction)fbLoginButton_Clicked:(id)sender {
    
    _loginType = @"S";
    [_infoDictionary setValue:@"S" forKey:kRegister_type];
    [_infoDictionary setValue:@"F" forKey:kStype];
    [kUserDefault setValue:@"S" forKey:kRegister_type];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             NSLog(@"%@,%@",result,error);
             [Utility showAlertViewControllerIn:self title:kErrorTitle message:@"Unable to process with facebook login please try later" block:^(int index) {
                 
             }];
             
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             
             NSLog(@"%@",result);
         } else {
             [Utility ShowMBHUDLoader];
             
             [self fetchFbInfo];
         }
     }];
}

- (IBAction)rememberMeButton_clicked:(id)sender {
    
    _infoDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    if ([self validatePassword]) {
        
        NSString *rememberMe = [Utility replaceNULL:[kUserDefault valueForKey:krememberMe] value:@""];
        
        if ([rememberMe integerValue ] == 0) {
            [rememberMeButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
            
            rememberMe = @"1";
        }
        else{
            [rememberMeButton setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
            rememberMe = @"0";
        }
        
        [kUserDefault setValue:rememberMe forKey:krememberMe];
        [_infoDictionary setValue:_emailText.text forKey:kEmail];
        [_infoDictionary setValue:_passwordText.text forKey:kPassword];
        
        
        [kUserDefault setValue:[Utility archiveData:_infoDictionary] forKey:kLoginInfo];
    }
}



/****************************
 * Function Name : - facebookButton_Clicked
 * Create on : - 3 march 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion fetches facebook profile information
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)fetchFbInfo{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,first_name,gender,last_name,picture.type(large)" forKey:@"fields"];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error){
         [Utility hideMBHUDLoader];
         
         if (!error) {
             NSLog(@"%@",result);
             [self getFBDate:result];
         }
         else{
             NSLog(@"%@",error);
             [Utility hideMBHUDLoader];
             
         }
     }];
}

/****************************
 * Function Name : - getFBDate
 * Create on : - 3 march 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion are used for get FB date
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)getFBDate:(id)result{
    
    if (result[@"last_name"]) {
        [_infoDictionary setObject:result[@"last_name"] forKey:klastname];}
    
    if (result[@"first_name"]) {
        [_infoDictionary setObject:result[@"first_name"] forKey:kfirstname];}
    
    if (result[@"gender"]) {
        [_infoDictionary setObject:result[@"gender"] forKey:kGender];}
    
    NSString *url = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
    
    if (url) {
        [_infoDictionary setObject:url forKey:kProfile_image];}
    
    if (result[@"id"]) {
        [_infoDictionary setObject:result[@"id"] forKey:kSocialId];}
    
    if (result[@"email"]) {
        
        [_infoDictionary setObject:result[@"email"] forKey:kEmail];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:result[@"id"] forKey:@"value"];
    [dic setObject:@"facebook" forKey:@"field"];
    
    CheckUserExistanceRequest *checkRequest = [[CheckUserExistanceRequest alloc] initWithDict: dic];
    checkRequest.requestDelegate=self;
    [checkRequest startAsynchronous];
    [Utility ShowMBHUDLoader];
    
}

#pragma mark - APIS


-(void)CheckUserExistanceRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    
    NSMutableArray *payLoad = [inData objectForKey:@"Payload"];
    
    if ([payLoad count]>0) {
        NSMutableDictionary *payLoadDic =[payLoad objectAtIndex:0];
        if([[payLoadDic objectForKey:@"memberStatus"] isEqualToString:@"N"])
        {
            [self performSegueWithIdentifier:kverifyOTPSegueIdentifier sender:klogin];
        }
        else if ([[inData valueForKey:@"Code"] isEqualToString:@"UE"]){
            
            NSArray *array = [inData valueForKey:kAPIPayload];
            if (array.count>0) {
                
                [kUserDefault setValue:[Utility archiveData:[array objectAtIndex:0]] forKey:kLoginInfo];
            }
            
            [kUserDefault setValue:@"" forKey:kGuestUser];
            
            UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            BGHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
            
            BGRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            
            revealController.delegate = self;
            
            self.revealViewController = revealController;
            
            self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
            self.window.backgroundColor = [UIColor redColor];
            
            self.window.rootViewController =self.revealViewController;
            [self.window makeKeyAndVisible];
            
        }
        else if ([[inData valueForKey:@"Code"] isEqualToString:@"UE"]){
            [self performSegueWithIdentifier:kregistrationSegueIdentifier sender:_infoDictionary];
        }
    }
    
}
-(void)CheckUserExistanceRequestFailedWithErrorMessage:(NSString *)inFailedData

{
    [Utility hideMBHUDLoader];
    
    [self performSegueWithIdentifier:kregistrationSegueIdentifier sender:_infoDictionary];
    
}

-(void)login:(NSMutableDictionary*)dictionary{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,SIGNIN];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:STATUS] boolValue] == true
                    ) {
                    
                    // get user details
                    NSMutableDictionary *payLoad = [dictionary objectForKey:@"Payload"];
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[payLoad objectForKey:@"CustomerID"] forKey:@"customerId"];
                    
                    [Utility ShowMBHUDLoader];
                    GetCustomerRequest *customerRequest = [[GetCustomerRequest alloc] initWithDict: dic];
                    customerRequest.requestDelegate=self;
                    [customerRequest startAsynchronous];
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                            NSLog(@"%@",payloadDictionary);
                            if ([[dictionary valueForKey:@"Code"] isEqualToString:@"NA"]) {
                                [kUserDefault setValue:[Utility archiveData:payloadDictionary] forKey:kLoginInfo];
                                [self performSegueWithIdentifier:kverifyOTPSegueIdentifier sender:klogin];
                            }
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


#pragma  mark - forgot password
- (void)forgotPasswordButton_clicked:(id)sender {
    [_passwordText  resignFirstResponder];
    [_emailText  resignFirstResponder];
    
    if ([_emailText.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter email Id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [_emailText becomeFirstResponder];
    }
    
    else if ([[NSCharacterSet letterCharacterSet] characterIsMember:[_emailText.text characterAtIndex:0]] && ![Utility validateEmail:_emailText.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid email Id" block:^(int index) {
            
        }];
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:_emailText.text forKey:@"Email"];
        ForgotPasswordRequest *forgate = [[ForgotPasswordRequest alloc] initWithDict:dict];
        forgate.requestDelegate=self;
        [forgate startAsynchronous];
        [Utility ShowMBHUDLoader];
    }
}

-(void)ForgotPasswordRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    NSMutableDictionary *payLoadDic =[inData objectForKey:@"Payload"];
    [[NSUserDefaults standardUserDefaults] setObject:[payLoadDic objectForKey:@"MobileNo"] forKey:@"MobileNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:[payLoadDic objectForKey:@"MembershipID"] forKey:@"MembershipID"];
    [[NSUserDefaults standardUserDefaults] setObject:[payLoadDic objectForKey:@"OTP"] forKey:@"ActivationCode"];
    
    NSMutableDictionary *loginDictionary = [[NSMutableDictionary alloc] init];
    
    [loginDictionary setValue:[NSString stringWithFormat:@"%@",[payLoadDic objectForKey:@"MobileNo"]] forKey:@"MobileNumber"];
    [loginDictionary setValue:[NSString stringWithFormat:@"%@",[payLoadDic objectForKey:@"MembershipID"]] forKey:@"MemberShipId"];
    [loginDictionary setValue:[NSString stringWithFormat:@"%@",[payLoadDic objectForKey:@"OTP"]] forKey:@"ActivationCode"];
    
    [kUserDefault setValue:[Utility archiveData:loginDictionary] forKey:kLoginInfo];
    
    [self performSegueWithIdentifier:kverifyOTPSegueIdentifier sender:kForgotPassword];
    
    
    
}
-(void)ForgotPasswordRequestFailedWithErrorMessage:(NSString *)inFailedData

{
    [Utility hideMBHUDLoader];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma  mark - get user details

-(void)GetCustomerRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];
    if([inFailedData isEqualToString:@"Email id available for registration."])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"You don't seems to be registred with Brown And Green" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
-(void)GetCustomerRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    
    [Utility hideMBHUDLoader];
    
    NSArray *array = [inData valueForKey:kAPIPayload];
    
    if (array.count>0) {
        [kUserDefault setValue:[Utility archiveData:[array objectAtIndex:0]] forKey:kLoginInfo];
    }
    
    [kUserDefault setValue:@"" forKey:kRegister_type];
    [kUserDefault setValue:@"" forKey:kGuestUser];
    
    NSString *incomingScreen = [Utility replaceNULL:[kUserDefault valueForKey:kGuestUserInComingScreen] value:@""];
    
    
    if ([incomingScreen isEqualToString:@"donate"]) {
        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        TestingVC *testingVC =[storyBoard instantiateViewControllerWithIdentifier:@"TestingVC"];
        
        BGRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:testingVC];
        
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        
        revealController.delegate = self;
        
        self.revealViewController = revealController;
        
        self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
        self.window.backgroundColor = [UIColor redColor];
        
        self.window.rootViewController =self.revealViewController;
        [self.window makeKeyAndVisible];
        
    }
    else{
        [self loginToHomeView];
    }
}

-(void)loginToHomeView{
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BGHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    BGRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    revealController.delegate = self;
    
    self.revealViewController = revealController;
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    self.window.backgroundColor = [UIColor redColor];
    
    self.window.rootViewController =self.revealViewController;
    [self.window makeKeyAndVisible];
}
@end

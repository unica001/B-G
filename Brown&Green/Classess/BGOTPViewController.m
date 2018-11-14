//
//  BGOTPViewController.m
//  Unica
//
//  Created by vineet patidar on 02/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGOTPViewController.h"
#import "PhoneNumberFormatter.h"
#import "BGSignInViewController.h"
#import "BGWebViewController.h"


@interface BGOTPViewController (){

    NSMutableDictionary *loginDictionary;
}

@end

@implementation BGOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // make view round up
    _whiteView.layer.cornerRadius = 5.0;
    [_whiteView.layer setMasksToBounds:YES];
    
    // code for enable resend code button
    
    _timeSlider.value = 0;
    _sliderCount = 0;
    
    countResendTimer = 60;
    _timerLabel.text = [NSString stringWithFormat:@"%d sec",countResendTimer];
    _secondsCountTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(secondsCountTimerShedule) userInfo:nil repeats:YES];
    
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    _userID = [loginDictionary valueForKey:Kuserid];
    
    // check incomingview type
    if ([self.incomingType isEqualToString:kRegistration]) {
        
        _OTPLabel.text = @"Sit Back & relax we are verfing your mobile No.";
        _verifyLabel.text = @"(Enter OTP below in case if we fail to detect OTP automatically )";
        self.title = @"Mobile Verification";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
 
    return YES;
}



- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {
   
    if(string.length==0)
    {
        return YES;
    }
    else
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSUInteger newLength = newString.length;
        
        if(textField==_emailTextField && newLength ==6)
        {
            [_emailTextField resignFirstResponder];
        }
        
        return YES;
    }
    
    return YES;
}

#pragma mark - Butoon Clicked

/****************************
 * Function Name : - resendCode_Clicked
 * Create on : -  03 marcj 2017
 * Developed By : - Ramniwas
 * Description : - This Function are used for resend OTP
 
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (IBAction)resendCodeButton_clicked:(id)sender {
    
    _sliderCount = 0;
    _timeSlider.value = 0;
    countResendTimer = 60;
    _timerLabel.text = [NSString stringWithFormat:@"%d sec",countResendTimer];
    _secondsCountTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(secondsCountTimerShedule) userInfo:nil repeats:YES];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    
    NSMutableDictionary *_loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *memID = [NSString stringWithFormat:@"%@",[_loginInfo objectForKey:@"MembershipID"]];
    [dictionary setValue:memID forKey:@"membershipId"];
    
    [self resendCode:dictionary];
  

    
}

-(void)SendOTPRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{

    [Utility hideMBHUDLoader];
    [[NSUserDefaults standardUserDefaults] setObject:[[inData objectForKey:@"Payload"] valueForKey:@"ActivationCode"] forKey:@"ActivationCode"];
    
}
-(void)SendOTPRequestFailedWithErrorMessage:(NSString *)inFailedData {
    [Utility hideMBHUDLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)sliderValue:(int )timer{
    
    _timeSlider.value = timer;
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (IBAction)cancelButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginButton_clicked:(id)sender {

}

- (IBAction)verifyButton_clicked:(id)sender {
   
    if ([self validatePassword]) {
        
        NSMutableDictionary *_loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        NSString *verifyCode = [_loginInfo valueForKey:kActivationCode];

        if ([self.incomingType isEqualToString:kRegistration] || [self.incomingType isEqualToString:klogin]) {

            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            //[dictionary setValue:[loginDictionary valueForKey:@"MembershipID"] forKey:@"MembershipId"];
            if([loginDictionary valueForKey:@"MembershipID"])
            {
                [dictionary setValue:[loginDictionary objectForKey:@"MembershipID"] forKey:@"MembershipId"];
            }
            else
            {
                [dictionary setValue:[loginDictionary objectForKey:@"RefMembershipID"] forKey:@"MembershipId"];
            }
             [self verifyMobileNumber:dictionary];
        }
        else  {
            
            if ([_emailTextField.text isEqualToString:verifyCode]) {
                [self performSegueWithIdentifier:ksetPasswordSegueIdentifier sender:nil];
            }
            else{
                [Utility showAlertViewControllerIn:self title:@"" message:@"Please enter valid OTP" block:^(int index){}];
            }

        }
 
    }
    
}

-(void)loginCode{

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
    [self.window makeKeyAndVisible];}

/****************************
 * Function Name : - validateUserProfile
 * Create on : - 26 April 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used to validate user mobile number
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    NSMutableDictionary *_loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *verifyCode;
    if([_loginInfo valueForKey:kActivationCode])
    {
        verifyCode = [_loginInfo valueForKey:kActivationCode];
    }
    else
    {
        verifyCode = [_loginInfo valueForKey:@"OTN"];
    }
   // NSString *verifyCode = [_loginInfo valueForKey:kActivationCode];
    
    if(!(_emailTextField.text.length > 0)){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter OTP" block:^(int index) {
            
        }];
        return false;
    }
    else if(!([verifyCode isEqualToString:[Utility replaceNULL:_emailTextField.text value:@""]])){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid OTP" block:^(int index) {
            
        }];
        return false;
    }
    
    return true;
}


/****************************
 * Function Name : - checkMarkButton_Clicked
 * Create on : -  06 march 2017
 * Developed By : - Ramniwas
 * Description : - This funtiion are used fo check term & condition check mark
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (IBAction)checkMarkButton_clicked:(id)sender {
    
    self.isAgreeTerms = !self.isAgreeTerms;
    UIButton *button = (UIButton *)sender;
    
    //Check Wether button state is selected or unselcted and set the desire image
    if (self.isAgreeTerms == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"UnCheck"] forState:UIControlStateNormal];
    }
}


/****************************
 * Function Name : - secondsCountTimerShedule
 * Create on : -  03 march 2017
 * Developed By : - Ramniwas
 * Description : - Thid funtion are used for timer second count
 
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)secondsCountTimerShedule{
    
    countResendTimer--;
    _timerLabel.text  = [NSString stringWithFormat:@"%d sec",countResendTimer];
    
    
    _sliderCount = _sliderCount+1;
    [self sliderValue:_sliderCount];
    
    _resendCodeButton.enabled = NO;
    _resendCodeButton.alpha = 0.4;
    
    if (countResendTimer==0) {
        _resendCodeButton.enabled = YES;
        _resendCodeButton.alpha = 1.0;
        
        [_secondsCountTimer invalidate];
        _secondsCountTimer=nil;
    }

}


/****************************
 * Function Name : - getMobileNumber
 * Create on : - 16 march 2017
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

#pragma mark - Webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
      //  [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:nil];

        
        return NO;
    }
    return YES;
}


#pragma mark - APIS
/****************************
 * Function Name : - APIs call
 * Create on : -  26 April 2017
 * Developed By : - Ramniwas
 * Description : - This funtiion are used for send and recieved data
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)resendCode:(NSMutableDictionary*)dictionary{
    
   NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,SENDOTP];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if ([[dictionary valueForKey:STATUS] boolValue] == 1) {
                    
                    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                    
                    NSMutableDictionary *payLoadDic = [dictionary valueForKey:kAPIPayload];
                   if([payLoadDic objectForKey:@"MembershipID"])
                   {
                       [loginDictionary setValue:[payLoadDic objectForKey:@"MembershipID"] forKey:@"MemberShipId"];
                   }
                    else
                    {
                        [loginDictionary setValue:[payLoadDic objectForKey:@"RefMembershipID"] forKey:@"MemberShipId"];
                    }
                   // [loginDictionary setValue:[payLoadDic objectForKey:@"MembershipID"] forKey:@"MemberShipId"];
                    [loginDictionary setValue:[payLoadDic objectForKey:kActivationCode] forKey:kActivationCode];
                    [kUserDefault setValue:[Utility archiveData:loginDictionary] forKey:kLoginInfo];
                    

                    _emailTextField.text = @"";
                    [Utility showAlertViewControllerIn:self title:@"Resend Code" message:[dictionary valueForKey:kAPIMessage] block:^(int index){
                        
                    }];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:@"Resend Code" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                          [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"Payload"] valueForKey:kActivationCode] forKey:kActivationCode];
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


-(void)verifyMobileNumber:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,ACTIVATECUSTOMERACC];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                                
                if ([[dictionary valueForKey:@"Code"] isEqualToString:@"OK"]) {
                    
                    
                    _emailTextField.text = @"";
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index){
                        
                        
                        if ([self.incomingType isEqualToString:kRegistration] ||[self.incomingType isEqualToString:klogin]) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                            [dic setObject:[loginDictionary objectForKey:@"CustomerID"] forKey:@"customerId"];
                            
                            [Utility ShowMBHUDLoader];
                            GetCustomerRequest *customerRequest = [[GetCustomerRequest alloc] initWithDict: dic];
                            customerRequest.requestDelegate=self;
                            [customerRequest startAsynchronous];
                        }
                        else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
   
                    }];
                }
                
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                            if ([self.incomingType isEqualToString:kRegistration]) {
                                
                                [kUserDefault setValue:@"" forKey:kRegister_type];
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
                            else{
                                
                                [self.navigationController popViewControllerAnimated:YES];
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
    [self loginCode];

    NSLog(@"%@",inData);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:kwebviewSegueIdentifier]) {
//        UNKWebViewController *_wevView = segue.destinationViewController;
//        _wevView.webviewMode = UNKTermAndConditions;
//    }
}


@end

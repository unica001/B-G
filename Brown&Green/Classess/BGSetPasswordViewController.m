//
//  BGSetPasswordViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 25/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGSetPasswordViewController.h"
typedef enum
{   email = 0,
    password,
  
} textFieldType;

@interface BGSetPasswordViewController (){
    NSMutableDictionary *loginInfo;
}

@end

@implementation BGSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showPassword = NO;
    showConfirmPassword = NO;
    oldPassword= NO;
    [self setupInitialLayout];
}

/****************************
 * Function Name : - setUPInitialLayout
 * Create on : - 25 April 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function initilization all the basic control before screen load
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)setupInitialLayout{
    
    //Intialize Common Options for TextField
    
    CGRect frame = CGRectMake(55,10 , kiPhoneWidth-105, 30);
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    //Setup  password Field
    frame = CGRectMake(55,10 , kiPhoneWidth-105, 30);
    
    
    
    [optionDictionary setValue:@"Old Password" forKey:kTextFeildOptionPlaceholder];
    _oldPassword = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _oldPassword.returnKeyType = UIReturnKeyNext;
    
    [optionDictionary setValue:@"New Password" forKey:kTextFeildOptionPlaceholder];
    _passwordText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _passwordText.returnKeyType = UIReturnKeyNext;
    
    
    
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Confirm New Password" forKey:kTextFeildOptionPlaceholder];
    _confirmPassword = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _confirmPassword.returnKeyType = UIReturnKeyDone;
    
    
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.incomingType isEqualToString:kChangePassword]) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"signIn";
    
    
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SignInCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // _hintButton  button
    _hintButton = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-50, 10, 30, 30)];
    _hintButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _hintButton.backgroundColor = [UIColor clearColor];
    _hintButton.tag = indexPath.row;
    [_hintButton addTarget:self action:@selector(hintButtonButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    _hintButton.tag = indexPath.row;
    [_hintButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [cell.contentView addSubview:_hintButton];
    
    
    if ([self.incomingType isEqualToString:kChangePassword]) {
        
        if (indexPath.row == 0) {
            [cell.textField removeFromSuperview];
            cell.textField = _oldPassword;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
        }
        else  if (indexPath.row == email+1) {
            [cell.textField removeFromSuperview];
            cell.textField = _passwordText;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
        }
        else  if (indexPath.row == password+1) {
            [cell.textField removeFromSuperview];
            cell.textField = _confirmPassword;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
        }
    }
    else{
    
    if (indexPath.row == email) {
        [cell.textField removeFromSuperview];
        cell.textField = _passwordText;
        cell.textField.secureTextEntry = true;
        [cell.contentView addSubview:cell.textField];
    }
    else  if (indexPath.row == password) {
        [cell.textField removeFromSuperview];
        cell.textField = _confirmPassword;
        cell.textField.secureTextEntry = true;
        [cell.contentView addSubview:cell.textField];
    }
    }
    
    cell._imageView.image = [UIImage imageNamed:@"password"];


    
    return cell;
}


#pragma mark - Text Field delegate

-(void)textFieldDidChange:(UITextField *)text{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.incomingType isEqualToString:kChangePassword]) {
        
        if (textField == _oldPassword) {
            [_passwordText becomeFirstResponder];
        }
       else if (textField == _passwordText) {
            [_confirmPassword becomeFirstResponder];
        }
        else if (textField == _confirmPassword) {
            [_confirmPassword resignFirstResponder];
        }

        
    }
    else{
    if (textField == _confirmPassword) {
        [_passwordText becomeFirstResponder];
    }
   else if (textField == _passwordText) {
        [_passwordText resignFirstResponder];
    }
}
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}


#pragma  mark - button clicked

/****************************
 * Function Name : - validate
 * Create on : - 26 April 2017
 * Developed By : -  Ramniwas
 * Description : - This Function is used  for show and hide password text
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)hintButtonButton_clicked:(UIButton *)sender{
    UIButton *btn = (UIButton*)sender;
    
    if ([self.incomingType isEqualToString:kChangePassword]) {
        if (sender.tag == 0) {
            if (oldPassword == true) {
                _oldPassword.secureTextEntry = NO;
                oldPassword = false;
                    [btn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
            }
            else{
                _oldPassword.secureTextEntry = YES;
                oldPassword = true;
                    [btn setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
                
            }
        }
        else  if (sender.tag == 1) {
            if (showPassword == true) {
                _passwordText.secureTextEntry = NO;
                showPassword = false;
                    [btn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
            }
            else{
                _passwordText.secureTextEntry = YES;
                showPassword = true;
                    [btn setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
                
            }
        }
        else if (sender.tag == 2) {
            if (showConfirmPassword == true) {
                _confirmPassword.secureTextEntry = NO;
                showConfirmPassword = false;
                    [btn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
            }
            else{
                _confirmPassword.secureTextEntry = YES;
                showConfirmPassword = true;
                    [btn setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
            }
        }
    }
    else{
    
    if (sender.tag == 0) {
        if (showPassword == true) {
            _passwordText.secureTextEntry = NO;
            showPassword = false;
                [btn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        }
        else{
            _passwordText.secureTextEntry = YES;
            showPassword = true;
                [btn setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];

        }
    }
    else if (sender.tag == 1) {
        if (showConfirmPassword == true) {
            _confirmPassword.secureTextEntry = NO;
            showConfirmPassword = false;
                [btn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        }
        else{
            _confirmPassword.secureTextEntry = YES;
            showConfirmPassword = true;
                [btn setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
        }
    }

    }
}

/****************************
 * Function Name : - validate
 * Create on : - 26 April 2017
 * Developed By : -  Ramniwas
 * Description : - This Function is used to validate  password  fields
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
 
    
    if ([self.incomingType isEqualToString:kChangePassword]) {

        if(![Utility validateField:_oldPassword.text] ){
            [Utility showAlertViewControllerIn:self title:BGError message:@"Old password can't be left blank" block:^(int index) {
                
            }];
            return false;
        }
    }
    
    if(![Utility validateField:_passwordText.text] ){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Current password can't be left blank" block:^(int index) {
            
        }];
        return false;
    }
    else if(![Utility validateField:_confirmPassword.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"New password can't be left blank" block:^(int index) {
            
        }];
        return false;
    }
    
    else if (!(_passwordText.text.length>5 && _passwordText.text.length<16)){
        
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid password. Password length should be between 6 to 15 character" block:^(int index) {
            
        }];
        return false;
    }
    else if (!(_confirmPassword.text.length>5 && _confirmPassword.text.length<16)){
        
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid password. Password length should be between 6 to 15 character" block:^(int index) {
            
        }];
        return false;
    }
   
//    else if(![Utility isValidPassword:_passwordText.text]){
//        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid password. It must be a combination of alphanumeric characters and length should be between 6 to 15 character" block:^(int index) {
//            
//        }];
//        return false;
//    }
//    
//    else if(![Utility isValidPassword:_confirmPassword.text]){
//        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid password. It must be a combination of alphanumeric characters and length should be between 6 to 15 character" block:^(int index) {
//            
//        }];
//        return false;
//    }
  
    else if(![_passwordText.text isEqualToString:_confirmPassword.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Your New password and Confirm password do not match" block:^(int index) {
            
        }];
        return false;
    }
    
    
    return true;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButton_clicked:(id)sender {
    
    [_passwordText resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    
    if ([self validatePassword]) {
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:_confirmPassword.text forKey:@"newPassword"];
        
         loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        if ([loginInfo valueForKey:@"MembershipID"]) {
            NSNumber *memID = [loginInfo valueForKey:@"MembershipID"];
            [dict setObject:memID forKey:@"membershipId"];
        }
        else if ([loginInfo valueForKey:@"MemberShipId"]) {
            NSNumber *memID = [loginInfo valueForKey:@"MemberShipId"];
            [dict setObject:memID forKey:@"membershipId"];
        }
        else if ([loginInfo valueForKey:@"RefMembershipID"]) {
            NSNumber *memID = [loginInfo valueForKey:@"RefMembershipID"];
            [dict setObject:memID forKey:@"membershipId"];
        }

            ChangePasswordRequest *sendOTP = [[ChangePasswordRequest alloc] initWithDict:dict];
            sendOTP.requestDelegate=self;
            [sendOTP startAsynchronous];
            [Utility ShowMBHUDLoader];

    }
}


#pragma mark - change password delegate

-(void)ChangePasswordRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    
    [Utility hideMBHUDLoader];
   
    
    [Utility showAlertViewControllerIn:self title:nil message:[inData valueForKey:@"Message"] block:^(int index){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
}
-(void)ChangePasswordRequestFailedWithErrorMessage:(NSString *)inFailedData

{
    [Utility hideMBHUDLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end

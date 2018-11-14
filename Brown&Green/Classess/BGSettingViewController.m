//
//  BGSettingViewController.m
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGSettingViewController.h"
#import "settingCell.h"
#import "BGWebViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface BGSettingViewController (){
    NSMutableDictionary *loginDictionary;
    NSString *registerType;
    NSString *guestUser;
}

@end

@implementation BGSettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    loginDictionary =[Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];    // make table round up
    
    guestUser = [Utility replaceNULL:[kUserDefault valueForKey:kGuestUser] value:@""];
    
    _settingTable.layer.cornerRadius = 5.0;
    [_settingTable.layer setMasksToBounds:YES];
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [_menuButton setTarget: self.revealViewController];
                [_menuButton setAction: @selector( revealToggle: )];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
        }
        self.revealViewController.delegate = self;
    
    settingArray = [[NSMutableArray alloc]initWithObjects:@"About Us",@"Contact Us",@"App Version",@"Change Password",@"Notification",@"Tutorial", nil];
    
    self.title = @"Settings";
    
     registerType = [kUserDefault  valueForKey:kRegister_type];

}

#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [settingArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([registerType isEqualToString:@"S"] && indexPath.row ==3) {
        return 0;
    }
    
    if ([guestUser isEqualToString:kGuestUser] && (indexPath.row == 4|| indexPath.row ==3)) {
        
        return 0;
    }
    
    return  50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"settingCell";
    settingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"settingCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [settingArray objectAtIndex:indexPath.row];
    
    cell.arrowImage.hidden = NO;
    
     if (indexPath.row ==2){
        
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.nameLabel.text = [NSString stringWithFormat:@"App Version - %@",version];
        
        cell.arrowImage.hidden = YES;
        cell.swithButton.hidden = YES;

    }
     else if (indexPath.row == 4 ){
         cell.swithButton.hidden = NO;
         cell.arrowImage.hidden = YES;
         cell.swithButton.tag = indexPath.row;

     }
     else if ( indexPath.row == 5){
         cell.swithButton.hidden = YES;
         cell.arrowImage.hidden = YES;
         
     }
    else {
        cell.arrowImage.hidden = NO;
        cell.swithButton.hidden = YES;
    }

    if ([registerType isEqualToString:@"S"] && indexPath.row ==3) {
        cell.hidden = YES;
    }
    
    if ([guestUser isEqualToString:kGuestUser] && (indexPath.row == 4||indexPath.row ==3)) {
        cell.hidden = YES;
    }
    
    NSString *notificationStatus = [NSString stringWithFormat:@"%@",[kUserDefault valueForKey:kNotifications]];
    if ([notificationStatus isEqualToString:@"off"]) {
        cell.swithButton.on = false;
    }
    
    
    
    NSLog(@"%@", [kUserDefault valueForKey:kTutorial]);

//    if (![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:khomeTutorial] value:@""] isEqualToString:@"NO"] ||![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kscheduleTutorial] value:@""] isEqualToString:@"NO"]|| ![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kguestLoginTutorial] value:@""] isEqualToString:@"NO"]||![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kMyOrderTutorial] value:@""] isEqualToString:@"NO"]||![[Utility replaceNULL:[[kUserDefault valueForKey:kTutorial] valueForKey:kkramTutorial] value:@""] isEqualToString:@"NO"]) {
//    }
    
   
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
    [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:nil];
    }
    else if (indexPath.row == 1) {
        
    [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:kContactUs];

    }
   else if (indexPath.row == 3) {
       [self changePasswordButton];
   }
   else if (indexPath.row == 4) {
   }
   else if (indexPath.row == 5){
       
       [Utility showAlertViewControllerIn:self title:@"" message:@"Tutorial Enable" block:^(int index){
           
           NSMutableDictionary *tutorialDictionary = [[NSMutableDictionary alloc]init];
           
           [tutorialDictionary setValue:@"YES" forKey:kguestLoginTutorial];
           [tutorialDictionary setValue:@"YES" forKey:khomeTutorial];
           [tutorialDictionary setValue:@"YES" forKey:kscheduleTutorial];
           [tutorialDictionary setValue:@"YES" forKey:kMyOrderTutorial];
           [tutorialDictionary setValue:@"YES" forKey:kkramTutorial];
           
           [kUserDefault setValue:tutorialDictionary forKey:kTutorial];
       
       }];
   }
   }

-(void)menuButtonButton_clicked:(UIButton*)sender{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - Button Clicked
- (void)changePasswordButton{
  
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[loginDictionary valueForKey:@"Email"] forKey:@"Email"];
        ForgotPasswordRequest *forgate = [[ForgotPasswordRequest alloc] initWithDict:dict];
        forgate.requestDelegate=self;
        [forgate startAsynchronous];
        [Utility ShowMBHUDLoader];
    
}

-(void)switchButton_clicked:(UISwitch *)sender{

    if (sender.tag ==4) {
        NSString *status = @"";
        if (switchButton.on) {
            status = @"on";
        }
        else{
            status = @"off";
        }
        
        [self notificationStatus:status];
    }
  /*  else if (sender.tag == 5){
    
         NSMutableDictionary *tutorialDictionary = [[NSMutableDictionary alloc]init];
        
        if (switchButton.on) {
            
            [tutorialDictionary setValue:@"YES" forKey:kguestLoginTutorial];
            [tutorialDictionary setValue:@"YES" forKey:khomeTutorial];
            [tutorialDictionary setValue:@"YES" forKey:kscheduleTutorial];
            [tutorialDictionary setValue:@"YES" forKey:kMyOrderTutorial];
            [tutorialDictionary setValue:@"YES" forKey:kkramTutorial];
   
        }
        else{
            
            [tutorialDictionary setValue:@"NO" forKey:kguestLoginTutorial];
            [tutorialDictionary setValue:@"NO" forKey:khomeTutorial];
            [tutorialDictionary setValue:@"NO" forKey:kscheduleTutorial];
            [tutorialDictionary setValue:@"NO" forKey:kMyOrderTutorial];
            [tutorialDictionary setValue:@"NO" forKey:kkramTutorial];
        }
        
        [kUserDefault setValue:tutorialDictionary forKey:kTutorial];

    }*/
   

}

-(void)ForgotPasswordRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    NSMutableDictionary *payLoadDic =[inData objectForKey:@"Payload"];
    [[NSUserDefaults standardUserDefaults] setObject:[payLoadDic objectForKey:@"MobileNo"] forKey:@"MobileNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:[payLoadDic objectForKey:@"MembershipID"] forKey:@"MembershipID"];
    [[NSUserDefaults standardUserDefaults] setObject:[payLoadDic objectForKey:@"OTP"] forKey:@"ActivationCode"];
    
    
    [loginDictionary setValue:[payLoadDic objectForKey:@"MobileNo"] forKey:@"MobileNumber"];
    [loginDictionary setValue:[payLoadDic objectForKey:@"MembershipID"] forKey:@"MemberShipId"];
    [loginDictionary setValue:[payLoadDic objectForKey:@"OTP"] forKey:@"ActivationCode"];
    
    [kUserDefault setValue:[Utility archiveData:loginDictionary] forKey:kLoginInfo];
    
    [self performSegueWithIdentifier:kverifyOTPSegueIdentifier sender:kForgotPassword];
 
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:kwebviewSegueIdentifier]) {
        BGWebViewController *_wevView = segue.destinationViewController;
        if ([sender isEqualToString:kContactUs]) {
            _wevView.webviewMode = BGContactUs;
        }
        else{
            _wevView.webviewMode = BGAboutUs;
        }
    }
    else if ([segue.identifier isEqualToString:ksetPasswordSegueIdentifier]){
        
        BGSetPasswordViewController *setPassword = segue.destinationViewController;
        setPassword.incomingType = sender;
    }
}

#pragma mark - API call

/****************************
 * Function Name : - notificationStatus
 * Create on : - 16 Feb 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used for check notification on/off status
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)notificationStatus:(NSString *)status{
    
    
    /*if ([userType isEqualToString:kSkinpAndTry]) {
        
        [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"Guest User" message:@"Hey, buddy it seems you are guest user, please login to proceed." block:^(int index){
            
            if (index == 0) {
                
                [self signOutFuntionality];
                
            }
            
        }];
        return;
    }*/
    

   
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[loginDictionary valueForKey:@"RefMembershipID"] forKey:@"RefmembershipId"];
    [dictionary setValue:status forKey:@"Notification"];
    [dictionary setValue:@"ios" forKey:@"DeviceType"];

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"generics.svc/NotificationOnOff"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:@"Status"] boolValue] == true) {
                    
                    if ([status isEqualToString:@"on"]) {
                        switchButton.on  = true;
                    }
                    else {
                        switchButton.on  = false;
                    }
                    [kUserDefault setObject:status forKey:kNotifications];
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
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            
        }
        
        
    }];
    
}

@end

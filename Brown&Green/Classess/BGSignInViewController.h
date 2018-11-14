//
//  BGSignInViewController.h
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "BGRevealMenuViewController.h"
#import "BGHomeViewController.h"
#import "ForgotPasswordRequest.h"
#import "BGOTPViewController.h"
#import "GetCustomerRequest.h"
#import "CheckUserExistanceRequest.h"
#import "TestingVC.h"
#import "SSTutorialViewController.h"

@interface BGSignInViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SWRevealViewControllerDelegate,GIDSignInUIDelegate,GIDSignInDelegate,ForgotPasswordRequestDelegate,GetCustomerRequestDelegate,CheckUserExistanceRequestDelegate>{
    
    UIButton *_forgotPasswordButton;

    __weak IBOutlet UITableView *_signInTable;
    __weak IBOutlet UIWebView *_webView;
    
    UITextField *_emailText;
    UITextField *_passwordText;
    __weak IBOutlet UIButton *rememberMeButton;
    
    NSString *_loginType;
    NSTimer *_timer;
    
    NSMutableDictionary *_infoDictionary;
    UIButton *_hintButton;
    BOOL showPassword;


    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

- (IBAction)loginButton_clicked:(id)sender;
- (IBAction)googlePluseButton_clicked:(id)sender;
- (IBAction)guestButton_clicked:(id)sender;

- (IBAction)fbLoginButton_Clicked:(id)sender;
- (IBAction)rememberMeButton_clicked:(id)sender;

@end

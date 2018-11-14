//
//  UNKOTPViewController.h
//  Unica
//
//  Created by vineet patidar on 02/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGRevealMenuViewController.h"
#import "BGHomeViewController.h"
#import "GetCustomerRequest.h"

@interface BGOTPViewController : UIViewController<UITextFieldDelegate,SWRevealViewControllerDelegate,GetCustomerRequestDelegate>{
    
    NSTimer *_secondsCountTimer;
    int countResendTimer;
    int _sliderCount;


    __weak IBOutlet UIButton *_resendCodeButton;
    __weak IBOutlet UILabel *_timerLabel;
    __weak IBOutlet UISlider *_timeSlider;
    __weak IBOutlet UITextField *_emailTextField;
    __weak IBOutlet UIView *_whiteView;
    __weak IBOutlet UIScrollView *scrollView;

    __weak IBOutlet UILabel *_OTPLabel;
   
    __weak IBOutlet UILabel *_verifyLabel;
    __weak IBOutlet UIButton *_verifyButton;
    
    NSString *_userID;
  
}
@property (nonatomic) BOOL isAgreeTerms;

@property (nonatomic,retain) NSString *incomingType;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;


- (IBAction)resendCodeButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)verifyButton_clicked:(id)sender;


@end

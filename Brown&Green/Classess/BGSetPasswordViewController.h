//
//  BGSetPasswordViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 25/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInCell.h"
#import "ChangePasswordRequest.h"

@interface BGSetPasswordViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ChangePasswordRequestDelegate>{

    UIButton *_hintButton;
    UIButton *_hintButtonConfirmPassword;
    UIButton *_hintButtonOldPassword;


    UITextField *_confirmPassword;
    UITextField *_passwordText;
    UITextField *_oldPassword;

    
    BOOL showPassword;
    BOOL oldPassword;
    BOOL showConfirmPassword;

 
    __weak IBOutlet UITableView *_setPasswordTable;
}
@property (nonatomic,retain) NSString *incomingType;
- (IBAction)backButton_clicked:(id)sender;

- (IBAction)submitButton_clicked:(id)sender;

@end

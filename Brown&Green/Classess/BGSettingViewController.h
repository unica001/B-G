//
//  BGSettingViewController.h
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotPasswordRequest.h"
#import "BGSetPasswordViewController.h"

@interface BGSettingViewController :UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate,ForgotPasswordRequestDelegate>{
    NSMutableArray *applicationStatusArray;
    
    __weak IBOutlet UITableView *_settingTable;
    __weak IBOutlet UIBarButtonItem *_menuButton;
    
    UISwitch *switchButton;
    NSMutableArray *settingArray;
}
- (IBAction)menuButtonButton_clicked:(id)sender;

@property (nonatomic,retain) NSString *incommingViewType;

@end

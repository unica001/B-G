//
//  BGNotificationViewController.h
//  TRLUser
//
//  Created by vineet patidar on 16/02/17.
//  Copyright © 2017 Jitender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetNotification.h"
@interface BGNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate,GetNotificationDelegate>{
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIBarButtonItem *_menuButton;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
    __weak IBOutlet UIButton *_clearAllButton;
    __weak IBOutlet UIView *_notificationView;
    
    NSString *lastSyncDate;
}
@property(strong,nonatomic)NSMutableArray *notificationArray;

- (IBAction)clearAllButton_clicked:(id)sender;


@end

//
//  VC1.h
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCartViewController.h"
#import "CancelOrder.h"
#import "CollectOrder.h"

@interface VC1 : UIViewController<UITableViewDataSource,UITableViewDelegate,CancelOrderRequestDelegate,CollectOrderRequestDelegate>{


    __weak IBOutlet UIButton *_cancelButton;
    __weak IBOutlet UIButton *_editButton;
    
    NSInteger selectedConfirmOrderIndex;
    IOFDB *iofDB;

}
@property (strong, nonatomic) IBOutlet UITableView *tbl_VC1;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_tbl_Height;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TransactionDetails;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimeStamp;

@property (weak, nonatomic) IBOutlet UIView *popup_view;

- (IBAction)btn_Edit_Clicked:(UIButton *)sender;
- (IBAction)btn_Cancel_clicked:(UIButton *)sender;

@end

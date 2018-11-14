//
//  UpComingOrderCell.h
//  Video
//
//  Created by Anand on 06/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpComingOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *Edit_View;
@property (strong, nonatomic) IBOutlet UIButton *btn_dropDown;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Date;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TimeSlot_Id;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ProductList;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Amount;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLable;
@property (strong, nonatomic) IBOutlet UIButton *btn_EditOrCancel;
@property (weak, nonatomic) IBOutlet UILabel *abandonedLabel;
@property (strong, nonatomic) IBOutlet UIButton *rowButton;



@end

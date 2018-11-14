//
//  MyDonaitonCell.h
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDonaitonCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbl_OrderID;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Date;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Location;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Time;

@property (strong, nonatomic) IBOutlet UILabel *lbl_ProductList;
@property (strong, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productLableHeight;

@end

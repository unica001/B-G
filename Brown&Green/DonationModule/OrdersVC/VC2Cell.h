//
//  VC2Cell.h
//  Video
//
//  Created by VMK IT Services on 5/5/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Time;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Amount;
@property (weak, nonatomic) IBOutlet UIButton *btn_Invoice;

@property (weak, nonatomic) IBOutlet UIButton *btn_Reorder;


@end

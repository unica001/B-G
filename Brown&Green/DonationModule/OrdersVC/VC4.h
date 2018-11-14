//
//  VC4.h
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC4 : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tbl_VC4;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Account_Descrp;

@property (weak, nonatomic) IBOutlet UILabel *lbl_LastUpdate;

@end

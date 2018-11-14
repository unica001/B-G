//
//  VC3.h
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetInvoiceDetails.h"

@interface VC3 : UIViewController<UITableViewDelegate,UITableViewDataSource,GetInvoiceDetailsRequestDelegate>{
    IOFDB *iofDB;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_CancellOrder;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Cancel_Descrp;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Cancel_LastUpdate;




@end

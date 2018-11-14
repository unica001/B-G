//
//  VC2.h
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetInvoiceDetails.h"

@interface VC2 : UIViewController<UITableViewDataSource,UITableViewDelegate,GetInvoiceDetailsRequestDelegate>{
    IOFDB *iofDB;

}

@property (weak, nonatomic) IBOutlet UITableView *tbl_DeliveryOrder;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Delivery_Descrp;
@property (weak, nonatomic) IBOutlet UILabel *lbl_LastUpdate_details;


@end

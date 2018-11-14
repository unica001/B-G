//
//  MyKarmaPointsCell.h
//  Brown&Green
//
//  Created by Anand on 16/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyKarmaPointsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_OrderID;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Date;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Time;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Location;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Product;
@property (strong, nonatomic) IBOutlet UILabel *lbl_EarnedPoints;

@end

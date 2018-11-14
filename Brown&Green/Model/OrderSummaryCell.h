//
//  OrderSummaryCell.h
//  Brown&Green
//
//  Created by vineet patidar on 30/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface OrderSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderValuesLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBalanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *promoCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *appluButton;
@property (weak, nonatomic) IBOutlet UILabel *payAbleAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewAndAddButton;
@property (weak, nonatomic) IBOutlet UILabel *deleveriCharhes;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageViewheight;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
-(void)setOrderSummaryData:(NSMutableDictionary *)dictionary;


@end

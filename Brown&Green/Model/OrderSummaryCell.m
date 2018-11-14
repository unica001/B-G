//
//  OrderSummaryCell.m
//  Brown&Green
//
//  Created by vineet patidar on 30/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "OrderSummaryCell.h"

@implementation OrderSummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderSummaryData:(NSMutableDictionary *)dictionary{
    
    self.orderValuesLabel.text = [NSString stringWithFormat:@"%@ AUD",[dictionary valueForKey:@"OrderAmount"]];
     self.currentBalanceLabel.text = [NSString stringWithFormat:@"%@ AUD",[dictionary valueForKey:@"CashBalance"]];
    self.payAbleAmountLabel.text = [NSString stringWithFormat:@"%0.1f AUD",[[dictionary valueForKey:@"CollectableAmount"] floatValue]];
    self.deleveriCharhes.text = [NSString stringWithFormat:@"%0.1f AUD",[[dictionary valueForKey:@"DeliveryCharges"] floatValue]];
}



@end

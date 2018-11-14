//
//  PaymentTypeCell.m
//  Brown&Green
//
//  Created by vineet patidar on 02/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "PaymentTypeCell.h"

@implementation PaymentTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    saveCart = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)saveCardButton_clicked:(id)sender {
    if (saveCart== YES) {
        [self.saveCardButton setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        saveCart = NO;
    }
    else{
            [self.saveCardButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        saveCart = YES;
    }
}
@end

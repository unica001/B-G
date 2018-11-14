//
//  VC3Cell.m
//  Video
//
//  Created by VMK IT Services on 5/5/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "VC3Cell.h"

@implementation VC3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.btn_ReOrder setTitle:@"View/Re-Order" forState:UIControlStateNormal];
    self.btn_ReOrder.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.btn_ReOrder.titleLabel.numberOfLines = 2;
    self.btn_ReOrder.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

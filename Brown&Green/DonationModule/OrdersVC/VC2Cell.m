//
//  VC2Cell.m
//  Video
//
//  Created by VMK IT Services on 5/5/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "VC2Cell.h"

@implementation VC2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.btn_Reorder setTitle:@"View/Re-Order" forState:UIControlStateNormal];
    self.btn_Reorder.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.btn_Reorder.titleLabel.numberOfLines = 2;
    self.btn_Reorder.titleLabel.textAlignment = NSTextAlignmentCenter;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

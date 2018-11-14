//
//  OfferCell.h
//  Brown&Green
//
//  Created by vineet patidar on 27/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *offerTitle;

@property (weak, nonatomic) IBOutlet UILabel *promocodeLabel;
-(void)setData:(NSMutableDictionary *)dictionary type:(NSString *)type;
@end

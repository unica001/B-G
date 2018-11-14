//
//  OfferCell.m
//  Brown&Green
//
//  Created by vineet patidar on 27/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "OfferCell.h"

@implementation OfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSMutableDictionary *)dictionary type:(NSString *)type{
    
//    if ([type isEqualToString:@"home"]) {
//        
//        self.getCodeWidth.constant = 0;
//        self.offerImageWidth.constant = 0;
//    }
    
    NSString *title = [dictionary valueForKey:@"PromoTitle"];
    self.titleLabelHeight.constant =[Utility getTextHeight:title size:CGSizeMake(kiPhoneWidth - 80, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
    self.titleLabel.text = title;
    
    NSString *subTitle = [dictionary valueForKey:@"PromoDetails"];
      self.subTitleLabelHeight.constant =[Utility getTextHeight:subTitle size:CGSizeMake(kiPhoneWidth - 80, CGFLOAT_MAX) font:kDefaultFontForTextField];
    self.subTitleLabel.text = subTitle;
    
    self.promocodeLabel.text = [dictionary valueForKey:@"PromoCode"];
    
    
    
    // set profile image
    
    NSString *imageName =[dictionary valueForKey:@"PromoImage"];
   /* NSString *finalImageUrl = [NSString stringWithFormat:@"http://staging.sirez.com/BrownAndGreens/Admin/avatars/Promotions/%@",imageName];*/
     NSString *finalImageUrl = [NSString stringWithFormat:@"%@%@",kOFFERBASEURL,imageName];
    
    [self.offerImage sd_setImageWithURL:[NSURL URLWithString:finalImageUrl] placeholderImage:[UIImage imageNamed:@"loginPopUp"] options:SDWebImageRefreshCached];
    
    
//    [self.offerImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
    
    self.offerTitle.text = [dictionary valueForKey:@"PromoTitle"];
    self.offerTitle.font = [UIFont systemFontOfSize:12];
}

@end

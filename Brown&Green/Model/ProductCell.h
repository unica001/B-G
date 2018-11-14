//
//  ProductCell.h
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UILabel *numberOfProductLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *textFieldHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (nonatomic,retain) NSMutableDictionary *selectedProductDictionary;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;
@property (weak, nonatomic) NSLayoutConstraint *goToCartButtonHeight;
@property (weak, nonatomic)  UILabel *badgeLabel;
@property (nonatomic,retain) UIBarButtonItem *bucketButton;
@property (nonatomic,retain) UILabel *budgesLabel;


// cell contain
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productWeight;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *prodctImageButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIImageView *ProductImage;
- (IBAction)plusButton_clicked:(id)sender;
- (IBAction)minusButon_clicked:(id)sender;


-(void)setData:(NSMutableDictionary *)dicationary index:(NSInteger)index;
@property(nonatomic,retain)UITableView *productTable;
@end

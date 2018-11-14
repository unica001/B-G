//
//  MyCartCell.h
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCartCell : UITableViewCell
// cell contain
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productWeight;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
//@property (nonatomic,retain) UILabel *toalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UILabel *actualPrice;
@property (weak, nonatomic) IBOutlet UILabel *specialInstructionLabel;

@property (nonatomic,retain) NSMutableDictionary *removeDictionary;
-(void)setData:(NSMutableDictionary *)dicationary index:(NSInteger)index myCartArray:(NSMutableArray *)array;
@property (nonatomic,retain) UITableView *myCartTable;

@property (weak, nonatomic) IBOutlet UILabel *numberOfProductLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)NSMutableArray *myCartArray;
@property (nonatomic) float totalItemCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic,retain) MyCartViewController *viewController;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (IBAction)plusButton_clicked:(id)sender;
- (IBAction)minusButon_clicked:(id)sender;

@end

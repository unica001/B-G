//
//  TestCell.h
//  Video
//
//  Created by Venkat on 30/04/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriant_KG3_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constarint_KG3_View_Width;

@property (strong, nonatomic) IBOutlet UIView *view_FoodDetails;
@property (strong, nonatomic) IBOutlet UIImageView *product_Img;

@property (strong, nonatomic) IBOutlet UITextField *txt_FoodWeight;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Product_Name;

@property (strong, nonatomic) IBOutlet UIButton *btn_Food_Name;
@property (weak, nonatomic) IBOutlet UIButton *btn_KG;
@property (weak, nonatomic) IBOutlet UIButton *btn_GM;
@property (weak, nonatomic) IBOutlet UIButton *btn_MG;

@property (weak, nonatomic) IBOutlet UILabel *lbl_KG3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_KG2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_KG1;

@property (strong, nonatomic) IBOutlet UIButton *btn_KG_Main;
@property (strong, nonatomic) IBOutlet UIButton *btn_GM_Main;
@property (strong, nonatomic) IBOutlet UIButton *btn_MG_Main;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_TotalWeight_Width;

@property (strong, nonatomic) IBOutlet UIView *KG2_View;


@end

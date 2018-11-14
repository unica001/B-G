//
//  MyCartCell.m
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "MyCartCell.h"
#import "MyCartViewController.h"
@implementation MyCartCell{
    AppDelegate *appDelegate;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setData:(NSMutableDictionary *)dicationary index:(NSInteger)index myCartArray:(NSMutableArray *)array {
    
    
    // set border color
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(2.5f, 2.5f);
    self.bgView.layer.shadowRadius = 1.0f;
    self.bgView.layer.shadowOpacity = 0.5f;
    self.bgView.layer.cornerRadius = 5.0;
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

   self.removeDictionary  = dicationary;
    NSString *imageName = [dicationary valueForKey:@"ImgName"];
    
    
    NSString *finalImageUrl;
    if ([kAPIBaseURL isEqualToString:@"http://staging.sirez.com/IOF/IOFFeederREST/"])
    {
        finalImageUrl = [NSString stringWithFormat:@"%@%@",kBImageUrlProducts,imageName];
        
    }
    else
        finalImageUrl = [NSString stringWithFormat:@"%@%@",kImageUrl,imageName];
    
    
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:finalImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
    
    self.productName.text =[dicationary valueForKey:@"ProductName"];
    self.brandNameLabel.text = [Utility replaceNULL:[dicationary valueForKey:@"BrandName"] value:@""];
    
    NSString *price = [NSString stringWithFormat:@"%@ AUD",[dicationary valueForKey:@"SalePrice"]];
    
    NSString *unitName =[dicationary valueForKey:@"unitName"];
    NSString *unit =[dicationary valueForKey:@"Units"];
    NSString *weight = [NSString stringWithFormat:@"%@ %@",unit,unitName];
    
   // self.productWeight.text = [NSString stringWithFormat:@"%@ /%@",price,weight];
    self.productWeight.text = [NSString stringWithFormat:@"%@",price];

   
    NSString *actualPrice = [NSString stringWithFormat:@"AUD %@/%@",[dicationary valueForKey:@"SalePrice"],weight];
    
    
    if ([[self.removeDictionary valueForKey:@"SalePrice"] floatValue]>[[self.removeDictionary valueForKey:@"MarketPrice"] floatValue]) {
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",actualPrice]];
        
        [titleString addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [titleString length])];
        self.actualPrice.attributedText = titleString;
    }
    
    if ([[self.removeDictionary valueForKey:@"MarketPrice"] floatValue]>[[self.removeDictionary valueForKey:@"SalePrice"] floatValue]) {
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",actualPrice]];
        
    [titleString addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [titleString length])];
        self.actualPrice.attributedText = titleString;
    }
    else{
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@""]];
        self.actualPrice.attributedText = titleString;
    }
    
    if ([[dicationary valueForKey:kproductCount] integerValue]>0) {
//        self.productPrice.text = [NSString stringWithFormat:@"%0.1f %@",[[dicationary valueForKey:kproductCount] integerValue]*[weight floatValue],unitName];
        
        float calculateWeight =  [weight floatValue];
        
       // self.productPrice.text = [NSString stringWithFormat:@"%ld Pack / %0.2f %@",[[dicationary valueForKey:kproductCount] integerValue],calculateWeight,unitName];
         self.productPrice.text = [NSString stringWithFormat:@"%0.2f %@",calculateWeight,unitName];
    }
    else{
    self.productPrice.text = [NSString stringWithFormat:@"0 %@",unitName];
    }
    
    // iteam count
    self.numberOfProductLabel.text = [NSString stringWithFormat:@"%@",[dicationary valueForKey:@"productCount"]];
    
   
    if (appDelegate.checkProductArray.count>0) {
        // set special text
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ProductID = %@",[NSString stringWithFormat:@"%@",[dicationary valueForKey:@"ProductID"]]];
        
        NSArray *filterArray = [appDelegate.checkProductArray filteredArrayUsingPredicate:predicate];
        NSLog(@"%@",filterArray);
        
        NSMutableDictionary *dict = [filterArray objectAtIndex:0];
        
        if ([Utility replaceNULL:[dict valueForKey:kRequestTextField] value:@""].length>0) {
            _specialInstructionLabel.hidden = NO;
            self.textView.text = [Utility replaceNULL:[dict valueForKey:kRequestTextField] value:@""];
            _textViewHeight.constant = 40;
        }
        else{
            _specialInstructionLabel.hidden = YES;
            _textViewHeight.constant = 0;
        }
    }
}

- (IBAction)plusButton_clicked:(id)sender {
    
    if ([self.numberOfProductLabel.text integerValue] < [[self.removeDictionary valueForKey:@"MaxLimit"] integerValue]) {
        self.numberOfProductLabel.text = [NSString stringWithFormat:@"%ld",[self.numberOfProductLabel.text integerValue]+1];
        NSString *price = [self.removeDictionary valueForKey:@"price"];
        
        if ([self.numberOfProductLabel.text integerValue]>0) {
            
            [self.removeDictionary setObject:[NSString stringWithFormat:@"%ld",[price integerValue]*[self.numberOfProductLabel.text integerValue]] forKey:kAddItemPrice];
        }
        
        [self.removeDictionary setObject:self.numberOfProductLabel.text forKey:kproductCount];
        [self.myCartTable reloadData];
    }
    else{
        // self.textField.text = @"";
        [Utility showAlertViewControllerIn:self.window.rootViewController title:@"" message:@"This is the maximun quantity of this products" block:^(int index){
        }];
        
        return;
    }
    
    
    if ([appDelegate.totalPrice floatValue]>0) {
        NSString *strPrice = [self.removeDictionary valueForKey:@"SalePrice"];
        appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",([strPrice floatValue]+[appDelegate.totalPrice floatValue])];
    }
    else{
        appDelegate.totalPrice = [self.removeDictionary valueForKey:@"SalePrice"];
    }
    
    if ([self.numberOfProductLabel.text integerValue] ==1) {
        
        if (![appDelegate.checkProductArray containsObject:self.removeDictionary]) {
            [appDelegate.checkProductArray addObject:self.removeDictionary];
           
        }
    }
    [self.viewController getMyCartData];

}

- (IBAction)minusButon_clicked:(id)sender {
    
    if ([self.numberOfProductLabel.text integerValue]>0) {
        NSString *price = [self.removeDictionary valueForKey:@"price"];
        NSString *totalPrice = [self.removeDictionary valueForKey:kAddItemPrice];
        
        if ([totalPrice integerValue]>= [price integerValue]) {
            
            [self.removeDictionary setObject:[NSString stringWithFormat:@"%ld",[totalPrice integerValue]-[price integerValue]] forKey:kAddItemPrice];
        }
        
        self.numberOfProductLabel.text = [NSString stringWithFormat:@"%ld",[self.numberOfProductLabel.text integerValue]-1];
        [self.removeDictionary setObject:self.numberOfProductLabel.text forKey:kproductCount];
    }
  
    
    NSString *strPrice = [self.removeDictionary valueForKey:@"SalePrice"];
    appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",[appDelegate.totalPrice floatValue]-[strPrice floatValue]];
    
   
    
    if ([self.numberOfProductLabel.text integerValue]==0) {
        if ([appDelegate.checkProductArray containsObject:self.removeDictionary]) {
            
            if (appDelegate.totalItemCount>0) {
                appDelegate.totalItemCount = appDelegate.totalItemCount - 1;
            }
            [appDelegate.checkProductArray removeObject:self.removeDictionary];
            [self.myCartArray removeObject:self.removeDictionary];
            
          
        }
    }
    [self.viewController getMyCartData];

}

@end

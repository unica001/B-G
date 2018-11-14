//
//  ProductCell.m
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell
{
    NSMutableDictionary *selectedDicationary;
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

- (IBAction)plusButton_clicked:(id)sender {
    
    if ([self.numberOfProductLabel.text integerValue] < [[self.selectedProductDictionary valueForKey:@"MaxLimit"] integerValue]) {
        self.numberOfProductLabel.text = [NSString stringWithFormat:@"%ld",[self.numberOfProductLabel.text integerValue]+1];
        NSString *price = [self.selectedProductDictionary valueForKey:@"price"];
        
        if ([self.numberOfProductLabel.text integerValue]>0) {
            
            [self.selectedProductDictionary setObject:[NSString stringWithFormat:@"%ld",[price integerValue]*[self.numberOfProductLabel.text integerValue]] forKey:kAddItemPrice];
        }
        
        [self.selectedProductDictionary setObject:self.numberOfProductLabel.text forKey:kproductCount];
        [self.productTable reloadData];
        
        if ([appDelegate.totalPrice floatValue]>0) {
            NSString *strPrice = [selectedDicationary valueForKey:@"SalePrice"];
            
            appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",([strPrice floatValue]+[appDelegate.totalPrice floatValue])];
        }
        else{
            appDelegate.totalPrice = [selectedDicationary valueForKey:@"SalePrice"];
        }
        
        if ([self.numberOfProductLabel.text integerValue] ==1) {
            
            if (![appDelegate.checkProductArray containsObject:selectedDicationary]) {
                [appDelegate.checkProductArray addObject:selectedDicationary];
                
            }
        }
        
        if (appDelegate.checkProductArray.count==0) {
            _goToCartButtonHeight.constant = 0;
            self.badgeLabel.hidden = YES;
            
        }
        else{
            _goToCartButtonHeight.constant = 40;
            self.badgeLabel.hidden = NO;
            
        }
        UIBarButtonItem *item = _bucketButton;
        UIView *view = [item valueForKey:@"view"];
        [self startShake:view];
        [self startShake:self.budgesLabel];

    }
    else{
       // self.textField.text = @"";
        [Utility showAlertViewControllerIn:self.window.rootViewController title:@"" message:@"This is the maximun quantity of this products" block:^(int index){
        }];
    }
    
    
    
  
}

- (IBAction)minusButon_clicked:(id)sender {
    
    if ([self.numberOfProductLabel.text integerValue]>0) {
        NSString *price = [self.selectedProductDictionary valueForKey:@"price"];
        NSString *totalPrice = [self.selectedProductDictionary valueForKey:kAddItemPrice];
        
        if ([totalPrice integerValue]>= [price integerValue]) {
            
            [self.selectedProductDictionary setObject:[NSString stringWithFormat:@"%ld",[totalPrice integerValue]-[price integerValue]] forKey:kAddItemPrice];
        }
        
        self.numberOfProductLabel.text = [NSString stringWithFormat:@"%ld",[self.numberOfProductLabel.text integerValue]-1];
        [self.selectedProductDictionary setObject:self.numberOfProductLabel.text forKey:kproductCount];
    }
    
    
    NSString *strPrice = [selectedDicationary valueForKey:@"SalePrice"];
    appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",[appDelegate.totalPrice floatValue]-[strPrice floatValue]];

    
    if ([self.numberOfProductLabel.text integerValue]==0) {
        if ([appDelegate.checkProductArray containsObject:selectedDicationary]) {
            [appDelegate.checkProductArray removeObject:selectedDicationary];
           
        }
    }
    
    if ([appDelegate.checkProductArray count] == 0) {
        _goToCartButtonHeight.constant = 0;
        self.badgeLabel.hidden = YES;
    }
    else{
        _goToCartButtonHeight.constant = 40;
        self.badgeLabel.hidden = NO;
        
        UIBarButtonItem *item = _bucketButton;
        UIView *view = [item valueForKey:@"view"];
        [self startShake:view];
        [self startShake:self.budgesLabel];
    }
    
     self.badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.checkProductArray count]];
    
    
    [self.productTable reloadData];
}


-(void)setData:(NSMutableDictionary *)dicationary index:(NSInteger)index{

    
    selectedDicationary = dicationary;
     appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    self.selectedProductDictionary = dicationary;
    
    if (![[ self.selectedProductDictionary valueForKey:kproductCount] isKindOfClass:[NSNull class]] && [[ self.selectedProductDictionary valueForKey:kproductCount] integerValue]>0) {
        self.numberOfProductLabel.text = [NSString stringWithFormat:@"%@",[ self.selectedProductDictionary valueForKey:kproductCount]];;
        
        self.bottomViewHeight.constant = 60;
        self.textFieldHeaderLabel.hidden = NO;
        self.textField.hidden = NO;
    }
    else{
        self.bottomViewHeight.constant = 0;
        
        self.textFieldHeaderLabel.hidden = YES;
        self.textField.hidden = YES;
    }
     self.badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.checkProductArray count]];
    
    NSString *imageName = [self.selectedProductDictionary valueForKey:@"ImgName"];
    
    
    NSString *finalImageUrl;
    if ([kAPIBaseURL isEqualToString:@"http://staging.sirez.com/IOF/IOFFeederREST/"])
    {
        finalImageUrl = [NSString stringWithFormat:@"%@%@",kBImageUrlProducts,imageName];
        
    }
    else
    {
        
    }
        finalImageUrl = [NSString stringWithFormat:@"%@%@",kImageUrl,imageName];
    
    
    [self.ProductImage sd_setImageWithURL:[NSURL URLWithString:finalImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached];
    
    self.productName.text =[self.selectedProductDictionary valueForKey:@"ProductName"];
    
    self.brandNameLabel.text = [Utility replaceNULL:[self.selectedProductDictionary valueForKey:@"BrandName"] value:@""];
    
    NSString *price = [NSString stringWithFormat:@"%@ AUD",[self.selectedProductDictionary valueForKey:@"SalePrice"]];
    
     NSString *actualPrice = [NSString stringWithFormat:@"%@ AUD",[self.selectedProductDictionary valueForKey:@"MarketPrice"]];
    
    NSString *unitName =[self.selectedProductDictionary valueForKey:@"unitName"];
    NSString *unit =[self.selectedProductDictionary valueForKey:@"Units"];
    NSString *weight = [NSString stringWithFormat:@"%@ %@",unit,unitName];
    
    self.productPrice.text = [NSString stringWithFormat:@"%@",price];
   
    if ([[self.selectedProductDictionary valueForKey:@"MarketPrice"] floatValue]>[[self.selectedProductDictionary valueForKey:@"SalePrice"] floatValue]) {
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",actualPrice]];
        
        [titleString addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [titleString length])];
        self.actualPriceLabel.attributedText = titleString;
    }
    else{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@""]];
        self.actualPriceLabel.attributedText = titleString;

    }
    
   /* if ([[self.selectedProductDictionary valueForKey:kproductCount] integerValue]>0) {
        
//        float calculateWeight = [[self.selectedProductDictionary valueForKey:kproductCount] integerValue]* [weight floatValue];
//        
//      self.productWeight.text = [NSString stringWithFormat:@"%0.2f %@",calculateWeight,unitName];
        
          float calculateWeight =  [weight floatValue];
        
       // self.productWeight.text = [NSString stringWithFormat:@"%ld Pack / %0.2f %@",[[self.selectedProductDictionary valueForKey:kproductCount] integerValue],calculateWeight,unitName];
        self.productWeight.text = [NSString stringWithFormat:@" %0.2f %@",calculateWeight,unitName];
        
            }
    else{
        
     self.productWeight.text = weight;
    }*/
    self.productWeight.text = weight;
    
    // text field text
    
    self.textField.text = [self.selectedProductDictionary  valueForKey:kRequestTextField];
    
    if ([self.selectedProductDictionary valueForKey:kRequestTextField]) {
        self.lineView.hidden = NO;
    }
    else{
        self.lineView.hidden = YES;
    }

}

#pragma  shake button

- (void) startShake:(UIView*)view
{
    CGAffineTransform leftShake = CGAffineTransformMakeTranslation(-4, 0);
    CGAffineTransform rightShake = CGAffineTransformMakeTranslation(4, 0);
    view.transform = leftShake;  // starting point
    [UIView beginAnimations:@"shake_button" context:(__bridge void *)(view)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:4];
    [UIView setAnimationDuration:0.04];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shakeEnded:finished:context:)];
    view.transform = rightShake; // end here & auto-reverse
    [UIView commitAnimations];
}
- (void) shakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView *item = (__bridge UIView *)(context);
        item.transform = CGAffineTransformIdentity;
    }
}

@end

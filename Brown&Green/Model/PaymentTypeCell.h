//
//  PaymentTypeCell.h
//  Brown&Green
//
//  Created by vineet patidar on 02/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTypeCell : UITableViewCell{
    BOOL saveCart;
}
@property (weak, nonatomic) IBOutlet UITextField *cartNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvvNumbetTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveCardButton;
- (IBAction)saveCardButton_clicked:(id)sender;

@end

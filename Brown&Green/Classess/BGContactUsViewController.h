//
//  TRLContactUsViewController.h
//  TRLUser
//
//  Created by vineet patidar on 28/01/17.
//  Copyright © 2017 Jitender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGContactUsViewController : UIViewController{
    __weak IBOutlet UILabel *phoneNumber1Label;

    __weak IBOutlet UILabel *phoneNumber2Label;
   
}
- (IBAction)callButton_Clicked:(UIButton *)sender;
- (IBAction)emailButton_Clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;

@end

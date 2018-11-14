//
//  DonateVC.h
//  Video
//
//  Created by VMK IT Services on 5/5/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *lbl_Date;
//@property (strong, nonatomic) IBOutlet UITextField *txt_Location;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIView *popup_View;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Holiday_Details;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Holiday_Descp;

@property (weak, nonatomic) IBOutlet UITableView *tbl_TimeSlot;

- (IBAction)btn_OK_Clicked:(UIButton *)sender;

- (IBAction)btn_DatePicker_Clicked:(UIButton *)sender;
- (IBAction)btn_Back_Clicked:(UIButton *)sender;

- (IBAction)btn_Confirm_Clicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *date_Picker;

@property (weak, nonatomic) IBOutlet UIView *pickerView;
- (IBAction)btn_Done_Clicked:(UIButton *)sender;
- (IBAction)btn_Cancel:(UIButton *)sender;
- (IBAction)pickerValueChanged:(UIDatePicker *)sender;


@end

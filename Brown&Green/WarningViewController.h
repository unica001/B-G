//
//  WarningViewController.h
//  Brown&Green
//
//  Created by Chankit on 6/2/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarningViewController : UIViewController
- (IBAction)ButtonCalenderAction:(id)sender;
- (IBAction)ButtonCancelAction:(id)sender;
- (IBAction)ButtonDoneAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *ViewDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *labelWarning;
@property (strong, nonatomic) IBOutlet UIButton *ButtonCalender;
@property (strong, nonatomic) IBOutlet UILabel *labelcalender;
@property (strong, nonatomic) IBOutlet UIImageView *imageCalender;

@property(strong,nonatomic) NSMutableDictionary *dicCategory;
@property(strong,nonatomic) NSString *fromSearch;
@property(strong,nonatomic) NSString *title;

@end

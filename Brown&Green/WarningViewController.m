//
//  WarningViewController.m
//  Brown&Green
//
//  Created by Chankit on 6/2/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "WarningViewController.h"

@interface WarningViewController ()

@end

@implementation WarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.maximumDate=[NSDate date];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ButtonCalenderAction:(id)sender {
    self.ViewDatePicker.hidden=false;
}

- (IBAction)ButtonCancelAction:(id)sender {
    self.ViewDatePicker.hidden=true;
}

- (IBAction)ButtonDoneAction:(id)sender {
    NSDate *birthDate = self.datePicker.date;
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    int time = [todayDate timeIntervalSinceDate:birthDate];
    int allDays = (((time/60)/60)/24);
    int days = allDays%365;
    int years = (allDays-days)/365;
    NSString *Age=[NSString stringWithFormat:@"%d",years];
    if(years>=18)
    {
         [[NSUserDefaults standardUserDefaults]setValue:Age forKey:KAge];
        
        [self performSegueWithIdentifier:KproductDetail sender:nil];
    }
    else
    {
        self.labelWarning.text=@"You must be over 18 to view these  products. ";
        self.ButtonCalender.userInteractionEnabled=false;
        self.imageCalender.hidden=true;
        self.labelcalender.hidden=true;
        [[NSUserDefaults standardUserDefaults]setValue:Age forKey:KAge];
    }
    self.ViewDatePicker.hidden=true;
}
- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:KproductDetail]) {
        BGProductViewController *productViewController = segue.destinationViewController;
        
        if ([sender isKindOfClass:[NSString class]]) {
            productViewController.fromSearch = self.fromSearch;
        }
        else{
            productViewController.dicCategory = self.dicCategory;
            
        }
        productViewController.title =  self.title;
    }
    
    
}

@end

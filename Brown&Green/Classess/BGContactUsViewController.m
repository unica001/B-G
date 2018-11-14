//
//  BGContactUsViewController.m
//  TRLUser
//
//  Created by vineet patidar on 28/01/17.
//  Copyright © 2017 Jitender. All rights reserved.
//

#import "BGContactUsViewController.h"
#import <MessageUI/MessageUI.h>
@interface BGContactUsViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation BGContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Contact us";
        
   phoneNumber1Label.text = @"9968736373";
   phoneNumber2Label.text = @"9968736300";
    
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



/****************************
 * Function Name : - callButton_Clicked
 * Create on : - 28 jan 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used for make call
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (IBAction)callButton_Clicked:(UIButton *)sender {
    
    if (sender.tag == 101) {
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:@"9968736373"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else  if (sender.tag == 102) {
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:@"9968736373"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    }
    
    
}


/****************************
 * Function Name : - emailButton_Clicked
 * Create on : - 28 jan 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used for send mail
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (IBAction)emailButton_Clicked:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"info@brownandgreenapp.co.uk"]];
        [composeViewController setSubject:@"Contact us"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else{
    
        NSLog(@"Can't send email");
    }
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

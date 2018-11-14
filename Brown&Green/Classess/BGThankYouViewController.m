//
//  BGThankYouViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 02/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGThankYouViewController.h"

@interface BGThankYouViewController ()

@end

@implementation BGThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateLabel.text = [self.summaryDicationary valueForKey:@"slotTime"];
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

- (IBAction)continueButton_clicked:(id)sender {
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication]delegate];
    if ([appdelegate.editMyOrder isEqualToString:kEditMyOrder] || [appdelegate.editMyOrder isEqualToString:kReOrder]) {
        appdelegate.editMyOrder = @"";
        [appdelegate.checkProductArray removeAllObjects];
        BGHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
        [self.navigationController pushViewController:homeViewController animated:YES];
    }
    else{
       // [self.navigationController popToRootViewControllerAnimated:YES];
        [FIRAnalytics logEventWithName:kFIREventSelectContent
                            parameters:@{
                                         // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[subCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                         kFIRParameterItemName:@"ThankYouOrder",
                                         kFIRParameterContentType:@"button"
                                         }];
        [self loginToHomeView];
    }

}


-(void)loginToHomeView{
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BGHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    BGRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    revealController.delegate = self;
    
    self.revealViewController = revealController;
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    self.window.backgroundColor = [UIColor redColor];
    
    self.window.rootViewController =self.revealViewController;
    [self.window makeKeyAndVisible];
}
@end

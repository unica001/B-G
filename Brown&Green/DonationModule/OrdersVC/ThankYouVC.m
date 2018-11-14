//
//  ThankYouVC.m
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "ThankYouVC.h"
#import "SwipeVC.h"
#import "VC5.h"

#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"


@interface ThankYouVC ()

@end

@implementation ThankYouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = true;
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

- (IBAction)btn_Next_Clicked:(UIButton *)sender {
 // VC5 *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"VC5"];
 //   [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)btn_Back_Clicked:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)btn_Continue_Clicked:(UIButton *)sender {
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[subCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                     kFIRParameterItemName:@"ThankYouDonation",
                                     kFIRParameterContentType:@"button"
                                     }];
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

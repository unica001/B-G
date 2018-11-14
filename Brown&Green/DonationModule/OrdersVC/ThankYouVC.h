

//
//  ThankYouVC.h
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouVC : UIViewController<SWRevealViewControllerDelegate>


- (IBAction)btn_Next_Clicked:(UIButton *)sender;
- (IBAction)btn_Back_Clicked:(UIButton *)sender;

- (IBAction)btn_Continue_Clicked:(UIButton *)sender;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

@end

//
//  TestingVC.h
//  Video
//
//  Created by Venkat on 30/04/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"
#import "BGWebViewController.h"

@interface TestingVC : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>{

    __weak IBOutlet UIImageView *_karmaRotetingImage;
    
    BOOL isFoodLegislation;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_Testing;
@property (weak, nonatomic) IBOutlet UIView *popUp_View;

@property (weak, nonatomic) IBOutlet UITextField *txt_KarmaPoints;


@property (nonatomic,retain) NSString *incomingViewType;

- (IBAction)btn_Next_Clicked:(UIButton *)sender;
- (IBAction)btn_OK_CLicked:(UIButton *)sender;

- (IBAction)btn_Back_Clicked:(UIButton *)sender;
- (IBAction)infoButton_clicked:(id)sender;

@end

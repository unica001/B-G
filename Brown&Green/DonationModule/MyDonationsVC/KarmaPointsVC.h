//
//  KarmaPointsVC.h
//  Video
//
//  Created by Anand on 09/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KarmaPointsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tbl_Karma;
- (IBAction)btn_Next_Clicked:(UIButton *)sender;

- (IBAction)btn_Back_Clicked:(UIButton *)sender;

@end

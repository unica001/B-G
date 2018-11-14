//
//  MyKarmaPointsVC.h
//  Brown&Green
//
//  Created by Anand on 16/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestingVC.h"

@interface MyKarmaPointsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property(strong,nonatomic) IBOutlet UITableView *tbl_Karma;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TotalKarmaPoints;


- (IBAction)donateMoreButton_clicked:(id)sender;

@end

//
//  BGRevealMenuViewController.h
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KarmaPointsVC.h"

@interface BGRevealMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UIImageView *userImage;
    __weak IBOutlet UILabel *userNameLabel;
    __weak IBOutlet UILabel *karmaPointLabel;
    __weak IBOutlet UIImageView *karmaPointImage;
    __weak IBOutlet UITableView *menuTable;
    __weak IBOutlet UIView *_guestView;
    

}
- (IBAction)editButton_clicked:(id)sender;

@end

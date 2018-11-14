//
//  NotificationCell.h
//  TRLUser
//
//  Created by vineet patidar on 17/02/17.
//  Copyright © 2017 Jitender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notificationTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationTextHeight;
@property (weak, nonatomic) IBOutlet UILabel *_bullateLabel;

@end

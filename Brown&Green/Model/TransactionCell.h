//
//  TransactionCell.h
//  Brown&Green
//
//  Created by vineet patidar on 27/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
-(void)setData:(NSMutableDictionary *)dictionary;
@end

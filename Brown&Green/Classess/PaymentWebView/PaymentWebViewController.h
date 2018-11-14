//
//  PaymentWebViewController.h
//  Brown&Green
//
//  Created by Chankit on 11/7/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentWebViewController : UIViewController
{
    struct {
        unsigned int viewAppeared: 1;
    } _flags;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableDictionary * summaryDictionary;
@property (nonatomic, strong) NSString * initialCommand;
@end

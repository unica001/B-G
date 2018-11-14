//
//  OfferViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 01/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferCell.h"
#import "offerServer.h"

@protocol promoCodeDelegare <NSObject>

-(void)getPromocode:(NSMutableDictionary *)dictionary;

@end

@interface OfferViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,offerServerDelegate>{

    __weak IBOutlet UITableView *_offerTable;
}
@property (nonatomic,retain) NSMutableArray *offerArr;
@property (nonatomic,retain) id<promoCodeDelegare>delegate;
- (IBAction)backButton_clicked:(id)sender;

@end

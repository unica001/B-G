//
//  BGThankYouViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 02/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGThankYouViewController : UIViewController<SWRevealViewControllerDelegate>
@property (nonatomic,retain)NSMutableDictionary *summaryDicationary;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

- (IBAction)continueButton_clicked:(id)sender;

@end

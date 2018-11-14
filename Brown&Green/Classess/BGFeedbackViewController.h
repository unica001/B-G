//
//  BGFeedbackViewController.h
//  Brown&Green
//
//  Created by vineet patidar on 24/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGFeedbackViewController : UIViewController<SWRevealViewControllerDelegate,UITextViewDelegate>
{
    __weak IBOutlet UITextView *textView;
    __weak IBOutlet UITextField *email;
 
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

- (IBAction)sendButton_clicked:(id)sender;
@end

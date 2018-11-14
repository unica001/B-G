//
//  UNKWebViewController.h
//  TRLUser
//
//  Copyright © 2017 Jitender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGWebViewController : UIViewController<UIWebViewDelegate,SWRevealViewControllerDelegate>{
    
    __weak IBOutlet UIWebView *_webView;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    NSMutableArray *_dataArray;
    
}

@property (nonatomic) NSInteger webviewMode;
@property(nonatomic, strong) id<GAITracker> tracker;

- (IBAction)backButton_clicked:(id)sender;


@end

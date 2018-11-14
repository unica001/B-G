//
//  PaymentWebViewController.m
//  Brown&Green
//
//  Created by Chankit on 11/7/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "PaymentWebViewController.h"
#import "WBUIWebView.h"

#import <WBWebViewConsole/WBWebViewConsole.h>
#import <WBWebViewConsole/WBWebDebugConsoleViewController.h>
#import "WBWebViewConsole.h"
#import "WBWebViewConsoleMessageCell.h"
#import "WBWebViewConsoleInputView.h"
#import "UIScrollView+WBTUtilities.h"
#import "UIView+WBTSizes.h"
#import "WBKeyboardObserver.h"
@interface PaymentWebViewController ()<UIWebViewDelegate,WBWebViewConsoleInputViewDelegate,WBWebViewConsoleMessageCellDelegate>
{
    NSString *transectionId;
    NSString *memID;
}

@property (nonatomic, strong) WBUIWebView * webView;

@property (nonatomic, strong) WBWebViewConsole * console;
//@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) WBWebViewConsoleInputView * inputView;


@end

@implementation PaymentWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView = [[WBUIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.JSBridge.interfaceName = @"UIWebViewBridge";
    self.webView.JSBridge.readyEventName = @"UIWebViewBridgeReady";
    self.webView.JSBridge.invokeScheme = @"uiwebview-bridge://invoke";
    self.webView.wb_delegate = self;
    self.webView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.webView];
    [Utility ShowMBHUDLoader] ;
    NSString *URL = [NSString stringWithFormat:@"%@",KPaymentPageUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    self.console = self.webView.console;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChangeNotification:) name:WBKeyboardObserverFrameDidUpdateNotification object:nil];
    
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clearMessages)];
    
    self.inputView = [[WBWebViewConsoleInputView alloc] initWithFrame:CGRectZero];
    [self.inputView setDelegate:self];
    [self.inputView setFont:[WBWebViewConsoleMessageCell messageFont]];
    [self.inputView setConsole:self.console];
    // [self.view addSubview:self.inputView];
    
    if (self.initialCommand.length)
    {
        [self.inputView setText:self.initialCommand];
        [self.inputView.textView becomeFirstResponder];
    }
    
    [self getTransactionId];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Keyboard Notification

//-(void)webViewDidStartLoad:(UIWebView *)webView {
//    [Utility ShowMBHUDLoader] ;
//}
//
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [Utility hideMBHUDLoader] ;
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
//        // UIWebView object has fully loaded.
//    }
//}
#pragma mark - Console Notifications

- (void)registerNotificationsForCurrentConsole
{
    if (!_console) return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consoleDidAddMessage:) name:WBWebViewConsoleDidAddMessageNotification object:_console];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consoleDidClearMessages:) name:WBWebViewConsoleDidClearMessagesNotification object:_console];
}
- (void)unregisterConsoleNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WBWebViewConsoleDidAddMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WBWebViewConsoleDidClearMessagesNotification object:nil];
}

- (void)consoleDidAddMessage:(NSNotification *)notification
{
    NSArray *list = _console.messages;
    for(int i= 0; i<_console.messages.count; i++)
    {
        WBWebViewConsoleMessage * message = [list objectAtIndex:i];
        
        if(message.level == WBWebViewConsoleMessageLevelLog)
        {
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSMutableString *sessionId = [NSMutableString stringWithFormat:@"%@",message.message];
           NSString *Sid = [[sessionId componentsSeparatedByCharactersInSet:
                                        [[NSCharacterSet characterSetWithCharactersInString
                                          :@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet]] componentsJoinedByString:@""];
            
            [dic setValue:Sid forKey:@"sId"];
            [dic setValue:transectionId forKey:@"transectionId"];
            
           // https://paymentgateway.commbank.com.au/api/rest/version/44/merchant/TESTBROGRECOM201/order/10988/transaction/10988#14#1510033437409
            [self PaymentAPICall:dic];
        }
        else if(message.level == WBWebViewConsoleMessageLevelSuccess)
        {
            // [self clearMessages];
            
        }
        
        else
        {
            [Utility showAlertViewControllerIn:self title:kErrorTitle message:message.message block:^(int index) {
               [self clearMessages];
            }];
            
        }
        
        
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self relayoutViewsAnimated:NO];
        
        _flags.viewAppeared = YES;
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _flags.viewAppeared = NO;
    });
}
- (void)setConsole:(WBWebViewConsole *)console
{
    if (_console != console)
    {
        [self unregisterConsoleNotifications];
        
        _console = console;
        
        [self registerNotificationsForCurrentConsole];
    }
}
- (void)clearMessages
{
    [self.console clearMessages];
}
- (void)consoleDidClearMessages:(NSNotification *)notification
{
    // [self.tableView reloadData];
}
- (void)keyboardFrameDidChangeNotification:(NSNotification *)notification
{
    [self relayoutViewsAnimated:YES];
}
#pragma mark - InputView Delegate

- (void)consoleInputViewHeightChanged:(WBWebViewConsoleInputView *)inputView
{
    [self relayoutViewsAnimated:_flags.viewAppeared];
}
- (void)relayoutViewsAnimated:(BOOL)animated
{
    CGFloat keyboardHeight = [self keyboardHeight];
    CGFloat inputViewHeight = self.inputView.desiredHeight;
    
    if (animated)
    {
        WBKeyboardObserver * keyboard = [WBKeyboardObserver sharedObserver];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:keyboard.animationCurve];
        [UIView setAnimationDuration:keyboard.animationDuration ? : 0.15];
    }
    
    self.inputView.frame = CGRectMake(0, self.view.wbtHeight - inputViewHeight - keyboardHeight, self.view.wbtWidth, inputViewHeight);
    // self.tableView.frame = CGRectMake(0, 0, self.view.wbtWidth, self.view.wbtHeight - inputViewHeight - keyboardHeight);
    
    if (animated)
    {
        [UIView commitAnimations];
    }
}
- (CGFloat)keyboardHeight
{
    CGRect endFrame = [WBKeyboardObserver sharedObserver].frameEnd;
    
    if (CGRectIsNull(endFrame))
    {
        return 0;
    }
    
    return MAX([UIScreen mainScreen].bounds.size.height - endFrame.origin.y, 0);
}


#pragma  mark - APIS



-(void)PaymentAPICall:(NSMutableDictionary*)dic{
    
    // https://paymentgateway.commbank.com.au/api/rest/version/44/merchant/TESTBROGRECOM201/order/10988/transaction/10988#14#1510033437409
    
    long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    NSString *timeStamP = [NSString stringWithFormat:@"%ld",currentTime];
    
    
    
   NSString * payMentAmount = [NSString stringWithFormat:@"%@",[self.summaryDictionary valueForKey:@"CollectableAmount"]];
    
    NSString *URL =[NSString stringWithFormat:@"%@%@/order/%@/transaction/%@#%@#%@",KPaymentLink,KpaymentMerchentURL,transectionId,transectionId,memID,timeStamP];
    
    NSMutableDictionary *order = [[NSMutableDictionary alloc] init];
     [order setValue:[NSString stringWithFormat:@"%@",@"AUD"] forKey:@"currency"];
    [order setValue:[NSString stringWithFormat:@"%@",payMentAmount] forKey:@"amount"];
    
  
    NSMutableDictionary *sourceOfFunds = [[NSMutableDictionary alloc] init];
    [sourceOfFunds setValue:[NSString stringWithFormat:@"%@",@"CARD"] forKey:@"type"];
    
    
    NSMutableDictionary *session = [[NSMutableDictionary alloc] init];
    [session setValue:[NSString stringWithFormat:@"%@",[dic valueForKey:@"sId"]] forKey:@"id"];
    
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setValue:[NSString stringWithFormat:@"%@",@"PAY"] forKey:@"apiOperation"];
    [param setObject:order forKey:@"order"];
    [param setObject:sourceOfFunds forKey:@"sourceOfFunds"];
    [param setObject:session forKey:@"session"];
    
    //https://paymentgateway.commbank.com.au/api/rest/version/44/merchant/TESTBROGRECOM201/order/10988/transaction/10988#14#1510033437409
   [[ConnectionManager sharedInstance] sendPUTRequestForURL:URL params:(NSMutableDictionary *)param timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (![[dictionary valueForKey:@"result"] isEqualToString:@"ERROR"]
                    ) {
                    [self VerifyTransaction];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *message = [NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"error"] valueForKey:@"explanation"]];
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:message block:^(int index) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    });
                }         
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:BGError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
    }];}

-(void)getTransactionId{
    
    
    NSString * OrderId = [NSString stringWithFormat:@"%@",[self.summaryDictionary valueForKey:@"OrderId"]];
    NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
    [dictionary setValue:OrderId forKey:@"OrderId"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,kPaymentUpdateCommBank];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:@"Code"] isEqualToString:@"OK"]
                    ) {
                    transectionId = [[dictionary valueForKey:kAPIPayload] valueForKey:@"TransactionID"];
                    memID = [[dictionary valueForKey:kAPIPayload] valueForKey:@"MembershipID"];
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:BGError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
    }];
    
}

-(void)VerifyTransaction{
    
    
   NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
    [dictionary setValue:transectionId forKey:@"TransactionID"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,KPaymentVerifyCommBank];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:@"Code"] isEqualToString:@"OK"]
                    ) {
                    
                   

                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                      [self performSegueWithIdentifier:kthankyouSegueIdentifier sender:self.summaryDictionary];
                    }];

                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:BGError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
    }];
    
}
- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kthankyouSegueIdentifier]) {
        BGThankYouViewController *thankYouView = segue.destinationViewController;
        thankYouView.summaryDicationary = self.summaryDictionary;
    }
}
@end

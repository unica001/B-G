//
//  BGWebViewController.m
//  TRLUser
//
//  Created by vineet patidar on 04/01/17.
//  Copyright © 2017 Jitender. All rights reserved.
//

#import "BGWebViewController.h"

@interface BGWebViewController ()

@end

@implementation BGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.revealViewController.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    
    //PROGRESS HUD
  
    [Utility ShowMBHUDLoader];
    
    if (self.webviewMode == BGTermAndConditions) { // for Terms & Conditions
        self.title=@"Terms & Conditions";

        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"TermsCondition" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:nil];
        
    }
 
    else  if (self.webviewMode == BGAboutUs) { // for About US
        
        self.title=@"About Us";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:nil];

    }
    else  if (self.webviewMode == BGContactUs) { // for contact US
        
        self.title=@"Contact Us";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"contact" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:nil];
    }
    else  if (self.webviewMode == BGFoodLegislation) { // for contact US
        
        self.title=kFoodLegislation;
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"food-legislation" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:nil];
    }
    
  
    
    // google analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
   
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [Utility hideMBHUDLoader];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma  mark - APIS

-(void)getWebData:(NSString*)type{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,type];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
//                    NSString* htmlString = [payloadDictionary valueForKey:@"content"];
//                    amountString = [payloadDictionary valueForKey:kamount];
                    
                    
                      if (self.webviewMode == BGImportantLink) { // for  important link
                                                    
//                          [self loadDataInWebView:[[NSString stringWithFormat:@"<div style='text-align:center'>%@<div>",htmlString] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"]];

                      }
                      else{
                      
                          //[self loadDataInWebView:htmlString];
                      }
   
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

//-(void)getRegister{
//    
//    
//     NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
//    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
//
//    
//    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
//        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
//    }
//    else{
//        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
//    }
//    [dictionary setValue:amountString forKey:kamount];
//
//    
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"scholarship_registration.php"];
//    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
//        
//        if (!error) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
//                    
//                    [Utility showAlertViewControllerIn:self title:kUNKError message:[dictionary valueForKey:@"Message"] block:^(int index) {
//                        [self.navigationController popViewControllerAnimated:YES];
//                        
//                    }];
//            
//                }else{
//                    
//                    [Utility showAlertViewControllerIn:self title:kUNKError message:[dictionary valueForKey:@"Message"] block:^(int index) {
//                        
//                    }];
//                  
//                }
//                
//            });
//        }
//        else{
//            NSLog(@"%@",error);
//            
//            
//            if([error.domain isEqualToString:kUNKError]){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
//                        
//                    }];
//                });
//            }
//            
//        }
//        
//        
//    }];
//    
//}
-(void)loadDataInWebView:(NSString *)stirng{
 //[_webView loadHTMLString:stirng kAPIkAPIBaseURL:[NSURL URLWithString:@"https://www.britishcouncil.org/"]];

}


@end

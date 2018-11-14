//
//  BGFeedbackViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 24/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGFeedbackViewController.h"

@interface BGFeedbackViewController (){
    NSMutableDictionary *dictLogin ;
    
}

@end

@implementation BGFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dictLogin  = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *emailString = [Utility replaceNULL:[dictLogin valueForKey:kEmail] value:@""];
    
    if (emailString.length>0) {
        email.text = emailString;
    }
    
    textView.layer.cornerRadius = 10;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1.0;
    [textView.layer setMasksToBounds:YES];
    [textView becomeFirstResponder];
    
 
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc]init];
    if (revealViewController)
    {
        UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButton;
    }

}

-(void)revealToggle:(SWRevealViewController*)controller{
    [textView resignFirstResponder];
    [email resignFirstResponder];
}

#pragma mark - Text Field delegate

-(void)textFieldDidChange:(UITextField *)text{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == email) {
        [email resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == email ){
        
        // All digits entered
        if (range.location == 50) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(text.length == 0)
    {
        return YES;
    }
    else if(textView.text.length > 139)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)sendButton_clicked:(id)sender {
    if ([self validatePassword]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        
        [dictionary setValue:email.text forKey:@"Email"];
        [dictionary setValue:textView.text forKey:@"Comment"];
        [dictionary setValue:[Utility replaceNULL:[dictLogin valueForKey:@"RefMembershipID"] value:@""] forKey:@"RefmembershipId"];
        
        [self feedback:dictionary];
    }
}



- (BOOL)validatePassword{
    
    if(![Utility validateField:textView.text]){
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please enter feedback" block:^(int index) {
            
        }];
        return false;
    }
    
    else if(![Utility validateField:textView.text]){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter email" block:^(int index) {
            
        }];
        return false;
    }
    else  if(![Utility validateEmail:email.text] ){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please enter valid email Id" block:^(int index) {
            
        }];
        return false;
    }
    
    
    return true;
}

-(void)feedback:(NSMutableDictionary*)dictionary{
    
    [textView resignFirstResponder];
    [email resignFirstResponder];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"SZCustomers.svc/AppFeedback"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:@"Code"] isEqualToString:@"OK"]
                    ) {
                    
                    [Utility showAlertViewControllerIn:self title:
                     @"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                         textView.text = @"";
                         email.text = @"";
                         
                         UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                         
                         BGHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                         
                         BGRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                         UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                         
                         UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                         
                         SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                         
                         revealController.delegate = self;
                         
                         self.revealViewController = revealController;
                         
                         self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                         self.window.backgroundColor = [UIColor redColor];
                         
                         self.window.rootViewController =self.revealViewController;
                         [self.window makeKeyAndVisible];
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


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [textView resignFirstResponder];
    [email resignFirstResponder];
}
@end

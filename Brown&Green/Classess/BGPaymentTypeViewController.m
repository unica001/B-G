//
//  BGPaymentTypeViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 02/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGPaymentTypeViewController.h"

@interface BGPaymentTypeViewController (){
    
    NSString *payMentAmount;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end

@implementation BGPaymentTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    onlinePayment = 0;
    
    // google analytics
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName
               value:@"Make Payment Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
//    _payPalConfig.merchantName = @"ram.pp_api1.gmail.com";
    _payPalConfig.merchantName = @"manpreet.singh-facilitator_api1.brownandgreens.com.au";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
 
    self.environment = @"sandbox";
    //    self.environment = kPayPalEnvironment;

    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0 && onlinePayment == 1) {
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    // header view
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,kiPhoneWidth,40)];
    tempView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f  blue:235.0f/255.0f  alpha:1];
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,kiPhoneHeight-20,40)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor darkGrayColor];
    [tempView addSubview:tempLabel];
    
    // check mark button
    UIButton *chechMarkButton = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-40, 6, 26, 26)];
    chechMarkButton.backgroundColor = [UIColor clearColor];
    
    chechMarkButton.tag = section;
    [chechMarkButton addTarget:self action:@selector(checkMarkButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:chechMarkButton];

    UIButton *sectionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 40)];
    sectionButton.backgroundColor = [UIColor clearColor];
    
    sectionButton.tag = section;
    [sectionButton addTarget:self action:@selector(sectionButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:sectionButton];
    
    
    if (section == 0 ) {
        tempLabel.text = @"Pay Online";
    }
    else if (section == 1) {
        tempLabel.text = @"Cash On Delivery";
    }
    
    if (onlinePayment == 1 && section == 0) {
        [chechMarkButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    else if (onlinePayment == 2 && section ==1) {
        [chechMarkButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    else{
    [chechMarkButton setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    
    return tempView;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // header view
    
    if ((onlinePayment ==2 ||onlinePayment ==0) && section ==0) {
        UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,kiPhoneWidth,10)];
        tempView.backgroundColor = [UIColor whiteColor];
        return tempView;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0 && (onlinePayment ==2 ||onlinePayment ==0)) {
        return 10;
    }
    return 10.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            
        static NSString *cellIdentifier  =@"cell";
        PaymentTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PaymentTypeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section ==0 && onlinePayment==1) {
        return 0;
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - button clicked

-(void)sectionButton_clicked:(UIButton *)sender{
 
    if (sender.tag==0) {
        onlinePayment = 1;
    }
    else{
        onlinePayment = 2;
    }
    [_paymentType reloadData];
}

-(void)checkMarkButton_clicked:(UIButton *)sender{
    
}


- (IBAction)payNowButton_clicked:(id)sender {
    
    
    if (!(onlinePayment>0)) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please select Payment type" block:^(int index){
        
        }];
        
        return;
    }
    
    if (onlinePayment ==1) {
        [self chainedPayment];
    }
   else if (onlinePayment ==2) {
        
       [self orderConfirm];
    }
}

-(void)orderConfirm{
    NSMutableDictionary *loginDict = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *memID = [NSString stringWithFormat:@"%@",[loginDict valueForKey:@"RefMembershipID"]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:memID forKey:@"membershipId"];
    if ([self.summaryDicationary objectForKey:@"OrderId"]!=nil) {
        [dict setObject:[self.summaryDicationary objectForKey:@"OrderId"] forKey:@"orderId"];
    }
    
    ConfirmOrder *conf = [[ConfirmOrder alloc] initWithDict:dict];
    conf.requestDelegate=self;
    [conf startAsynchronous];
    [Utility ShowMBHUDLoader];
}



- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma COD API

-(void)ConfirmOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [Utility hideMBHUDLoader];
    
    NSString *order_str=[NSString stringWithFormat:@"%@",[[inData objectForKey:@"Payload"]objectForKey:@"OrderId"]] ;
    NSString *amount_str=[NSString stringWithFormat:@"%@",[[inData objectForKey:@"Payload"]objectForKey:@"CollectableAmount"]] ;
    [[NSUserDefaults standardUserDefaults]setObject:order_str forKey:@"payment_order_id"];
    [[NSUserDefaults standardUserDefaults]setObject:amount_str forKey:@"payment_order_amount"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    NSString *CreditUsedPercentage = [[NSUserDefaults standardUserDefaults] stringForKey:@"CreditUsedPercentage"];
    NSString *dateString=self.dateString;
 
    NSString *price=[NSString stringWithFormat:@"UAD %.1f",[[[inData valueForKey:@"Payload"] valueForKey:@"OrderAmount"] floatValue] ];
    
    NSString *yourOrderString;
    NSString *deliverString;
    NSString *restString;
    NSString *message;
    if (self.orderExists==NO) {
        yourOrderString =@"Your order for ";
        deliverString =@" with delivery date  ";
        restString = [NSString stringWithFormat:@" has been received. We will notify you when your order is processed on the day of delivery.  Please note that you may use credits in your account for a max. of %.1f%@ of this order value.",[CreditUsedPercentage floatValue],@"%"];
        
        message = [NSString stringWithFormat:@"%@%@%@%@%@",yourOrderString,price,deliverString,self.dateString,restString];
        NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
        
        //Red and large
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:121/255.0 blue:184/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length,price.length)];
        
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length+price.length + deliverString.length,dateString.length)];
        //Rest of text -- just futura
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+price.length + deliverString.length + dateString.length, hintText.length-(yourOrderString.length+price.length + deliverString.length + dateString.length))];
        
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(0,yourOrderString.length)];
        
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+price.length,deliverString.length)];
        
        if([[inData objectForKey:@"Status"]  isEqual:[NSNumber numberWithInt:1]])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
            alert.tag = 0;
            //[alert show];
            myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 240)];
            [myView showAlertWithTitle:@"Order created successfully"  andMessage:hintText withFram:myView.frame];
            myView.center=self.view.center;
            //if(show_thank==YES)
            // {
            show_thank=NO;
            // }
            // else
            // {
          //  [self.view.window addSubview:myView];
          //  [myView toggle];
            
        }
    
    }
    else
    {
        
        yourOrderString =@"You have successfully edited your order for ";
        deliverString =@". Your revised total order value is  ";
        restString = [NSString stringWithFormat:@". We will notify you when your order is processed on the day of delivery.  Please note that you may use credits in your account for a max. of %.1f%@ of this order value.",[CreditUsedPercentage floatValue],@"%"];
        
        message = [NSString stringWithFormat:@"%@%@%@%@%@",yourOrderString,dateString,deliverString,price,restString];
        NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
        
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:72/255.0 green:144/255.0 blue:48/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length,dateString.length)];
        
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:121/255.0 blue:184/255.0 alpha:1.0]} range:NSMakeRange(yourOrderString.length+dateString.length + deliverString.length,price.length)];
        //Rest of text -- just futura
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+dateString.length + deliverString.length + price.length, hintText.length-(yourOrderString.length+dateString.length + deliverString.length + price.length))];
        
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(0,yourOrderString.length)];
        
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"helveticaNeue" size:15.0f]} range:NSMakeRange(yourOrderString.length+dateString.length,deliverString.length)];
        if([[inData objectForKey:@"Status"]  isEqual:[NSNumber numberWithInt:1]])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
            alert.tag = 0;
            //[alert show];
            myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 240)];
            [myView showAlertWithTitle:@"Order created successfully"  andMessage:hintText withFram:myView.frame];
            myView.center=self.view.center;
            //if(show_thank==YES)
            // {
            show_thank=NO;
            // }
            // else
            // {
          //  [self.view.window addSubview:myView];
          //  [myView toggle];
            
        }
   
    }
    
    [self performSegueWithIdentifier:kthankyouSegueIdentifier sender:self.summaryDicationary];
}
-(void)ConfirmOrderRequestFailedWithErrorMessage:(NSString *)inFailedData
{
 
    [Utility hideMBHUDLoader];
    UIAlertView *fail_alert=[[UIAlertView alloc]initWithTitle:@"" message:inFailedData delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [fail_alert show];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if ([segue.identifier isEqualToString:kthankyouSegueIdentifier]) {
         BGThankYouViewController *thankYouView = segue.destinationViewController;
         thankYouView.summaryDicationary = self.summaryDicationary;
     }
 }



#pragma mark -
#pragma mark PayPalPaymentDelegate methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

#pragma mark - Receive Single Payment

- (void)chainedPayment {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    
     payMentAmount = [NSString stringWithFormat:@"%@",[self.summaryDicationary valueForKey:@"OrderAmount"]];
    if (!([payMentAmount floatValue]>0)) {
        payMentAmount = @"000.0001"; //default values
    }
    
    
    NSString *collectableAmount = [self.summaryDicationary valueForKey:@"CollectableAmount"];
    NSString *orderID = [NSString stringWithFormat:@"%@",[self.summaryDicationary valueForKey:@"OrderId"]];
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"Amount"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"2.0"]
                                    withCurrency:@"AUD"
                                         withSku:orderID];
    //  PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
    //                                  withQuantity:1
    //                                     withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
    //                                  withCurrency:@"USD"
    //                                       withSku:@"Hip-00066"];
    //  PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
    //                                  withQuantity:1
    //                                     withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
    //                                  withCurrency:@"USD"
    //                                       withSku:@"Hip-00291"];
    NSArray *items = @[item1 ];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"AUD";
    payment.shortDescription = @"Amount";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
   
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    NSString *trnsID = [[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"];

    NSMutableDictionary *loginDictioary  = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    [dictionary setValue:[self.summaryDicationary valueForKey:@"OrderId"] forKey:@"OrderId"];
    [dictionary setValue:payMentAmount forKey:@"Amount"];
    [dictionary setValue:trnsID forKey:@"TransactionId"];
    [dictionary setValue:[Utility replaceNULL:[loginDictioary valueForKey:@"RefMembershipID"] value:@""] forKey:@"MemberId"];
    
    [self callPaymentAPI:dictionary];
}

-(void)callPaymentAPI:(NSMutableDictionary*)dictionary{

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"SZCustomers.svc/PaymentUpdatePaypal"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:@"Status"] boolValue] == true
                    ) {
                    
                    [Utility showAlertViewControllerIn:self title:
                     @"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                         [self performSegueWithIdentifier:kthankyouSegueIdentifier sender:self.summaryDicationary];
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


@end

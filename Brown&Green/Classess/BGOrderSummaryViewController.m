//
//  BGOrderSummaryViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 30/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGOrderSummaryViewController.h"
#import "AddressCell.h"
#import "OrderSummaryCell.h"
#import "PaymentWebViewController.h";


@interface BGOrderSummaryViewController (){
    NSMutableDictionary *loginInfo;
    NSString *payMentAmount;
    NSMutableArray *categoryArray;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation BGOrderSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    invalidCoupon = YES;
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    //    _payPalConfig.merchantName = @"ram.pp_api1.gmail.com";
    _payPalConfig.merchantName = @"manpreet.singh-facilitator_api1.brownandgreens.com.au";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
   // self.environment = @"sandbox";
    self.environment = PayPalEnvironmentSandbox;
   // self.environment = kPayPalEnvironment;
    
    // live
   // self.environment = PayPalEnvironmentProduction;
    
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);

// remove all products from product dictionary
    
    AppDelegate*appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    for (NSMutableDictionary *dict in appDelegate.checkProductArray) {
        [dict setObject:@"" forKey:@"productCount"];
    }
    categoryArray =[[NSMutableArray alloc]initWithArray:[appDelegate.checkProductArray valueForKey:@"RefCategoryID"]];
    categoryArray = [categoryArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    [appDelegate.checkProductArray removeAllObjects];
    
    
    appDelegate.totalPrice = @"";

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];

    [self setPayPalEnvironment:self.environment];

    [orderSummaryTabel reloadData];
}


- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}


#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,kiPhoneWidth,40)];
    tempView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f  blue:235.0f/255.0f  alpha:1];
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,kiPhoneHeight-20,40)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor darkGrayColor];
    [tempView addSubview:tempLabel];
    
    if (section == 0) {
        tempLabel.text = @"Payment";
    }
    else if (section == 1) {
        tempLabel.text = @"Delivery";

    }
    return tempView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
    
        static NSString *cellIdentifier  =@"cell";
        OrderSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OrderSummaryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setOrderSummaryData:self.summaryDictionary];
        [cell.viewAndAddButton addTarget:self action:@selector(viewAndAddButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (invalidCoupon == NO) {
            cell.appluButton.hidden = YES;
        }
        else{
            cell.appluButton.hidden = NO;
 
        }

        
        [cell.appluButton addTarget:self action:@selector(applyButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
           [cell.closeButton addTarget:self action:@selector(closeButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // calculation on apply promo code
        
        if (promocodeDictionary) {
            cell.promoCodeTextField.text = [promocodeDictionary valueForKey:@"PromoCode"];
        }
        
        if (invalidCoupon ==NO) {
            cell.messageViewheight.constant = 60;
            cell.messageLabel.hidden= NO;
            cell.closeButton.hidden = NO;
            cell.lineView.hidden = NO;
            
            cell.messageLabel.text = [self.summaryDictionary valueForKey:@"OfferMessage"];
        }
        else{
            cell.messageViewheight.constant = 0;
            cell.messageLabel.hidden= YES;
            cell.closeButton.hidden = YES;
            cell.lineView.hidden = YES;
            
        }
        
        promocodeTextField = cell.promoCodeTextField;
        return cell;
       
    }
    
    static NSString *cellIdentifier  =@"cell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AddressCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *addressButton;
    if (indexPath.row ==0) {
        cell.titleLabel.text = @"Address";
        
        NSString *address = [Utility replaceNULL:[loginInfo valueForKey:kAddress1] value:@""];
        NSString *locality = [Utility replaceNULL:[loginInfo valueForKey:@"Location"] value:@""];
        NSString *CityName = [Utility replaceNULL:[loginInfo valueForKey:@"CityName"] value:@""];
        NSString *city;
        if([loginInfo valueForKey:@"ZipCode"])
        {
            city = [Utility replaceNULL:[loginInfo valueForKey:@"ZipCode"] value:@""];
        }
        else
        {
            city = [Utility replaceNULL:[loginInfo valueForKey:@"Zipcode"] value:@""];
        }
        
       //  city = [Utility replaceNULL:[loginInfo valueForKey:@"ZipCode"] value:@""];
    
        loginInfo =     [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        NSString *addressChk = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:kAddress1]];
       // NSString *localityChk = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:@"LocalityId"]];
        
        NSString *localityChk;
        if([loginInfo valueForKey:@"LocalityId"])
        {
            localityChk = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:@"LocalityId"]];
        }
        else
        {
            localityChk = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:@"LocationId"]];
        }
        
        NSString *cityIdChk;
        if ([[loginInfo valueForKey: @"CityID"] integerValue]>0) {
            cityIdChk = [loginInfo valueForKey: @"CityID"];
        }
        else{
            cityIdChk = [loginInfo valueForKey: @"CityId"];
            
        }
        
        if([addressChk isEqualToString:@""] || !([localityChk integerValue]>0) ||!([cityIdChk integerValue]>0)){
           
        }
        else
        {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",address,locality,city,CityName];
            cell.nameLabelHeight.constant = 40;
        }
        
       
        
        addressButton = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-40, 6, 26, 26)];
        addressButton.backgroundColor = [UIColor clearColor];
        [addressButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addressButton addTarget:self action:@selector(addressButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:addressButton];
        addressButton.hidden = NO;
        
    }else if (indexPath.row ==1) {
        cell.titleLabel.text = @"Mobile Number";
        NSString * mob = [Utility replaceNULL:[loginInfo valueForKey:kMobileNumber] value:@""];
          cell.nameLabel.text = [NSString stringWithFormat:@"+61%@",mob];
        addressButton.hidden = YES;

        
    }else  if (indexPath.row ==2) {
        cell.titleLabel.text = @"Date";
         cell.nameLabel.text = [Utility replaceNULL:[loginInfo valueForKey:@"slotTime"] value:@""];
        cell.nameLabelHeight.constant = 40;
        addressButton.hidden = YES;

        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        
        if (invalidCoupon ==NO) {
            return 296;
        }
        return 236;
        
    }
    else if(indexPath.row ==0 && indexPath.section ==1){
    
        return 80;
    }
    else if(indexPath.row ==2 && indexPath.section ==1){
        
        return 80;
    }
    return 60;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kofferSegueIdentifier]) {
        OfferViewController *offerView = segue.destinationViewController;
        offerView.delegate = self;
    }
    else if ([segue.identifier isEqualToString:kregistrationSegueIdentifier]){
        BGRegistrationViewController *deliveyAddressView = segue.destinationViewController;
        deliveyAddressView.modeType = kOrderSummary;
    }
    else if ([segue.identifier isEqualToString:kregistrationSegueIdentifier]){
        BGRegistrationViewController *deliveyAddressView = segue.destinationViewController;
        deliveyAddressView.modeType = kOrderSummary;
    }
    else if ([segue.identifier isEqualToString:kPaymentOptionSegueIdentifier]){
        BGPaymentTypeViewController *paymentType = segue.destinationViewController;
        
        [self.summaryDictionary setObject:[Utility replaceNULL:[loginInfo valueForKey:@"slotTime"] value:@""] forKey:@"slotTime"];
        paymentType.summaryDicationary = self.summaryDictionary;
    }
    if ([segue.identifier isEqualToString:kthankyouSegueIdentifier]) {
        BGThankYouViewController *thankYouView = segue.destinationViewController;
        [self.summaryDictionary setObject:[Utility replaceNULL:[loginInfo valueForKey:@"slotTime"] value:@""] forKey:@"slotTime"];
        thankYouView.summaryDicationary = self.summaryDictionary;
    }
    
}

#pragma mark - button clicked

-(void)getPromocode:(NSMutableDictionary *)dictionary{
    
    promocodeDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [orderSummaryTabel reloadData];

}
- (void)viewAndAddButton_clicked:(id)sender {
    [self performSegueWithIdentifier:kofferSegueIdentifier sender:nil];
}
- (IBAction)paymentButton_clicked:(id)sender {
    
    if ([self validatePassword]) {
//        [self performSegueWithIdentifier:kPaymentOptionSegueIdentifier sender:nil];
   
      NSString *collectableAmount =  [NSString stringWithFormat:@"%0.1f AUD",[[self.summaryDictionary valueForKey:@"CollectableAmount"] floatValue]];
        if (([collectableAmount floatValue] == 0)) {
            
            [self orderConfirm];

        }
        else{
        [self chainedPayment];
        }
    }
}

- (IBAction)backButton_clicked:(id)sender {
    
    NSString *slotID = [self.summaryDictionary valueForKey:@"TimeSlotId"];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
      if ([slotID integerValue] == 0) {
        [Utility showAlertViewControllerIn:self withAction:@"NO" actionTwo:@"YES" title:@"" message:@"Are you sure? You want to go back. In this case, your current order will be canceled and can be found in My Order cancelled order." block:^(int index){
            if (index ==1) {
               // [self.navigationController popToRootViewControllerAnimated:YES];
                appdelegate.editMyOrder = @"";
                [self loginToHomeView];
            }
        }];
    }
    else{
        [Utility showAlertViewControllerIn:self withAction:@"NO" actionTwo:@"YES" title:@"" message:@"Are you sure? You want to go back. In case, your current order can be found in My Order under upcoming order." block:^(int index){
            if (index ==1) {
               // [self.navigationController popToRootViewControllerAnimated:YES];
                appdelegate.editMyOrder = @"";
                [self loginToHomeView];
            }
        }];
    }
    
   
}

-(void)addressButton_clicked:(UIButton *)sendser{
 [self performSegueWithIdentifier:kregistrationSegueIdentifier sender:kOrderSummary];
}

-(void)applyButton_clicked:(UIButton *)sender
{
    
    if (invalidCoupon == NO) {

        [orderSummaryTabel reloadData];
    }
    
    NSString *strPromo;
    if (promocodeTextField.text) {
        strPromo=promocodeTextField.text;
    }
    if ([strPromo isEqualToString:@""] )
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter promocode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    else {
        
        NSMutableDictionary *loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        NSString *CategoryIds = [categoryArray componentsJoinedByString:@","];
        removePromo=NO;
        NSNumber *memID = [loginInfo valueForKey:@"RefMembershipID"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:memID forKey:@"MembershipId"];
        if ([self.summaryDictionary objectForKey:@"OrderId"]!=nil) {
            [dict setObject:[self.summaryDictionary objectForKey:@"OrderId"] forKey:@"OrderId"];
        }
        NSString *promo=strPromo;//promocodeTextfield.text;
        //[self.summaryDictionary valueForKey:@"PromoCode"];
        [dict setObject:promo forKey:@"PromoCode"];
        NSString *orderAmountValue=[self.summaryDictionary valueForKey:@"OrderAmount"];
        [dict setObject:orderAmountValue forKey:@"OrderAmount"];
        [dict setObject:CategoryIds forKey:@"CategoryIds"];
        ApplyPromoCode *apply = [[ApplyPromoCode alloc] initWithDict:dict];
        apply.requestDelegate=self;
        [apply startAsynchronous];
        [Utility ShowMBHUDLoader];
    }
}

-(void)ApplyPromoCodeRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    NSArray *isvalidArr=[[inData valueForKey:@"Payload"]valueForKey:@"IsValid"];
    int checkString=[[isvalidArr objectAtIndex:0] intValue];
    if (checkString ==1) {
        invalidCoupon=NO;
        
        [applyButton setTitle:@"Remove" forState:UIControlStateNormal];
        
    } else {
        invalidCoupon=YES;
        
        NSArray *offerMessage=[[inData valueForKey:@"Payload"]valueForKey:@"OfferMessage"];
        [Utility showAlertViewControllerIn:self title:@"" message: [offerMessage objectAtIndex:0] block:^(int index){
        promocodeTextField.text = @"";
        }];
    }
    
    NSArray *collectableAmount=[[inData valueForKey:@"Payload"]valueForKey:@"CollectableAmount"];//[NSString stringWithFormat:@"%@",[[inData valueForKey:@"Payload"]valueForKey:@"CollectableAmount"]];
    [self.summaryDictionary setValue:[collectableAmount objectAtIndex:0] forKey:@"CollectableAmount"];
    
    NSArray *offerMessage=[[inData valueForKey:@"Payload"]valueForKey:@"OfferMessage"];
    [self.summaryDictionary setValue:[offerMessage objectAtIndex:0] forKey:@"OfferMessage"];
    applyPromo=YES;
    [orderSummaryTabel reloadData];
}
-(void)ApplyPromoCodeRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)closeButton_clicked:(id)sender {
    
    removePromo=YES;
    applyPromo=NO;
    invalidCoupon = YES;
  
    NSNumber *memID = [loginInfo valueForKey:@"RefMembershipID"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:memID forKey:@"MembershipId"];
    if ([self.summaryDictionary objectForKey:@"OrderId"]!=nil) {
        [dict setObject:[self.summaryDictionary objectForKey:@"OrderId"] forKey:@"OrderId"];
    }
    NSString *promo=[promocodeDictionary valueForKey:@"PromoCode"];
    [dict setObject:promo forKey:@"PromoCode"];
    NSString *orderAmountValue=[self.summaryDictionary valueForKey:@"OrderAmount"];
    [dict setObject:orderAmountValue forKey:@"OrderAmount"];
    //[dict setObject:@"0" forKey:@"CategoryIds"];
    Remove *rem = [[Remove alloc] initWithDict:dict];
    rem.requestDelegate=self;
    [rem startAsynchronous];
    [Utility ShowMBHUDLoader];
}

-(void)RemovePromoCodeRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    
    promocodeTextField.text = @"";
    
    [promocodeDictionary setValue:@"" forKey:@"PromoCode"];
    
    //[promocodeTextfield becomeFirstResponder];
    NSArray *collectableAmount=[[inData valueForKey:@"Payload"]valueForKey:@"CollectableAmount"];//[NSString stringWithFormat:@"%@",[[inData valueForKey:@"Payload"]valueForKey:@"CollectableAmount"]];
    [self.summaryDictionary setValue:[collectableAmount firstObject] forKey:@"CollectableAmount"];
    [orderSummaryTabel reloadData];
}
-(void)RemovePromoCodeRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:inFailedData delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark Validation

- (BOOL)validatePassword{
    loginInfo =     [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *address = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:kAddress1]];
    NSString *locality;
    if([loginInfo valueForKey:@"LocalityId"])
    {
         locality = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:@"LocalityId"]];
    }
    else
    {
        locality = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:@"LocationId"]];
    }
    
    
    NSString *cityId;
    if ([[loginInfo valueForKey: @"CityID"] integerValue]>0) {
        cityId = [loginInfo valueForKey: @"CityID"];
    }
    else{
        cityId = [loginInfo valueForKey: @"CityId"];

    }
  
    if([address isEqualToString:@""] || !([locality integerValue]>0) ||!([cityId integerValue]>0)){
       // if([address isEqualToString:@""] || !([locality integerValue]>0) ){
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please Update Address" block:^(int index) {
           [self performSegueWithIdentifier:kregistrationSegueIdentifier sender:kOrderSummary];
        }];
        return false;
    }
   
    return true;
}

#pragma mark - Receive Single Payment

- (void)chainedPayment {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PaymentWebViewController *PaymentWebViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PaymentWebViewController"];
    [self.summaryDictionary setObject:[Utility replaceNULL:[loginInfo valueForKey:@"slotTime"] value:@""] forKey:@"slotTime"];
    PaymentWebViewController.summaryDictionary = self.summaryDictionary;
    [self.navigationController pushViewController:PaymentWebViewController animated:YES];
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    
    //payMentAmount = [NSString stringWithFormat:@"%@",[self.summaryDictionary valueForKey:@"OrderAmount"]];
    
   /* payMentAmount = [NSString stringWithFormat:@"%@",[self.summaryDictionary valueForKey:@"CollectableAmount"]];
    if ([payMentAmount integerValue] ==0) {
        payMentAmount = @"0.01";
    }
    
    
    NSString *collectableAmount = [self.summaryDictionary valueForKey:@"CollectableAmount"];
    NSString *orderID = [NSString stringWithFormat:@"%@",[self.summaryDictionary valueForKey:@"OrderId"]];
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"Amount"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",payMentAmount]]
                                    withCurrency:@"AUD"
                                         withSku:orderID];
   
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
    [self presentViewController:paymentViewController animated:YES completion:nil];*/
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
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
    
    [dictionary setValue:[self.summaryDictionary valueForKey:@"OrderId"] forKey:@"OrderId"];
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
-(void)orderConfirm{
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[subCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                     kFIRParameterItemName:@"ConfirmFree",
                                     kFIRParameterContentType:@"button"
                                     }];
    
    NSMutableDictionary *loginDict = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *memID = [NSString stringWithFormat:@"%@",[loginDict valueForKey:@"RefMembershipID"]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:memID forKey:@"membershipId"];
    if ([self.summaryDictionary objectForKey:@"OrderId"]!=nil) {
        [dict setObject:[self.summaryDictionary objectForKey:@"OrderId"] forKey:@"orderId"];
    }
    
    ConfirmOrder *conf = [[ConfirmOrder alloc] initWithDict:dict];
    conf.requestDelegate=self;
    [conf startAsynchronous];
    [Utility ShowMBHUDLoader];
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
          [self performSegueWithIdentifier:kthankyouSegueIdentifier sender:self.summaryDictionary];
}
-(void)ConfirmOrderRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    
    [Utility hideMBHUDLoader];
    UIAlertView *fail_alert=[[UIAlertView alloc]initWithTitle:@"" message:inFailedData delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [fail_alert show];
}


-(void)loginToHomeView{
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
}
@end

//
//  MyCartViewController.m
//  Brown&Green
//
//  Created by vineet patidar on 29/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "MyCartViewController.h"
#import "MyCartCell.h"
@interface MyCartViewController (){
    AppDelegate *appDelegate;
    UILabel *badgeLabel;
    NSString *strPrice;
    NSInteger totalItem;
    SWRevealViewController *revealViewController;
    NSMutableDictionary *loginInfo;
    NSString *guestUser;
}

@end

@implementation MyCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    loginInfo  = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    guestUser = [Utility replaceNULL:[kUserDefault valueForKey:kGuestUser] value:@""];
    
    // Do any additional setup after loading the view.
    
    // set initial data
    iofDB = [IOFDB sharedManager];
    if ([self.title isEqualToString:kRevealMenu]) {
        
        self.title = @"My Cart";

        revealViewController = self.revealViewController;
        if ( revealViewController )
        {   revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [backButton setTarget: self.revealViewController];
                [backButton setAction: @selector( revealToggle: )];
                [backButton setImage:[UIImage imageNamed:@"menu"]];
               // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
        }
        self.revealViewController.delegate = self;
    }
    
   else if ([appDelegate.editMyOrder isEqualToString:kEditMyOrder]) {
   
        self.title = @"Update Order";
        [backButton setImage:[UIImage imageNamed:@"backButton"]];
        // category products
        
    }
    else if ([appDelegate.editMyOrder isEqualToString:kReOrder]) {
        [backButton setImage:[UIImage imageNamed:@"backButton"]];
    }

    else{
        if (![self.incomingType isEqualToString:kProduct]) {
            revealViewController = self.revealViewController;
            if ( revealViewController )
            {   revealViewController = self.revealViewController;
                if ( revealViewController )
                {
                    [backButton setTarget: self.revealViewController];
                    [backButton setAction: @selector( revealToggle: )];
                    [backButton setImage:[UIImage imageNamed:@"menu"]];
                   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                }
            }
            self.revealViewController.delegate = self;
        }
    }
    
    

    

}

-(void)viewWillAppear:(BOOL)animated{
    
    // google analytics
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self CreateDataSourceForCategoryWise];

    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"My Cart Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if (myView) {
        [myView removeFromSuperview];
    }
   
    appDelegate.totalItemCount = 0;
    appDelegate.totalPrice = 0;
    
    
            for (NSMutableDictionary *dict in myCartArray) {
                
                if (dict.count>0) {
                    
                    appDelegate.totalItemCount = appDelegate.totalItemCount+[[dict valueForKey:@"rows"] count];
                    totalItemLabel.text = [NSString stringWithFormat:@"%ld Item(s)",(long)appDelegate.totalItemCount];
    
                    if ([[dict valueForKey:@"rows"] count]> 0) {
                        for (int i = 0; i <[[dict valueForKey:@"rows"] count]; i++) {
    
                            NSMutableDictionary *dictFilter = [[dict valueForKey:@"rows"] objectAtIndex:i];
    
                            if (dictFilter) {
                                appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",[appDelegate.totalPrice floatValue] + [[dictFilter valueForKey:@"SalePrice"] floatValue]*[[dictFilter valueForKey:@"productCount"] integerValue]];
                            }
    
                        }
                        }
                }
    
//    if ([self.incomingType isEqualToString:kProduct]) {
//        
//        for (NSMutableDictionary *dict in myCartArray) {
//            if (dict.count>0) {
//                appDelegate.totalItemCount = appDelegate.totalItemCount+[[dict valueForKey:@"rows"] count];
//                totalItemLabel.text = [NSString stringWithFormat:@"%ld Item(s)",(long)appDelegate.totalItemCount];
//                
//                appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",[appDelegate.totalPrice floatValue] - [[dict valueForKey:@"SalePrice"] floatValue]];
//                
//                totalPriceLabel.text = [NSString stringWithFormat:@"%@ AUD",appDelegate.totalPrice];
//            }
//        }
//
//        
//    }
//    else{
//        for (NSMutableDictionary *dict in myCartArray) {
//            if (dict.count>0) {
//                appDelegate.totalItemCount = appDelegate.totalItemCount+[[dict valueForKey:@"rows"] count];
//                totalItemLabel.text = [NSString stringWithFormat:@"%ld Item(s)",(long)appDelegate.totalItemCount];
//                
//                if ([[dict valueForKey:@"rows"] count]> 0) {
//                    for (int i = 0; i <[[dict valueForKey:@"rows"] count]; i++) {
//                        
//                        NSMutableDictionary *dictFilter = [[dict valueForKey:@"rows"] objectAtIndex:i];
//                        
//                        if (dictFilter) {
//                            appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",[appDelegate.totalPrice floatValue] - [[dictFilter valueForKey:@"SalePrice"] floatValue]];
//                        }
//                        
//                        
//                    }
//                }
//                
//                
//                
//                
//                
//                totalPriceLabel.text = [NSString stringWithFormat:@"%@ AUD",appDelegate.totalPrice];
//            }
//        }
//    }
    
}
}
//-(void)viewWillDisappear:(BOOL)animated{
//    badgeLabel.hidden = YES;
//}
-(void)CreateDataSourceForCategoryWise
{
    iofDB = [IOFDB sharedManager];
    
   /* // bucket product count label
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kiPhoneWidth-20, 1, 20, 20)];
    badgeLabel.layer.cornerRadius = 10;
    [badgeLabel.layer setMasksToBounds:YES];
    badgeLabel.backgroundColor = kDefaultLightGreen;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:12];
    [self.navigationController.navigationBar addSubview:badgeLabel];*/


    [self getMyCartData];
}


-(void)getMyCartData{
    
    UILabel *lbl;
    if (appDelegate.checkProductArray.count==0) {
        
        myCartTable.hidden = YES;
        checkoutButton.hidden = YES;
        addMoreButton.hidden = YES;
        
         lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (kiPhoneHeight-50)/2, kiPhoneWidth, 30)];
        lbl.text = @"No Product Added";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = [UIColor lightGrayColor];
        [self.view addSubview:lbl];
        
        totalItemLabel.text = @"";
        appDelegate.totalItemCount = 0;
        totalPriceLabel.text = @"";
            
        
        
        [Utility showAlertViewControllerIn:self title:@"" message:@"No Product Added" block:^(int index){
            
            
             if ([appDelegate.editMyOrder isEqualToString:kEditMyOrder]||[appDelegate.editMyOrder isEqualToString:kReOrder] || [self.incomingType isEqualToString:kProduct]) {
                
                 [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                 [revealViewController revealToggleAnimated:YES];
             }

            [lbl removeFromSuperview];
        
        }];
        
        return;
    }
    
    NSMutableArray *arrTemp;
    arrTemp = appDelegate.checkProductArray;
    NSMutableArray *categoriesArray = [arrTemp valueForKeyPath:@"RefCategoryID"];
    
    NSSet *set = [NSSet setWithArray:categoriesArray];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@",@"CategoryID",set];
    NSArray *catArr = [iofDB.mArrCategories filteredArrayUsingPredicate:predicate];
    myCartArray =[catArr mutableCopy];
    
    NSMutableArray *subCatArr= (NSMutableArray *)[iofDB.mArrSubCategories filteredArrayUsingPredicate:predicate];
    if (subCatArr.count!=0)
    {
        for (NSDictionary* obj in subCatArr)
        {
            [myCartArray addObject:obj];
        }
    }
    
    
    
    for (NSMutableDictionary *dic in myCartArray)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"RefCategoryID",[dic valueForKey:@"CategoryID"]];
        NSMutableArray *arr = (NSMutableArray *)[arrTemp filteredArrayUsingPredicate:predicate];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic=[arr objectAtIndex:i];
            NSString *productId=[dic objectForKey:@"ProductID"];
            if (productId==nil)
            {
                productId=[dic objectForKey:@"ProductId"];
            }
            NSDictionary *localProductDic=[iofDB getProductById:productId];
            if (localProductDic.count>0) {
                NSString *price = [localProductDic objectForKey: @"SalePrice"];
                [dic setValue:price forKey:@"SalePrice"];
            }
            else{
                if ([dic objectForKey: @"CostPirce"]) {
                    NSString *price = [dic objectForKey: @"CostPirce"];
                    [dic setValue:price forKey:@"SalePrice"];
    
                }
        }
        }
        [dic setObject:arr forKey:@"rows"];
    }
 
    if ([appDelegate.checkProductArray count]>0) {
        badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[appDelegate.checkProductArray count]];
    }
    else{
        badgeLabel.hidden = YES;
    }
    
    if (myCartArray.count ==0) {
        totalItemLabel.text = @"";
        appDelegate.totalItemCount = 0;
        totalPriceLabel.text = @"";
    }
    
    
    [myCartTable reloadData];

}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [myCartArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[myCartArray objectAtIndex:section] valueForKey:@"rows"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(15,0,kiPhoneWidth-30,25)];
    tempView.backgroundColor = kDefaultLightGreen;
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,kiPhoneWidth-30,25)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [tempView addSubview:tempLabel];
    UILabel *itemLabel=[[UILabel alloc]initWithFrame:CGRectMake(kiPhoneWidth-130,0,100,25)];
    itemLabel.backgroundColor=[UIColor clearColor];
    itemLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    itemLabel.textAlignment = NSTextAlignmentRight;
    itemLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [tempView addSubview:itemLabel];
    NSMutableDictionary *dicCategory = [myCartArray objectAtIndex:section];
    tempLabel.text=[dicCategory valueForKey:@"CategoryName"];
    NSString *itemText = [NSString stringWithFormat:@"%lu %@",(unsigned long)[[dicCategory valueForKey:@"rows"] count],@"Item(s)"];
    itemLabel.text =itemText;
   
    return tempView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellIdentifier3  =@"cell";
    
    MyCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MyCartCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.myCartTable = myCartTable;
    cell.viewController = self;
     NSMutableDictionary *dicProduct = [[[myCartArray objectAtIndex:indexPath.section] valueForKey:@"rows"] objectAtIndex:indexPath.row];
    [cell setData:dicProduct index:indexPath.row myCartArray:myCartArray];
    
    cell.removeButton.tag = indexPath.section;
    [cell.removeButton addTarget:self action:@selector(removeButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    totalItemLabel.text = [NSString stringWithFormat:@"%ld Item(s)",(long)appDelegate.totalItemCount];
    totalPriceLabel.text = [NSString stringWithFormat:@"%@ AUD",appDelegate.totalPrice];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dicProduct = [[[myCartArray objectAtIndex:indexPath.section] valueForKey:@"rows"] objectAtIndex:indexPath.row];
    if (appDelegate.checkProductArray.count>0) {
        // set special text
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ProductID = %@",[NSString stringWithFormat:@"%@",[dicProduct valueForKey:@"ProductID"]]];
        
        NSArray *filterArray = [appDelegate.checkProductArray filteredArrayUsingPredicate:predicate];
        
        NSMutableDictionary *dict = [filterArray objectAtIndex:0];
     
        if ([Utility replaceNULL:[dict valueForKey:kRequestTextField] value:@""].length>0) {
            return 240;
        }
        return 165;

    }
        return 165;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *dicProduct = [[[myCartArray objectAtIndex:indexPath.section] valueForKey:@"rows"] objectAtIndex:indexPath.row];
        
        
        if ([appDelegate.checkProductArray containsObject:dicProduct]) {
            [appDelegate.checkProductArray removeObject:dicProduct];
            
            
            if ([[dicProduct valueForKey:kproductCount] integerValue]>0) {
                
                float salePrice = [[dicProduct valueForKey:@"SalePrice"] floatValue] * [[dicProduct valueForKey:@"productCount"] floatValue];
                
                appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",[appDelegate.totalPrice floatValue] - salePrice];
                totalPriceLabel.text = [NSString stringWithFormat:@"%@ AUD",appDelegate.totalPrice];
            }
            
            if (appDelegate.totalItemCount>0) {
                appDelegate.totalItemCount = appDelegate.totalItemCount - 1;
                totalItemLabel.text = [NSString stringWithFormat:@"%ld Item(s)",(long)appDelegate.totalItemCount];
            }
        }
        
        [dicProduct setObject:@"" forKey:kproductCount];
        strPrice = @"";
        NSLog(@"%@",appDelegate.checkProductArray);
        
        
        if (appDelegate.checkProductArray.count ==0) {
            [self getMyCartData];
        }
        else {
            [self getMyCartData];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

#pragma  mark - button clicked

- (void)removeButton_clicked:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
   
    CGPoint buttonPosition = [btn convertPoint:CGPointZero
                                           toView:myCartTable];
    NSIndexPath *tappedIP = [myCartTable indexPathForRowAtPoint:buttonPosition];
 
    NSMutableDictionary *dicProduct = [[[myCartArray objectAtIndex:tappedIP.section] valueForKey:@"rows"] objectAtIndex:tappedIP.row];
    
    
    if ([appDelegate.checkProductArray containsObject:dicProduct]) {
        [appDelegate.checkProductArray removeObject:dicProduct];
        
        
        if ([[dicProduct valueForKey:kproductCount] integerValue]>0) {
            
        float salePrice = [[dicProduct valueForKey:@"SalePrice"] floatValue] * [[dicProduct valueForKey:@"productCount"] floatValue];
            
            appDelegate.totalPrice = [NSString stringWithFormat:@"%0.2f",[appDelegate.totalPrice floatValue] - salePrice];
            totalPriceLabel.text = [NSString stringWithFormat:@"%@ AUD",appDelegate.totalPrice];
        }
        
        if (appDelegate.totalItemCount>0) {
            appDelegate.totalItemCount = appDelegate.totalItemCount - 1;
            totalItemLabel.text = [NSString stringWithFormat:@"%ld Item(s)",(long)appDelegate.totalItemCount];
        }
    }
    
    [dicProduct setObject:@"" forKey:kproductCount];
    strPrice = @"";
    NSLog(@"%@",appDelegate.checkProductArray);

    
    if (appDelegate.checkProductArray.count ==0) {
        [self getMyCartData];
    }
    else {
    [self getMyCartData];
    }
    
}


- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (IBAction)bucketButton_clicked:(id)sender {
//}

- (IBAction)searchButton_clicked:(id)sender {
}

- (IBAction)checkoutButton_clicked:(id)sender {
    
    if ([guestUser isEqualToString:kGuestUser]) {
        
        [kUserDefault setValue:@"myCart" forKey:kGuestUserInComingScreen];
        [kUserDefault setValue:kMyCartInGuestUser forKey:kMyCartInGuestUser];

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        BGSignInViewController *signInViewController = [storyBoard instantiateViewControllerWithIdentifier:@"signViewStoryBoardId"];
        [self.navigationController pushViewController:signInViewController animated:YES];
    }
    else{
    
    if ([appDelegate.editMyOrder isEqualToString:kEditMyOrder]) {
        [self getEditOrderDetails];
    }
    else{
        [self performSegueWithIdentifier:kdeliveyScheduleSegueIdentifier sender:nil];
    }
    }

    
  /*  GetCutOffTimeRequest *signup = [[GetCutOffTimeRequest alloc] initWithGet];
    signup.requestDelegate=self;
    [signup startAsynchronous];
    [Utility ShowMBHUDLoader]; */

}

-(void)getEditOrderDetails{
  
        NSNumber *memID = [loginInfo valueForKey:@"RefMembershipID"];
        NSMutableArray *arrProduct = [NSMutableArray array];
        
        for(NSMutableDictionary *dict in appDelegate.checkProductArray)
        {
            NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
            if ([dict objectForKey:@"ProductID"]) {
                [dic setObject:[dict objectForKey:@"ProductID"] forKey:@"ProductId"];
                //NSString *qunt =[dict objectForKey:@"items"];
                NSString *qunt =[dict objectForKey:@"productCount"];
                [dic setObject:[NSNumber numberWithInt:[qunt intValue] ] forKey:@"Quantity"];
                [dic setObject:@"Y" forKey:@"IsActive"];
                [arrProduct addObject:dic];
            }
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:memID forKey:@"MembershipId"];
        [dict setObject:[appDelegate.editProductDictionary valueForKey:@"OrderId"] forKey:@"OrderId"];
        [dict setObject:arrProduct forKey:@"OneTimeProductList"];
        UpdateOneTimeOrderRequest *updOneTimeOrder = [[UpdateOneTimeOrderRequest alloc] initWithDict:dict];
        updOneTimeOrder.requestDelegate=self;
        [updOneTimeOrder startAsynchronous];
        [Utility ShowMBHUDLoader];
        
    
}

- (IBAction)addMoreButton_clicked:(id)sender {
    if ([appDelegate.editMyOrder isEqualToString:kEditMyOrder]||[appDelegate.editMyOrder isEqualToString:kReOrder]) {
       BGHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
        [self.navigationController pushViewController:homeViewController animated:YES];
    }
    else{
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - APIS

-(void)GetCutOffTimeRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{

    [Utility hideMBHUDLoader];
    
    cutOffDict=inData;
    NSMutableArray *payLoadArr = [inData objectForKey:@"Payload"];
    NSMutableDictionary *dic =[payLoadArr firstObject];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"MinOrderAmt"] forKey:@"MinOrderAmt"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"CreditUsedPercentage"] forKey:@"CreditUsedPercentage"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"OrderMessage"] forKey:@"OrderMessage"];
    
    if ([[dic objectForKey:@"MinOrderAmt"] floatValue]>[totalPriceLabel.text floatValue]) {
        NSString *orderMessage=[dic objectForKey:@"OrderMessage"];
        NSString *deliveryCharges=[NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"DeliveryCharges"]floatValue]];
        orderMessage=[orderMessage stringByReplacingOccurrencesOfString:@"#DelCharge" withString:deliveryCharges];
        NSString *remainOrderValue=[NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"MinOrderAmt"] floatValue]-[totalPriceLabel.text floatValue]];
        orderMessage=[orderMessage stringByReplacingOccurrencesOfString:@"#RemainingOrderVal" withString:remainOrderValue];
        NSString *msg =[NSString stringWithFormat:@"%@",orderMessage];
        NSString *minOrderAmt = [[NSUserDefaults standardUserDefaults] stringForKey:@"MinOrderAmt"];
        NSString *title = [NSString stringWithFormat:@"Free Delivery > ₹ %.1f",[minOrderAmt floatValue]];//@"Minimum Order ₹ 200.0";
        myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 180)];
        myView.cDelegate=self;
//        myView.isFromDeliveryMsg=YES;
        [myView showMinAlertWithTitle:title andMessage:msg withFram:myView.frame];
        myView.center=self.view.center;
        [self.view addSubview:myView];
        [myView toggle];
        
    }
    else
    {
        
    [self performSegueWithIdentifier:kdeliveyScheduleSegueIdentifier sender:nil];
        
    }
}

-(void)GetCutOffTimeRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];
}


-(void)UpdateOneTimeOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    [Utility hideMBHUDLoader];

    NSString *order_str=[NSString stringWithFormat:@"%@",[[inData objectForKey:@"Payload"]objectForKey:@"OrderId"]] ;
    NSString *amount_str=[NSString stringWithFormat:@"%@",[[inData objectForKey:@"Payload"]objectForKey:@"CollectableAmount"]] ;
    [loginInfo setObject:order_str forKey:@"payment_order_id"];
    [loginInfo setObject:amount_str forKey:@"payment_order_amount"];
    
    [kUserDefault setValue:[Utility archiveData:loginInfo] forKey:kLoginInfo];
    
            BGOrderSummaryViewController *orderSummaryView = [self.storyboard instantiateViewControllerWithIdentifier:@"orderSummaryViewController"];
    orderSummaryView.summaryDictionary = [inData valueForKey:@"Payload"];
            [self.navigationController pushViewController:orderSummaryView animated:YES];
    
}

-(void)UpdateOneTimeOrderRequestFailedWithErrorMessage:(NSString *)inFailedData{
    //[appDelegate.currentOrder removeAllObjects];
    
    [Utility hideMBHUDLoader];

    [Utility showAlertViewControllerIn:self title:@"" message:inFailedData block:^(int index){}];
}


-(void)proceedWithDelivery
{
   /* viewCart.userInteractionEnabled=YES;
    if (appDelegate.forAutoOrder == YES)
    {
        SaveToAutoShipViewController *save = [[SaveToAutoShipViewController alloc] initWithNibName:@"SaveToAutoShipViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:save animated:YES];
        
    }
    else
    {
        if(appDelegate.currentOrder.count!=0)
        {
            self.payTotalPrice=totalPrice.text;
            NSNumber *memID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MembershipID"];
            NSMutableArray *arrProduct = [NSMutableArray array];
            
            for(NSMutableDictionary *dict in appDelegate.checkProductArr)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
                if ([dict objectForKey:@"ProductID"]) {
                    [dic setObject:[dict objectForKey:@"ProductID"] forKey:@"ProductId"];
                    NSString *qunt =[dict objectForKey:@"items"];
                    [dic setObject:[NSNumber numberWithInt:[qunt intValue] ] forKey:@"Quantity"];
                    [dic setObject:@"Y" forKey:@"IsActive"];
                    [arrProduct addObject:dic];
                }
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:memID forKey:@"MembershipId"];
            [dict setObject:[appDelegate.currentOrder valueForKey:@"OrderId"] forKey:@"OrderId"];
            [dict setObject:arrProduct forKey:@"OneTimeProductList"];
            UpdateOneTimeOrderRequest *updOneTimeOrder = [[UpdateOneTimeOrderRequest alloc] initWithDict:dict];
            updOneTimeOrder.requestDelegate=self;
            [updOneTimeOrder startAsynchronous];
            [appDelegate showGlobalProgressHUDWithTitle:nil];
        }
        else
        {
            if (appDelegate.currentOrder.count!=0)
            {
                [self.navigationController pushViewController:pay animated:YES];
                [appDelegate.currentOrder removeAllObjects];
                
            }
            else
            {
                productIdStr=[NSString stringWithFormat:@"%@",[[productIdArr valueForKeyPath:@"ProductID"] componentsJoinedByString: @","]];
                DeliverySchViewController *delivery = [[DeliverySchViewController alloc] initWithNibName:@"DeliverySchViewController" bundle:[NSBundle mainBundle]];
                delivery.cutOffDict=cutOffDict;
                delivery.productIdStr=productIdStr;
                
                delivery.totalPrice= totalPrice.text;
                delivery.navigationItem.title=@"Delivery Schedule";
                
                [self.navigationController pushViewController:delivery animated:YES];
                
            }
        }
    
    }*/
    
    [self performSegueWithIdentifier:kdeliveyScheduleSegueIdentifier sender:nil];

    
}
@end

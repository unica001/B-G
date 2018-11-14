//
//  VC1.m
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "VC1.h"
#import "MyDonaitonCell.h"
#import "UpComingOrderCell.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"

@interface VC1 (){
//    MyDonaitonCell *cell;
    UpComingOrderCell * cell;
    NSMutableArray *dummy,*Upcoming_Order;
    AppDelegate *appDelegate;
    NSMutableDictionary *loginInfo;
    
}

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    cell = (UpComingOrderCell *)[[[NSBundle mainBundle] loadNibNamed:@"UpComingOrderCell" owner:self options:nil] lastObject];
    _tbl_VC1.rowHeight = UITableViewAutomaticDimension;
    _tbl_VC1.estimatedRowHeight = 200;
    dummy = [[NSMutableArray alloc] init];
    Upcoming_Order = [[NSMutableArray alloc] init];
    [self Getting_UpcomingOrdersList_Service];
    _tbl_VC1.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    loginInfo  = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    iofDB = [IOFDB sharedManager];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"]);
    
    self.lbl_TimeStamp.text =[NSString stringWithFormat:@"Last update on %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"]];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_popup_view setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  [_tbl_VC1 setContentSize:CGSizeMake(self.view.frame.size.width,180 * 10)];
   // [self.tbl_VC1 setContentInset:UIEdgeInsetsMake(0, 0,180, 0)];
   // _constraint_tbl_Height.constant = 180 * 12;
    
}
#pragma mark - UIStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - UITableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[dummy objectAtIndex:indexPath.row] intValue] == 0) {
            return UITableViewAutomaticDimension;
    }else{
        
        return 110;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Upcoming_Order.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell  = (UpComingOrderCell *)[_tbl_VC1 dequeueReusableCellWithIdentifier:@"UpComingOrderCell"];
    if (cell == nil) {
        cell = (UpComingOrderCell *)[[[NSBundle mainBundle] loadNibNamed:@"UpComingOrderCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   cell.rowButton.tag = cell.btn_dropDown.tag = cell.btn_EditOrCancel.tag = indexPath.row;
   // [cell.btn_dropDown addTarget:self action:@selector(btn_dropDown_Clicked: event:) forControlEvents:UIControlEventTouchUpInside];
     [cell.rowButton addTarget:self action:@selector(btn_dropDown_Clicked: event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_EditOrCancel addTarget:self action:@selector(btn_EditOrCancel_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lbl_TimeSlot_Id.text = [self currenrDate:[[Upcoming_Order objectAtIndex:indexPath.row] objectForKey:@"OrderDate"]];
    cell.lbl_TimeSlot_Id.text = [[Upcoming_Order objectAtIndex:indexPath.row] objectForKey:@"DeliveryTime"];
    NSString *amount = [NSString stringWithFormat:@"Amount : %0.2f AUD",[[[Upcoming_Order objectAtIndex:indexPath.row] objectForKey:@"OrderAmount"]floatValue]];
    NSString *dae_str = [[Upcoming_Order objectAtIndex:indexPath.row] objectForKey:@"OrderDate"];
    
    NSString *orderId = [NSString stringWithFormat:@"Order Id : %@, %@",[[Upcoming_Order objectAtIndex:indexPath.row] objectForKey:@"OrderId"], amount];
    cell.orderIdLable.text = orderId;
    
    cell.lbl_Date.text = [self UTCDateConversionIntoNSdate:dae_str];
    if ([[[Upcoming_Order objectAtIndex:indexPath.row] objectForKey:@"ProductList"] count] != 0) {
     
        NSArray * str_arr = [[Upcoming_Order objectAtIndex:indexPath.row] objectForKey:@"ProductList"];
        NSMutableString *result_str = [[NSMutableString alloc] init];
        for (NSDictionary *dic in str_arr) {
            [result_str appendString:[NSString stringWithFormat:@"%@ - %@ Pack/ %@ %@ \n",[dic objectForKey:@"ProductName"],[dic objectForKey:@"Quantity"],[dic objectForKey:@"UnitValue"],[dic objectForKey:@"UntiName"]]];
        }
        cell.lbl_ProductList.text = result_str;
    }
    
   
    if ([[dummy objectAtIndex:indexPath.row] intValue] == 1) {
        [cell.Edit_View setHidden:YES];
        
        [cell.btn_dropDown setImage:[UIImage imageNamed:@"DropDown"] forState:UIControlStateNormal];
    }else{
         [cell.Edit_View setHidden:NO];
        [cell.btn_dropDown setImage:[UIImage imageNamed:@"Dropup"] forState:UIControlStateNormal];
    }
    
    // set edit/cancel button tag
    cell.btn_EditOrCancel.tag = indexPath.row;
    
    NSString *status = [NSString stringWithFormat:@"%@",[[Upcoming_Order objectAtIndex:indexPath.row]valueForKey:@"Status"]];
    status = [status stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    status = [Utility replaceNULL:status value:@""];
    
    NSLog(@"%@",status);
    
    cell.abandonedLabel.hidden = YES;

    if ([status isEqualToString:@"NotConfirmed"]) {
        [cell.btn_EditOrCancel setTitle:@"Confirm/Cancel" forState:UIControlStateNormal];
        cell.abandonedLabel.hidden = NO;
    }
    else if ([status isEqualToString:@""]) {
       [cell.btn_EditOrCancel setTitle:@"Edit/Cancel" forState:UIControlStateNormal];
    }
    else{
    [cell.btn_EditOrCancel setTitle:status forState:UIControlStateNormal];
    }
    
    // hide button if delivery schedule in within 2 hour
    if ([[[Upcoming_Order objectAtIndex:indexPath.row]valueForKey:@"SlotId"] integerValue] ==0) {
        cell.btn_EditOrCancel.hidden = YES;
    }
    else{
        cell.btn_EditOrCancel.hidden = NO;
    }
    
    return cell;
}
-(NSString *)UTCDateConversionIntoNSdate:(NSString *)currentdate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:currentdate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"EEEE,MMM d"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}
-(void)btn_dropDown_Clicked:(UIButton *)sender event:(id)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:_tbl_VC1];
    NSIndexPath * index = [_tbl_VC1 indexPathForRowAtPoint:point];
    
//    CGPoint center = sender.center;
//    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_VC1];
//    NSIndexPath * index = [_tbl_VC1 indexPathForRowAtPoint:rootPoint];
    NSLog(@"indexpath :%lu",index.row);
    if ([[dummy objectAtIndex:index.row] intValue] == 0) {
        [dummy replaceObjectAtIndex:index.row withObject:@"1"];
    }else{
        [dummy replaceObjectAtIndex:index.row withObject:@"0"];
    }
    [_tbl_VC1 reloadData];
}
-(void)btn_EditOrCancel_Clicked:(UIButton *)sender
{
    
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_VC1];
    NSIndexPath * index = [_tbl_VC1 indexPathForRowAtPoint:rootPoint];
    selectedConfirmOrderIndex = index.row;
    
    _editButton.tag = index.row;
    _cancelButton.tag = index.row;
    
    
    NSString *status = [NSString stringWithFormat:@"%@",[[Upcoming_Order objectAtIndex:index.row]valueForKey:@"Status"]];
    status = [status stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    status = [Utility replaceNULL:status value:@""];
    
    NSLog(@"%@",status);
    
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuesture_clicked:)];
    
    if ([status isEqualToString:@"NotConfirmed"]) {
        
     /*   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"My Order" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Edit Order" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self btn_Edit_Clicked:_editButton];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Confirm Order" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self confirmOrder];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self btn_Cancel_clicked:_cancelButton];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];*/
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""  message:@"What would you like to do?"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *editOrder = [UIAlertAction actionWithTitle:@"Edit Order" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self btn_Edit_Clicked:_editButton];
            
        }];
        UIAlertAction*confirmOrder = [UIAlertAction actionWithTitle:@"Confirm Order" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self confirmOrder];
        }];
        UIAlertAction*cancelOrder = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self btn_Cancel_clicked:_cancelButton];
        }];
        
        [editOrder setValue:kDefaultLightGreen forKey:@"titleTextColor"];
        [confirmOrder setValue:kDefaultLightGreen forKey:@"titleTextColor"];
        [cancelOrder setValue:kDefaultLightGreen forKey:@"titleTextColor"];
        
        [alertController addAction:editOrder];
        [alertController addAction:confirmOrder];
        [alertController addAction:cancelOrder];
      //  [alertController.view addGestureRecognizer:tapGuesture];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else if ([status isEqualToString:@""]) {
       // [_popup_view setHidden:NO];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"What would you like to do?"  message:@""  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *editOrder = [UIAlertAction actionWithTitle:@"Edit Order" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self btn_Edit_Clicked:_editButton];

        }];
        UIAlertAction*cancelOrder = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self btn_Cancel_clicked:_cancelButton];
        }];
        
        [editOrder setValue:kDefaultLightGreen forKey:@"titleTextColor"];
        [cancelOrder setValue:kDefaultLightGreen forKey:@"titleTextColor"];
        
        [alertController addAction:editOrder];
        [alertController addAction:cancelOrder];
        //[alertController.view addGestureRecognizer:tapGuesture];

        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    

}
-(NSString *)currenrDate:(NSString *)date_str{
//    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"EEEE,MMM YY"];
//    NSString *str_date =[formater stringFromDate:[NSDate date]];
//    
    NSString *str_date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    NSDate *date = [dateFormatter dateFromString:@"2015-04-01T11:42:00"]; // create date from string
    NSDate *date = [dateFormatter dateFromString:date_str];
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"EEEE,MM d"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    str_date =  [dateFormatter stringFromDate:date];
    return str_date;
    
}


#pragma mark -Webservices
-(void)Getting_UpcomingOrdersList_Service{
    NSString *strRequestURL = @"SZCustomers.svc/getCustomerOrderSchedule_v4";
    
    NSMutableDictionary *loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"RefMembershipID"]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:membershipID,@"MembershipId",nil];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    [MBProgressHUD showHUDAddedTo:ObjDelegate.window animated:YES];
    ConnectionManager *connectionManager = [ConnectionManager sharedInstance];
    [connectionManager startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:strRequestURL withParameters:params withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"%ld",(long)[operation.response statusCode]);
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if ([operation.response statusCode]  == 203){
                [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
                [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];

                return;
            }
            NSDictionary *responseDict = (NSDictionary*) responseObject;
            
            if ([responseDict objectForKey:@"response"] != [NSNull null])
            {
                if([operation.response statusCode]  == 200){
                    
                    NSString * status = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Status"]];
                    NSString * code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Code"]];
                    if ([code isEqualToString:@"OK"] && [status isEqualToString:@"1"]) {
//                        NSMutableArray * json_Arr = [[NSMutableArray alloc] init];
//                        json_Arr = [responseDict objectForKey:@"Payload"];
                        NSLog(@"json deatils :%@",[responseDict objectForKey:@"Payload"]);
                        _lbl_TransactionDetails.text = [responseDict objectForKey:@"Message"];
                        Upcoming_Order = [responseDict objectForKey:@"Payload"];
                        
                        for (int i = 0; i < Upcoming_Order.count; i++) {
                            [dummy addObject:@"1"];
                        }
                        
                        [_tbl_VC1 reloadData];
                        
                    }else{
                        Upcoming_Order =[[NSMutableArray alloc] init];
                        [CommonFunctions showAlert:@"Looks like you don't have any order"];
                        [_tbl_VC1 reloadData];
                    }
                    
                }
            }
        }
        [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }
                                      withFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error:%@",error.localizedDescription);
                                          NSLog(@"Error Code:%ld",(long)[operation.response statusCode]);
                                          
                                          if (![operation.responseObject objectForKey:@"response"]) {
                                              [CommonFunctions showAlert:@"Please try again"];
                                          }else{
                                              [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
                                          }
                                          [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
                                          [self.navigationController.navigationBar setUserInteractionEnabled:YES];
                                          
                                      }
     ];
}

- (IBAction)btn_Edit_Clicked:(UIButton *)sender {
    
    NSLog(@"%ld",(long)sender.tag);
    
    [appDelegate.checkProductArray removeAllObjects];
    appDelegate.totalPrice = @"";
    NSLog(@"%@",[Upcoming_Order objectAtIndex:sender.tag]);
    
    
    // calculate price
    NSMutableDictionary *editProductDictionary = [Upcoming_Order objectAtIndex:sender.tag];
   
    appDelegate.totalPrice = [NSString stringWithFormat:@"%@",[editProductDictionary valueForKey:@"OrderAmount"]];
    
    // get product list
    if ([[editProductDictionary valueForKey:@"ProductList"] count]>0) {
        for (NSMutableDictionary *dict in [editProductDictionary valueForKey:@"ProductList"]) {
            
            NSMutableArray *productArray = [iofDB getProducts];
            NSString *productID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"ProductId"]];
            
            // filter product on basis of edit product id
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ProductID == %@",productID];
            
            NSMutableArray *filterArray = (NSMutableArray*)[productArray filteredArrayUsingPredicate:predicate];
            NSMutableDictionary *dictProduct = [filterArray objectAtIndex:0];
            [dictProduct setObject:[dict valueForKey:@"Quantity"] forKey:@"productCount"];
            
            // check product alreday add in app delegate dictionary or not
            
             NSMutableArray *filterDuplicateProduct = (NSMutableArray*)[appDelegate.checkProductArray filteredArrayUsingPredicate:predicate];
            
            NSMutableArray *filterProductID = [filterDuplicateProduct valueForKey:@"ProductID"];
            
           
            
            
            NSString *filterID = @"0";
            if ([filterProductID count]>0) {
                filterID = [filterProductID objectAtIndex:0];
            }
           
             if ([appDelegate.checkProductArray count]>0 && [filterID integerValue] == [[dictProduct valueForKey:@"ProductID"] integerValue]){
            
                NSString *productCount = [NSString stringWithFormat:@"%ld",[[dict valueForKey:@"Quantity"] integerValue]+1];
                [dictProduct setObject:productCount forKey:@"productCount"];
                 
                 if ([appDelegate.checkProductArray containsObject:[filterDuplicateProduct objectAtIndex:0]]) {
                     [appDelegate.checkProductArray removeObject:[filterDuplicateProduct objectAtIndex:0]];

                     [appDelegate.checkProductArray addObject:dictProduct];
                 }
            }
            
             else{
                 
            [appDelegate.checkProductArray addObject:dictProduct];
             }
        }
    }
    appDelegate.totalItemCount = 0;
   
   
    [_popup_view setHidden:YES];
    
    NSString *dae_str = [editProductDictionary objectForKey:@"OrderDate"];
    
    NSString *slotDate = [NSString stringWithFormat:@"%@ (%@)",[self UTCDateConversionIntoNSdate:dae_str],[editProductDictionary valueForKey:@"DeliveryTime"]];
    [loginInfo setObject:slotDate forKey:@"slotTime"];
    [kUserDefault setValue:[Utility archiveData:loginInfo] forKey:kLoginInfo];
    
    MyCartViewController *myCartViewController = [self.storyboard instantiateViewControllerWithIdentifier:kMyCartStoryBoardID];
    appDelegate.editMyOrder = kEditMyOrder;
    appDelegate.editProductDictionary = editProductDictionary;
    
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     // kFIRParameterItemID:[NSString stringWithFormat:@"SubCategoryid-%@", [[subCategoryArray objectAtIndex:0]valueForKey:@"CategoryID"]],
                                     kFIRParameterItemName:@"EditCart",
                                     kFIRParameterContentType:@"button"
                                     }];
   
    [self.navigationController pushViewController:myCartViewController animated:YES];
}


-(void)confirmOrder{
    
    int totalPrice =0;
   NSMutableDictionary *editProductDictionary = [Upcoming_Order objectAtIndex:selectedConfirmOrderIndex];
    for(NSMutableDictionary *dict in [editProductDictionary valueForKey:@"ProductList"])
    {
        NSString *price = [dict objectForKey:@"price"];
        int priceValue = [price intValue];
        totalPrice = totalPrice+priceValue;
    }
     appDelegate.totalPrice  = [NSString stringWithFormat:@"%d",totalPrice];
    NSNumber *memID = [loginInfo valueForKey:@"RefMembershipID"];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:memID forKey:@"MembershipId"];
    

    [dict setObject:[editProductDictionary valueForKey:@"OrderId"] forKey:@"OrderId"];
    CollectOrder *placeOrder = [[CollectOrder alloc] initWithDict:dict];
    placeOrder.requestDelegate=self;
    [placeOrder  startAsynchronous];
    
    [Utility ShowMBHUDLoader];
 
}
- (IBAction)btn_Cancel_clicked:(UIButton *)sender {
    [_popup_view setHidden:YES];
     NSMutableDictionary *editProductDictionary = [Upcoming_Order objectAtIndex:sender.tag];
    appDelegate.editProductDictionary = editProductDictionary;

    [self callCancelOrder];
}

-(void)callCancelOrder{
    NSMutableDictionary *dict = [[appDelegate.editProductDictionary valueForKey:@"ProductList"]objectAtIndex:0];
    
    if ([[dict valueForKey:@"OrderType"] isEqualToString:@"O"])
    {
       
        int totalPrice =0;
        NSMutableArray *arr1 = [appDelegate.editProductDictionary objectForKey:@"ProductList"];
        for(NSMutableDictionary *dict in arr1)
        {
            NSString *price = [dict objectForKey:@"price"];
            int priceValue = [price intValue];
            totalPrice = totalPrice+priceValue;
        }

        
        NSNumber *memID = [loginInfo valueForKey:@"RefMembershipID"];

        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"O" forKey:@"OrderType"];
        [dict setObject:[appDelegate.editProductDictionary valueForKey:@"OrderDate"] forKey:@"CancelOrderDate"];
        [dict setObject:[appDelegate.editProductDictionary objectForKey:@"SlotId"] forKey:@"TimeSlotId"];
        [dict setObject:[appDelegate.editProductDictionary valueForKey:@"OrderId"] forKey:@"OrderId"];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:dict];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:memID forKey:@"RefMembershipId"];
        [dic setObject:arr forKey:@"OrderDateList"];
        [dic setObject:@"No" forKey:@"NotificationOff"];
        [dic setObject:[NSNumber numberWithInt:2] forKey:@"OrderCancelTypeId"];
        CancelOrder *cancel = [[CancelOrder alloc] initWithDict:dic];
        cancel.requestDelegate=self;
        [cancel startAsynchronous];
        [Utility ShowMBHUDLoader];
    }
}

#pragma  mark - API
-(void)CancelOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    
    appDelegate.editProductDictionary = nil;
    
    NSString *message = [NSString stringWithFormat:@"%@",[inData valueForKey:@"Message"]];
//     NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:message];
//    
//    MyinfoView  *myView = [[MyinfoView alloc] initWithFrame:CGRectMake(0, 0, 280, 170)];
//    [myView showOneTimeCancelAlertWithTitle:@"Order Cancelled Sucessfully" andMessage:hintText withFram:myView.frame];
//    myView.center=self.view.center;
//    [self.view.window addSubview:myView];
//    [myView toggle];
    
    [Utility showAlertViewControllerIn:self title:@"Order Cancelled Sucessfully" message:message block:^(int index){
        [self Getting_UpcomingOrdersList_Service];

    }];
    
}
-(void)CancelOrderRequestFailedWithErrorMessage:(NSString *)inFailedData
{
    
    [Utility hideMBHUDLoader];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:inFailedData delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

- (void)CollectOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];

     NSMutableDictionary *productDictionary = [Upcoming_Order objectAtIndex:selectedConfirmOrderIndex];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[inData objectForKey:@"Payload"] objectAtIndex:0]];
    [dict setObject:[productDictionary valueForKey:@"MembershipId"] forKey:@"MembershipId"];
    [dict setObject:[productDictionary valueForKey:@"OrderId"] forKey:@"OrderId"];
    [dict setObject:[productDictionary valueForKey:@"OrderNo"] forKey:@"OrderNo"];

    BGOrderSummaryViewController *orderSummaryView = [self.storyboard instantiateViewControllerWithIdentifier:@"orderSummaryViewController"];
    orderSummaryView.summaryDictionary = dict;
    [self.navigationController pushViewController:orderSummaryView animated:YES];
}

-(void)CollectOrderRequestFailedWithErrorMessage:(NSString *)inFailedData{

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popup_view setHidden:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapGuesture_clicked:(UITapGestureRecognizer *)guesture{
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

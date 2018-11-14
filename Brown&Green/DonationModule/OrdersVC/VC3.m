//
//  VC3.m
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "VC3.h"
#import "VC3Cell.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"

@interface VC3 (){
    VC3Cell *cell;
    NSMutableArray * cancel_Order;
    AppDelegate *appDelegate;
    BOOL showHude;

}

@end

@implementation VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showHude = YES;
    cell = (VC3Cell *)[[[NSBundle mainBundle] loadNibNamed:@"VC3Cell" owner:self options:nil] lastObject];
    cancel_Order = [[NSMutableArray alloc] init];
    _tbl_CancellOrder.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    iofDB = [IOFDB sharedManager];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.lbl_Cancel_LastUpdate.text = [NSString stringWithFormat:@"Last update on %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"]];

    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self Getting_CancelOrdersList_Service];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cancel_Order.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell  = (VC3Cell *)[_tbl_CancellOrder dequeueReusableCellWithIdentifier:@"VC3Cell"];
    if (cell == nil) {
        cell = (VC3Cell *)[[[NSBundle mainBundle] loadNibNamed:@"VC3Cell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.btn_ReOrder.tag = indexPath.row;
    [cell.btn_ReOrder addTarget:self action:@selector(btn_Reorder_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lbl_Amount.text = [NSString stringWithFormat:@"%0.2f AUD",[[[cancel_Order objectAtIndex:indexPath.row] objectForKey:@"OrderNetAmount"] floatValue]];
    
    
    NSString * date_sr = [[cancel_Order objectAtIndex:indexPath.row] objectForKey:@"OrderDate"];
    cell.lbl_Date.text =[NSString stringWithFormat:@"Order Id :%@, %@",[[cancel_Order objectAtIndex:indexPath.row] objectForKey:@"OrderId"],[self UTCDateConversionIntoNSdate:date_sr]] ;
    cell.lbl_Time.text = [NSString stringWithFormat:@"%@",[[cancel_Order objectAtIndex:indexPath.row] objectForKey:@"DeliveryTime"]];
  //  cell.btn_ReOrder.hidden = YES;
    
    return cell;
}
//-(NSString *)currenrDate{
//    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"EEEE, MMM YY"];
//     NSString *str_date =[formater stringFromDate:[NSDate date]];
//    return str_date;
//    
//}

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
#pragma mark - UIBUtton Action
-(void)btn_Reorder_clicked:(UIButton *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_CancellOrder];
    NSIndexPath * index = [_tbl_CancellOrder indexPathForRowAtPoint:rootPoint];

    NSMutableDictionary *loginDicationary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
  /*  NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDicationary valueForKey:@"RefMembershipID"]];
    
    NSString *orderId = [[cancel_Order objectAtIndex:index.row] objectForKey:@"OrderId"];
    
    //    NSNumber *memID = [[cancel_Order objectAtIndex:index.row] objectForKey:@"RefMembershipId"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:membershipID forKey:@"memberShipId"];
    [dict setObject:orderId forKey:@"orderId"];
    GetInvoiceDetails *placeOrder = [[GetInvoiceDetails alloc] initWithDict:dict];
    placeOrder.requestDelegate=self;
    [placeOrder startAsynchronous];*/
    
    
    if ([[[cancel_Order objectAtIndex:index.row] objectForKey:@"ProductList"] count]>0) {
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        NSMutableArray *products = [NSMutableArray arrayWithArray:[[cancel_Order objectAtIndex:index.row] objectForKey:@"ProductList"]];
        
        for(NSMutableDictionary *dict in products){
            
           NSMutableDictionary *dic = (NSMutableDictionary*) [NSMutableDictionary dictionaryWithDictionary:dict];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"ProductID",[[dic valueForKey:@"ProductId"] stringValue]];
            NSArray *arr = [iofDB.mArrProducts filteredArrayUsingPredicate:predicate];
            if (arr.count)
            {
                NSMutableDictionary *dicProduct = [NSMutableDictionary dictionaryWithDictionary:[arr firstObject]];
                
                [dicProduct setValue:[NSString stringWithFormat:@"%i %@",[[dic valueForKey:@"Quantity"] intValue]*[[dic valueForKey:@"UnitValue"] intValue],[dic valueForKey:@"UnitName"]] forKey:@"currentQuantity"];
                [dicProduct setValue:[dic valueForKey:@"Quantity"] forKey:@"productCount"];
                
                //                [dicProduct setValue:[dic valueForKey:@"Quantity"] forKey:@"productCount"];
//                [dicProduct setValue:[dicProduct valueForKey:@"Description"] forKey:@"Description"];
//                //[dic setValue:[dicProduct valueForKey:@"SalePrice"] forKey:@"SalePrice"];
//                [dicProduct setValue:[dicProduct valueForKey:@"RefCategoryID"] forKey:@"RefCategoryID"];
//                [dicProduct setValue:[dicProduct valueForKey:@"MaxLimit"] forKey:@"MaxLimit"];
//                [dicProduct setValue:[[dic valueForKey:@"ProductId"] stringValue] forKey:@"ProductID"];
//                [dicProduct setValue:[dic valueForKey:@"ProductHindiName"] forKey:@"HindiName"];
//                [dicProduct setValue:[dic valueForKey:@"UnitName"] forKey:@"unitName"];
//                [dicProduct setValue:[NSString stringWithFormat:@"%i %@",[[dic valueForKey:@"Quantity"] intValue]*[[dic valueForKey:@"UnitValue"] intValue],[dic valueForKey:@"UnitName"]] forKey:@"currentQuantity"];
//                [dicProduct setValue:[dic valueForKey:@"Quantity"] forKey:@"productCount"];
//                
//                [dicProduct setValue:[dic valueForKey:@"UnitValue"] forKey:@"Units"];
//                [dicProduct setValue:[dic valueForKey:@"ProductImage"] forKey:@"ImgName"];
//                [dicProduct setValue:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Quantity"]] forKey:@"items"];
//                [dicProduct removeObjectsForKeys:@[@"ProductHindiName",@"ProductId",@"UntiName",@"Quantity",@"UnitValue",@"ProductImage",@"TotPrice",@" OrderType"]];
                
                [tempArr addObject:dicProduct];

            }
            else{
//                [tempArr addObject:dic];
            }
        }
        
        NSLog(@"%@",tempArr);
        
        
        for(NSMutableDictionary *dic in tempArr){
            [products removeObject:dic];
        }
        
        appDelegate.totalItemCount = 0;
        [Utility hideMBHUDLoader];
        
       appDelegate.totalPrice = [NSString stringWithFormat:@"%@",[[cancel_Order objectAtIndex:index.row] valueForKey:@"OrderAmount"]];
        [appDelegate.checkProductArray removeAllObjects];
        appDelegate.checkProductArray=tempArr;
        appDelegate.editMyOrder = kReOrder;
        
        MyCartViewController *myCartViewController = [self.storyboard instantiateViewControllerWithIdentifier:kMyCartStoryBoardID];
        [self.navigationController pushViewController:myCartViewController animated:YES];
    }
   

}

#pragma mark - Webservices
-(void)Getting_CancelOrdersList_Service{
    NSString *strRequestURL = @"SZOrders.svc/GetCancelledOrder";
    
    NSMutableDictionary *loginDicationary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[loginDicationary valueForKey:@"RefMembershipID"]],@"memberShipId",@"90",@"days",nil];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    if (showHude == YES) {
        [MBProgressHUD showHUDAddedTo:ObjDelegate.window animated:YES];
  
    }
    ConnectionManager *connectionManager = [ConnectionManager sharedInstance];
    [connectionManager startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:strRequestURL withParameters:params withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"%ld",(long)[operation.response statusCode]);
        showHude = NO;
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if ([operation.response statusCode]  == 203){
                [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
                
                return;
            }
            NSDictionary *responseDict = (NSDictionary*) responseObject;
            
            if ([responseDict objectForKey:@"response"] != [NSNull null])
            {
                
                NSString * status = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Status"]];
                NSString * code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Code"]];
                if([operation.response statusCode]  == 200){
                    if ([code isEqualToString:@"OK"] && [status isEqualToString:@"1"]) {
                        //                        NSMutableArray * json_Arr = [[NSMutableArray alloc] init];
                        //                        json_Arr = [responseDict objectForKey:@"Payload"];
                        NSLog(@"json deatils :%@",[responseDict objectForKey:@"Payload"]);
                        cancel_Order = [responseDict objectForKey:@"Payload"];
                        _lbl_Cancel_Descrp.text = [responseDict objectForKey:@"Message"];
                        [_tbl_CancellOrder reloadData];
                        
                    }else{
//                        [CommonFunctions showAlert:[responseObject valueForKey:@"Message"]];
                         [CommonFunctions showAlert:@"Looks like you don't have any order"];
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

-(void) GetInvoiceDetailsRequestFailedWithErrorMessage:(NSString *)inFailedData{
    [Utility hideMBHUDLoader];
}

-(void) GetInvoiceDetailsRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *payLoadArr =[inData objectForKey:@"Payload"];
    NSMutableDictionary *dict = [payLoadArr firstObject];
    NSMutableArray *products =[dict objectForKey:@"Products"];
    
    appDelegate.totalPrice = [NSString stringWithFormat:@"%@",[dict valueForKey:@"OrderNetAmount"]];
    
    for(NSMutableDictionary *dic in products){
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"ProductID",[[dic valueForKey:@"ProductId"] stringValue]];
        NSArray *arr = [iofDB.mArrProducts filteredArrayUsingPredicate:predicate];
        if (arr.count)
        {
            NSMutableDictionary *dicProduct = [arr firstObject];
            [dic setValue:[dicProduct valueForKey:@"Description"] forKey:@"Description"];
            //[dic setValue:[dicProduct valueForKey:@"SalePrice"] forKey:@"SalePrice"];
            [dic setValue:[dicProduct valueForKey:@"RefCategoryID"] forKey:@"RefCategoryID"];
            [dic setValue:[dicProduct valueForKey:@"MaxLimit"] forKey:@"MaxLimit"];
            [dic setValue:[[dic valueForKey:@"ProductId"] stringValue] forKey:@"ProductID"];
            [dic setValue:[dic valueForKey:@"ProductHindiName"] forKey:@"HindiName"];
            [dic setValue:[dic valueForKey:@"UnitName"] forKey:@"unitName"];
            [dic setValue:[NSString stringWithFormat:@"%i %@",[[dic valueForKey:@"Quantity"] intValue]*[[dic valueForKey:@"UnitValue"] intValue],[dic valueForKey:@"UnitName"]] forKey:@"currentQuantity"];
            [dic setValue:[dic valueForKey:@"Quantity"] forKey:@"productCount"];

            [dic setValue:[dic valueForKey:@"UnitValue"] forKey:@"Units"];
            [dic setValue:[dic valueForKey:@"ProductImage"] forKey:@"ImgName"];
            [dic setValue:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Quantity"]] forKey:@"items"];
            [dic removeObjectsForKeys:@[@"ProductHindiName",@"ProductId",@"UntiName",@"Quantity",@"UnitValue",@"ProductImage",@"TotPrice",@" OrderType"]];
        }
        else{
            [tempArr addObject:dic];
        }
    }
    for(NSMutableDictionary *dic in tempArr){
        [products removeObject:dic];
    }
    
    appDelegate.totalItemCount = 0;
    [Utility hideMBHUDLoader];
    
    [appDelegate.checkProductArray removeAllObjects];
    appDelegate.checkProductArray=products;
    appDelegate.editMyOrder = kReOrder;
    
    MyCartViewController *myCartViewController = [self.storyboard instantiateViewControllerWithIdentifier:kMyCartStoryBoardID];
    [self.navigationController pushViewController:myCartViewController animated:YES];
}

@end

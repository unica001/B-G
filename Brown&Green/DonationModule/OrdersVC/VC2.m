//
//  VC2.m
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "VC2.h"
#import "VC2Cell.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"


@interface VC2 (){
    VC2Cell * cell;
    NSMutableArray * delivery_Order;
    AppDelegate *appDelegate;
    
    BOOL showHude;
}

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showHude = YES;
    delivery_Order = [[NSMutableArray alloc]init];
    cell = (VC2Cell *)[[[NSBundle mainBundle] loadNibNamed:@"VC2Cell" owner:self options:nil] lastObject];
    _tbl_DeliveryOrder.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setNeedsStatusBarAppearanceUpdate];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButton;
    }
    
    iofDB = [IOFDB sharedManager];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.lbl_LastUpdate_details.text = [NSString stringWithFormat:@"Last update on %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getting_DeliveryOrders_Service];
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
    return delivery_Order.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell  = (VC2Cell *)[_tbl_DeliveryOrder dequeueReusableCellWithIdentifier:@"VC2Cell"];
    if (cell == nil) {
        cell = (VC2Cell *)[[[NSBundle mainBundle] loadNibNamed:@"VC2Cell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.btn_Invoice.tag = cell.btn_Reorder.tag = indexPath.row;
    [cell.btn_Invoice addTarget:self action:@selector(btn_Invoice_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_Reorder addTarget:self action:@selector(btn_Reorder_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lbl_Amount.text = [NSString stringWithFormat:@"%0.2f AUD",[[[delivery_Order objectAtIndex:indexPath.row] objectForKey:@"OrderNetAmt"] floatValue]];
    cell.lbl_Time.text = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[[delivery_Order objectAtIndex:indexPath.row] objectForKey:@"Deliverytime"] value:@""]];
    
    NSString *stringInvoiceNumber = [Utility replaceNULL:[[delivery_Order objectAtIndex:indexPath.row]valueForKey:@"InvoiceNo"] value:@""];
    
    NSString *dateString = [NSString stringWithFormat:@"%@, %@",stringInvoiceNumber,[self UTCDateConversionIntoNSdate:[[delivery_Order objectAtIndex:indexPath.row] objectForKey:@"OrderDate"]]];
    cell.lbl_Date.text = dateString;
    
    
    return cell;
}
-(NSString *)UTCDateConversionIntoNSdate:(NSString *)currentdate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:currentdate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"EEEE, MMM d"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}
#pragma mark - UIBUtton Action
-(void)btn_Reorder_clicked:(UIButton *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_DeliveryOrder];
    NSIndexPath * index = [_tbl_DeliveryOrder indexPathForRowAtPoint:rootPoint];
    NSLog(@"Re-Order :%lu",index.row);
    
    NSString *orderId = [[delivery_Order objectAtIndex:index.row] objectForKey:@"OrderID"];
    NSNumber *memID = [[delivery_Order objectAtIndex:index.row] objectForKey:@"RefMembershipId"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:memID forKey:@"memberShipId"];
    [dict setObject:orderId forKey:@"orderId"];
    GetInvoiceDetails *placeOrder = [[GetInvoiceDetails alloc] initWithDict:dict];
    placeOrder.requestDelegate=self;
    [placeOrder startAsynchronous];
    
}
-(void)btn_Invoice_clicked:(UIButton *)sender{
    CGPoint center = sender.center;
    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_DeliveryOrder];
    NSIndexPath * index = [_tbl_DeliveryOrder indexPathForRowAtPoint:rootPoint];

    NSString*urlString = [[delivery_Order objectAtIndex:index.row] valueForKey:@"pdfInvoice"];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
}
-(NSString *)currenrDate{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"EEEE, MMM d"];
    NSString *str_date =[formater stringFromDate:[NSDate date]];
    return str_date;
    
}
#pragma mark - Webservices
//SZOrders.svc/GetInvoiceByUserV2
-(void)getting_DeliveryOrders_Service{
    NSString *strRequestURL = @"SZOrders.svc/GetInvoiceByUserV2";
    NSMutableDictionary *loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"RefMembershipID"]];

    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:membershipID,@"memberShipId",@"90",@"days",nil];
    
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
                [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
                
                return;
            }
            NSDictionary *responseDict = (NSDictionary*) responseObject;
            
            if ([responseDict objectForKey:@"response"] != [NSNull null])
            {
                NSString * status = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Status"]];
                NSString * code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Code"]];
                
                if([operation.response statusCode]  == 200){
                    if ([code isEqualToString:@"OK"] && [status isEqualToString:@"1"]) {
                        NSLog(@"json deatils :%@",[responseDict objectForKey:@"Payload"]);
                        delivery_Order = [responseDict objectForKey:@"Payload"];
                        _lbl_Delivery_Descrp.text = [responseDict objectForKey:@"Message"];
                        [_tbl_DeliveryOrder reloadData];
                        
                    }else{
                      //  [CommonFunctions showAlert:[responseObject valueForKey:@"Message"]];
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
    
    // price calculation
    
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
            
            [dic setValue:[dic valueForKey:@"Quantity"] forKey:kproductCount];
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

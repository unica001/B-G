//
//  KarmaPointsVC.m
//  Video
//
//  Created by Anand on 09/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "KarmaPointsVC.h"
#import "MyDonaitonCell.h"
#import "SwipeVC.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"



@interface KarmaPointsVC (){
    MyDonaitonCell * cell;
    NSMutableArray * karma_arr;
    NSInteger deleteRowAtIndex;
    NSMutableDictionary *loginDictionary;
}

@end

@implementation KarmaPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Karma";
    karma_arr = [[NSMutableArray alloc] init];
    cell = (MyDonaitonCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyDonaitonCell" owner:self options:nil] lastObject];
    _tbl_Karma.rowHeight = UITableViewAutomaticDimension;
    _tbl_Karma.estimatedRowHeight = 250;
    _tbl_Karma.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    [self setNeedsStatusBarAppearanceUpdate];
        
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButton;
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    deleteRowAtIndex = -1;
    [self getting_MyDonationDetails];


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
    return karma_arr .count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell  = (MyDonaitonCell *)[_tbl_Karma dequeueReusableCellWithIdentifier:@"ThankyouCell"];
    if (cell == nil) {
        cell = (MyDonaitonCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyDonaitonCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    cell.btn_Cancel.tag = indexPath.row;
    [cell.btn_Cancel addTarget:self action:@selector(cancelButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.lbl_OrderID.text = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"OrderId"]];
    cell.lbl_Date.text =[NSString stringWithFormat:@"%@",[self UTCDateConversionIntoNSdate:[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"OrderDate"]]];
    cell.lbl_Time.text = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"PickupTime"]];
    
    

    
    
    // location label Height
    NSString *address = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"Address"]];
    
    cell.locationLabelHeight.constant = [Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth-89, CGFLOAT_MAX) font:kDefaultFontForApp];
    cell.lbl_Location.text = address;

    
    if ([[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"ProductList"] count] != 0) {
        
        NSArray * str_arr = [[karma_arr objectAtIndex:indexPath.row] objectForKey:@"ProductList"];
        NSMutableString *result_str = [[NSMutableString alloc] init];
        for (NSDictionary *dic in str_arr) {
            [result_str appendString:[NSString stringWithFormat:@"%@ - %@ %@\n",[dic objectForKey:@"ProductName"],[dic objectForKey:@"Quantity"],[dic objectForKey:@"UnitName"]]];
        }
       // product label height
      cell.productLableHeight.constant = [Utility getTextHeight:result_str size:CGSizeMake(kiPhoneWidth-94, CGFLOAT_MAX) font:kDefaultFontForApp];
        
        cell.lbl_ProductList.text = result_str;
    }

  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0;
    NSString *address = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"Address"]];
    
    if ([Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth-89, CGFLOAT_MAX) font:kDefaultFontForApp]>20) {
     height =  [Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth-89, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    else{
        height = 20;
    }
    
    if ([[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"ProductList"] count] != 0) {
        
        NSArray * str_arr = [[karma_arr objectAtIndex:indexPath.row] objectForKey:@"ProductList"];
        NSMutableString *result_str = [[NSMutableString alloc] init];
        for (NSDictionary *dic in str_arr) {
            [result_str appendString:[NSString stringWithFormat:@"%@ - %@ %@\n",[dic objectForKey:@"ProductName"],[dic objectForKey:@"Quantity"],[dic objectForKey:@"UnitName"]]];
        }
        // product label height
    height = [Utility getTextHeight:result_str size:CGSizeMake(kiPhoneWidth-94, CGFLOAT_MAX) font:kDefaultFontForApp]+height;
    }
    else{
        height = 20+height;
    }
    
    return 140+height;
}


#pragma mark - UIButton Action
-(void)cancelButton_clicked:(UIButton *)sender{
    
//    CGPoint center = sender.center;
//    CGPoint rootPoint  = [sender convertPoint:center toView:_tbl_Karma];
//    NSIndexPath * index = [_tbl_Karma indexPathForRowAtPoint:rootPoint];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:_tbl_Karma];
    NSIndexPath *index = [_tbl_Karma indexPathForRowAtPoint:buttonPosition];
    
   
    NSLog(@"indexpath :%lu",index.row);
    deleteRowAtIndex = index.row;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Brown & Greens" message:@"Are you sure you want to cancel your offering?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self cancel_DonationOrder_Service];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];

    [self presentViewController:alert animated:true completion:nil];

    
}
#pragma mark - UTC Time Conversion
-(NSString *)UTCDateConversionIntoNSdate:(NSString *)currentdate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:currentdate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}
#pragma mark - Webservice
-(void)getting_MyDonationDetails{
    NSString *strRequestURL = @"SZDonationOrders.svc/GetMyDonationOrders";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    //[params setObject:@"16" forKey:@"MembershipId"];
    NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"RefMembershipID"]];
    
    [params setObject:membershipID forKey:@"MembershipId"];
    
    
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
                        karma_arr = [NSMutableArray arrayWithArray:[responseDict objectForKey:@"Payload"]];
                        [_tbl_Karma reloadData];
                    }else{
                        [CommonFunctions showAlert:@"Currenlty you have no Karma"];
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
//DonationOrders.svc/DonationCancelOrders

-(void)cancel_DonationOrder_Service{
    NSString *strRequestURL = @"SZDonationOrders.svc/DonationCancelOrders";
//http://staging.sirez.com/BrownAndGreens/FeederREST/SZDonationOrders.svc/DonationCancelOrders

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   NSMutableDictionary *loginInfo  = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSNumber *memID = [loginInfo valueForKey:@"RefMembershipID"];
    [params setObject:memID forKey:@"MembershipId"];

    [params setObject:[[karma_arr objectAtIndex:deleteRowAtIndex] objectForKey:@"OrderId"] forKey:@"OrderID"];
    
    
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
                
                return;
            }
            NSDictionary *responseDict = (NSDictionary*) responseObject;
            
            if ([responseDict objectForKey:@"response"] != [NSNull null])
            {
                if([operation.response statusCode]  == 200){
                    if ([[responseObject valueForKey:@"Code"] isEqualToString:@"OK"]) {
                        NSLog(@"json deatils :%@",[responseDict objectForKey:@"Message"]);
                        [CommonFunctions showAlert:[responseDict objectForKey:@"Message"]];
                        [karma_arr removeObjectAtIndex:deleteRowAtIndex];
                        [_tbl_Karma reloadData];
                    }else{
                        [CommonFunctions showAlert:[responseObject valueForKey:@"message"]];
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
- (IBAction)btn_Next_Clicked:(UIButton *)sender {
    SwipeVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
    [self.navigationController pushViewController:obj animated:YES];

}

- (IBAction)btn_Back_Clicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

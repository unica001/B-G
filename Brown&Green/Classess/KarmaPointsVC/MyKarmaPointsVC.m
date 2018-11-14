//
//  MyKarmaPointsVC.m
//  Brown&Green
//
//  Created by Anand on 16/05/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "MyKarmaPointsVC.h"
#import "MyKarmaPointsCell.h"

@interface MyKarmaPointsVC (){
    NSMutableDictionary *loginDictionary;
    MyKarmaPointsCell *cell;
    NSMutableArray * karma_arr;
}

@end

@implementation MyKarmaPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    karma_arr = [[NSMutableArray alloc] init];
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    _tbl_Karma.rowHeight = UITableViewAutomaticDimension;
    _tbl_Karma.estimatedRowHeight = 250;
    
    if ([loginDictionary valueForKey:@"TotalKarmaPoint"]) {
     _lbl_TotalKarmaPoints.text = [NSString stringWithFormat:@"Total Points Earned (%0.1f)",[[loginDictionary valueForKey:@"TotalKarmaPoint"] floatValue]];
    }
    
    
       SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButton;
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.title = @"Karma points";

    [self Getting_Productlist_Service];
    self.navigationController.navigationBarHidden = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return karma_arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell  = (MyKarmaPointsCell *)[_tbl_Karma dequeueReusableCellWithIdentifier:@"MyKarmaPointsCell"];
    if (cell == nil) {
        cell = (MyKarmaPointsCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyKarmaPointsCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.lbl_OrderID.text = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"OrderId"]];
    cell.lbl_Time.text = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"PickupTime"]];
    NSString * date = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"OrderDate"]];
    cell.lbl_Date.text = [self UTCDateConversionIntoNSdate:date];
    cell.lbl_Location.text = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"Address"]];
    cell.lbl_EarnedPoints.text = [NSString stringWithFormat:@"%@",[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"PointEarned"]];
    
    if ([[[karma_arr objectAtIndex:indexPath.row] objectForKey:@"ProductList"] count] != 0) {
        NSArray * str_arr = [[karma_arr objectAtIndex:indexPath.row] objectForKey:@"ProductList"];
        NSMutableString *result_str = [[NSMutableString alloc] init];
        for (NSDictionary *dic in str_arr) {
            [result_str appendString:[NSString stringWithFormat:@"%@ - %@ %@\n",[dic objectForKey:@"ProductName"],[dic objectForKey:@"Quantity"],[dic objectForKey:@"UnitName"]]];
        }
         cell.lbl_Product.text = result_str;
    }
    
    return cell;
}
#pragma mark - UTC Time Conversion
-(NSString *)UTCDateConversionIntoNSdate:(NSString *)currentdate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:currentdate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"EEEE,MM YY"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}
#pragma mark - Webservice
-(void)Getting_Productlist_Service{
    NSString *strRequestURL = @"SZDonationOrders.svc/GetPointEarned";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"RefMembershipID"]];
    [params setObject:membershipID forKey:@"MembershipId"];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    [MBProgressHUD showHUDAddedTo:ObjDelegate.window animated:YES];
    ConnectionManager *connectionManager = [ConnectionManager sharedInstance];
    [connectionManager startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:strRequestURL withParameters:params withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"%ld",(long)[operation.response statusCode]);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if ([operation.response statusCode]  == 203){
             //   [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
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
                       // [CommonFunctions showAlert:[responseObject valueForKey:@"Message"]];
                    }
                    
                }
            }
        }
        [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
    }
                                      withFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error:%@",error.localizedDescription);
                                          NSLog(@"Error Code:%ld",(long)[operation.response statusCode]);
                                          
                                          if (![operation.responseObject objectForKey:@"response"]) {
                                             // [CommonFunctions showAlert:@"Please try again"];
                                          }else{
                                            //  [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
                                          }
                                          [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
                                          
                                      }
     ];
}

-(void)getting_karmaPoints_Service{
    NSString *strRequestURL = @"SZCustomers.svc/GetMyCreditDetails";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"RefMembershipID"]];
    [params setObject:membershipID forKey:@"MembershipId"];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    [MBProgressHUD showHUDAddedTo:ObjDelegate.window animated:YES];
    ConnectionManager *connectionManager = [ConnectionManager sharedInstance];
    [connectionManager startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:strRequestURL withParameters:params withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"%ld",(long)[operation.response statusCode]);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if ([operation.response statusCode]  == 203){
              //  [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
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
                    _lbl_TotalKarmaPoints.text = [NSString stringWithFormat:@"Total Points Earned(%0.1f)",[[[responseDict objectForKey:@"Payload"] objectForKey:@"TotalKarmaPoint"] floatValue]];
                    }else{
                       // [CommonFunctions showAlert:[responseObject valueForKey:@"Message"]];
                    }
                    
                }
            }
        }
        [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
    }
                                      withFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error:%@",error.localizedDescription);
                                          NSLog(@"Error Code:%ld",(long)[operation.response statusCode]);
                                          
                                          if (![operation.responseObject objectForKey:@"response"]) {
                                            //  [CommonFunctions showAlert:@"Please try again"];
                                          }else{
                                         //     [CommonFunctions showAlert:[operation.responseObject objectForKey:@"response"]];
                                          }
                                          [MBProgressHUD hideHUDForView:ObjDelegate.window animated:YES];
                                          
                                          
                                      }
     ];
}
- (IBAction)donateMoreButton_clicked:(id)sender {
    
    [self performSegueWithIdentifier:kDonateVCSegueIdentifier sender:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDonateVCSegueIdentifier]) {
        TestingVC *donateViewController = segue.destinationViewController;
        donateViewController.incomingViewType = kfromKramPoint;
    }
}
@end

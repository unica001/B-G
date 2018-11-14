//
//  VC4.m
//  Video
//
//  Created by Anand on 01/05/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "VC4.h"
#import "ThankyouCell.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"

@interface VC4 (){
    ThankyouCell * cell;
    NSArray * Account_Summary_arr;
    BOOL showHude;
}

@end

@implementation VC4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showHude = YES;
    cell = (ThankyouCell *)[[[NSBundle mainBundle] loadNibNamed:@"ThankyouCell" owner:self options:nil] lastObject];
    //    Account_Summary_arr =@[@{@"name":@"Total Order Delivery"}, @{@"name":@"Total Order Value"},@{@"name":@"Amount Paid"},@{@"name":@"Cash Balance(to be used by user)"}];
    _tbl_VC4.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.lbl_LastUpdate.text = [NSString stringWithFormat:@"Last update on %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getting_AccountSummaryDetail_Service];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _tbl_VC4.contentSize = CGSizeMake(self.view.frame.size.width, 80*6);
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
    return Account_Summary_arr .count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell  = (ThankyouCell *)[_tbl_VC4 dequeueReusableCellWithIdentifier:@"ThankyouCell"];
    if (cell == nil) {
        cell = (ThankyouCell *)[[[NSBundle mainBundle] loadNibNamed:@"ThankyouCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

  
    
    
    if (Account_Summary_arr.count>0) {
        NSString *orderID = [[Account_Summary_arr objectAtIndex:indexPath.row] valueForKey:@"$id"];
        
        if ([orderID integerValue] ==1 ||[orderID integerValue] ==2 || [orderID integerValue] ==3||[orderID integerValue] ==5) {
            cell.hidden = NO;
        }
        else{
            cell.hidden = YES;
        }
    }
    
    cell.lbl_Value.text = [NSString stringWithFormat:@"%@ %@",[[Account_Summary_arr objectAtIndex:indexPath.row] objectForKey:@"OrderValue"],@"AUD"];
    
    if (indexPath.row ==0) {
       cell.lbl_Title.text = @"Total Order Delivery";
        cell.lbl_Value.text = [NSString stringWithFormat:@"%@",[[Account_Summary_arr objectAtIndex:indexPath.row] objectForKey:@"OrderValue"]];
    }
    else if (indexPath.row ==1) {
       cell.lbl_Title.text = @"Total Order Value";

    }
    else if (indexPath.row ==2) {
        cell.lbl_Title.text = @"Amount Paid";

    }
    else if (indexPath.row ==4) {
        cell.lbl_Title.text = @"Account Balance(to be used by user)";
  
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (Account_Summary_arr.count>0) {
         NSString *orderID = [[Account_Summary_arr objectAtIndex:indexPath.row] valueForKey:@"$id"];
        
        if ([orderID integerValue] ==1 ||[orderID integerValue] ==2 || [orderID integerValue] ==3||[orderID integerValue] ==5) {
            return 50;
        }
    }
  
    return 0;
}
#pragma mark - Webservices
-(void)getting_AccountSummaryDetail_Service{
    NSString *strRequestURL = @"SZCustomers.svc/GetCustomerAccountSummary";
    
    NSMutableDictionary *loginDicationary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%@",[loginDicationary valueForKey:@"RefMembershipID"]] forKey:@"MembershipId"];
    
    
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
               
                        NSLog(@"json deatils :%@",[responseDict objectForKey:@"Payload"]);
                        Account_Summary_arr = [responseDict objectForKey:@"Payload"];
                     //   _lbl_Account_Descrp.text = [responseDict objectForKey:@"Message"];
                        [_tbl_VC4 reloadData];
                    }else{
                        [CommonFunctions showAlert:[responseObject valueForKey:@"Message"]];
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
@end

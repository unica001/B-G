//
//  DonateVC.m
//  Video
//
//  Created by VMK IT Services on 5/5/17.
//  Copyright © 2017 Provab. All rights reserved.
//

#import "DonateVC.h"
#import "TestingVC.h"
#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"
#import "ThankYouVC.h"
#import "DonateCell.h"

@interface DonateVC (){
    NSDate *date;
    NSInteger TimeSlotId,selectedRowAtIndex;
    DonateCell * cell;
    NSMutableArray * json_Arr,*timeSlot_Arr;
}
//@property (copy,nonatomic) NSArray *timeSlot_Arr ;
@end

@implementation DonateVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Karma";
    json_Arr = [[NSMutableArray alloc] init];
    timeSlot_Arr = [[NSMutableArray alloc] init];
    [self hideDatePicker];
  //  [_txt_Location addTarget:self action:@selector(location_Clicked:) forControlEvents:UIControlEventEditingDidEnd];
    _lbl_Date.layer.cornerRadius = 3.0f;
    _lbl_Date.layer.borderWidth = 0.5f;
    _lbl_Date.layer.borderColor = [UIColor lightGrayColor].CGColor;

    cell = (DonateCell *)[[[NSBundle mainBundle] loadNibNamed:@"DonateCell" owner:self options:nil] lastObject];
    [self setNeedsStatusBarAppearanceUpdate];
   /* SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButton;
    }*/
    
    
    // set user location fill on registration time
    
    NSMutableDictionary *loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *address = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[loginInfo valueForKey:kAddress1] value:@""]];
    address = [address stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    NSString *locality = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[loginInfo valueForKey:@"Location"] value:@""]];
     locality = [locality stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    NSString *city = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[loginInfo valueForKey:@"CityName"] value:@""]];
     city = [city stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    self.textView.text = [NSString stringWithFormat:@"%@ %@ %@",address,locality,city];
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius =  5.0;
    [self.textView.layer setMasksToBounds:YES];
    
    
    
    NSMutableArray *productList = [NSMutableArray arrayWithArray:[ConfigDelegate getValueForArrayKey:FINAL_DONATIONLIST]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[productList objectAtIndex:0]];
    
    NSString *incomingView = [Utility replaceNULL:[kUserDefault valueForKey:kGuestUserInComingScreen] value:@""];
    
    if ([incomingView isEqualToString:@"donate"]) {
        
        [kUserDefault setValue:@"" forKey:kGuestUserInComingScreen];
        [ConfigDelegate setStringForArray:[NSMutableArray arrayWithObject:dict] forKey:FINAL_DONATIONLIST];
        
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [dateFormatter dateFromString:[dict valueForKey:@"orderDate"]];
        
        [dateFormatter setTimeZone:timeZone];
        dateFormatter.dateFormat = @"d MMMM, YYYY";
        _lbl_Date.text = [dateFormatter stringFromDate:date];
        
        self.textView.text =  [dict valueForKey:@"Address"];
        TimeSlotId = [[dict valueForKey:@"TimeSlotId"] integerValue];
        
    }
    else{
        _lbl_Date.text = @"";
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBarHidden = false;
    selectedRowAtIndex = -1;
    TimeSlotId = 0;
     [_popup_View setHidden:YES];
    [self gettingTimeslotDetails];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark -
-(void)location_Clicked:(UITextField *)sender{
   // _txt_Location.text = sender.text;
}

#pragma mark - UITableView Delgate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return timeSlot_Arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell    = (DonateCell *)[_tbl_TimeSlot dequeueReusableCellWithIdentifier:@"DonateCell"];
    if (cell == nil) {
        cell = (DonateCell *)[[[NSBundle mainBundle] loadNibNamed:@"DonateCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.btn_Selection.tag = indexPath.row;
    [cell.btn_Selection addTarget:self action:@selector(btn_timeSlot_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.lbl_Time.text = [[timeSlot_Arr objectAtIndex:indexPath.row] objectForKey:@"DeliverySlot"];

    
    if (selectedRowAtIndex == indexPath.row) {
        cell.btn_Selection.selected = true;
    }else{
        cell.btn_Selection.selected = false;
    }
        
    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     selectedRowAtIndex = indexPath.row;
//    [_tbl_TimeSlot reloadData];
//}
#pragma mark - UIButton Action
-(void)btn_timeSlot_Clicked:(UIButton *)sender{
    CGPoint point = sender.center;
    CGPoint rootPoint = [sender convertPoint:point toView:_tbl_TimeSlot];
    NSIndexPath *indexPath =[_tbl_TimeSlot indexPathForRowAtPoint:rootPoint];
    NSLog(@"index :%ld",indexPath.row);
    selectedRowAtIndex = indexPath.row;
    NSDictionary *dict  = [timeSlot_Arr objectAtIndex:selectedRowAtIndex];
    TimeSlotId = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"DeliverySlotId"]] intValue];
    
    [_tbl_TimeSlot reloadData];
}

- (IBAction)btn_OK_Clicked:(UIButton *)sender {
    [_popup_View setHidden:YES];
}

- (IBAction)btn_DatePicker_Clicked:(UIButton *)sender {

    [self showDatePicker];
}
- (void)showDatePicker{
    [self.view endEditing:YES];
    [_pickerView setHidden:NO];
}

- (void)hideDatePicker{
    [_pickerView setHidden:YES];
    
}
- (IBAction)btn_Back_Clicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSDateComponents *)gettingHourAndMinute{

    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
    return components;
}
- (IBAction)btn_Confirm_Clicked:(UIButton *)sender {
    [self.view endEditing:YES];

    NSString *guestUser = [Utility replaceNULL:[kUserDefault valueForKey:kGuestUser] value:@""];
    if ([guestUser isEqualToString:kGuestUser]) {
        
        [kUserDefault setValue:@"donate" forKey:kGuestUserInComingScreen];
        NSMutableArray *productList = [NSMutableArray arrayWithArray:[ConfigDelegate getValueForArrayKey:FINAL_DONATIONLIST]];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[productList objectAtIndex:0]];
        
        [dic setValue:[NSString stringWithFormat:@"%ld",TimeSlotId] forKey:@"TimeSlotId"];
        [dic setValue:self.textView.text forKey:@"Address"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dic setValue:[dateFormatter stringFromDate:date] forKey:@"orderDate"];
        [dic setValue:@"fromView" forKey:@"fromView"];

        [ConfigDelegate setStringForArray:[NSMutableArray arrayWithObject:dic] forKey:FINAL_DONATIONLIST];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        BGSignInViewController *signInViewController = [storyBoard instantiateViewControllerWithIdentifier:@"signViewStoryBoardId"];
        [self.navigationController pushViewController:signInViewController animated:YES];
    }
    else{
        if ([self validation]) {
            
            NSMutableDictionary *loginDicationary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
            NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDicationary valueForKey:@"RefMembershipID"]];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:[NSString stringWithFormat:@"%ld",TimeSlotId] forKey:@"TimeSlotId"];
            NSMutableArray *productList = [NSMutableArray arrayWithArray:[ConfigDelegate getValueForArrayKey:FINAL_DONATIONLIST]];
            
            NSMutableArray *temp = [[NSMutableArray alloc]init];
            
            for (NSMutableDictionary *dict in productList) {
                NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
                [dictTemp setObject:[dict valueForKey:@"QuantityId"] forKey:@"Quantity"];
                [dictTemp setObject:[dict valueForKey:@"UinitId"] forKey:@"UntiId"];
                [dictTemp setObject:[dict valueForKey:@"ProductId"] forKey:@"ProductId"];
                [temp addObject:dictTemp];
            }
            
            [params setObject:temp forKey:@"ProductList"];
            [params setObject:@"" forKey:@"DeviceInfo"];
            [params setObject:@"2.0" forKey:@"AppVersion"];
            [params setObject:membershipID forKey:@"refMembershipId"];
            [params setObject:self.textView.text forKey:@"Address"];
            NSString *date_str = [self getUTCFormateDate:date];
            [params setObject:date_str forKey:@"orderDate"];
            [self sending_DonationOrder_Details:params];
        }
    }

}

- (BOOL)validation{
    
    if([_lbl_Date.text length] == 0){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please select Date" block:^(int index) {
            
        }];
        return false;
    }
    else  if([self.textView.text length] == 0){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please select Location" block:^(int index) {
            
        }];
        return false;
    }
    
    
    else if(TimeSlotId == 0){
        [Utility showAlertViewControllerIn:self title:BGError message:@"Please select Time Slot" block:^(int index) {
            
        }];
        return false;
    }
    
    return true;
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
     NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    // or Timezone with specific name like
    // [NSTimeZone timeZoneWithName:@"Europe/Riga"] (see link below)
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
      return dateString;
}
- (IBAction)btn_Done_Clicked:(UIButton *)sender {
    date = _date_Picker.date;
    TimeSlotId = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"d MMMM, YYYY";
    NSString *stringFromDate = [formatter stringFromDate:date];
    //  NSLog(@"Done value: %@",stringFromDate);
    _lbl_Date.text = stringFromDate;
    
    [self getting_TimeSlotsDetails_ForSelectedDate:json_Arr withDate:date];
    [self hideDatePicker];
}

- (IBAction)btn_Cancel:(UIButton *)sender {
    [self hideDatePicker];
}

- (IBAction)pickerValueChanged:(UIDatePicker *)sender {
    date = _date_Picker.date;

}
#pragma mark -webservices
-(void)sending_DonationOrder_Details:(NSMutableDictionary *)params{
    NSString *strRequestURL = @"SZDonationOrders.svc/AddDonationOrderDetails";

    
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
                        NSMutableArray * response_arr = [[NSMutableArray alloc] init];
                        response_arr = [responseDict objectForKey:@"Payload"];
                        NSLog(@"json deatils :%@",response_arr);
                        
                        ThankYouVC * obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouVC"];
                        [self.navigationController pushViewController:obj animated:YES];
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
-(void)gettingTimeslotDetails{
    NSString *strRequestURL = @"SZDonationOrders.svc/GetDonationTimeslot";
    
    //    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"",nil];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    [MBProgressHUD showHUDAddedTo:ObjDelegate.window animated:YES];
    ConnectionManager *connectionManager = [ConnectionManager sharedInstance];
    [connectionManager startRequestWithHttpMethod:kHttpMethodTypeGet withHttpHeaders:headers withServiceName:strRequestURL withParameters:nil withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                        json_Arr = [[NSMutableArray alloc] init];
                        json_Arr = [responseObject objectForKey:@"Payload"];
                        
                        [self getting_TimeSlotsDetails_ForSelectedDate:json_Arr withDate:[NSDate date]];
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
-(void)getting_TimeSlotsDetails_ForSelectedDate:(NSMutableArray *)Json_Response withDate:(NSDate *)selectedDate{
    
    NSMutableArray *response_Arr = [NSMutableArray arrayWithArray:Json_Response];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd-YYYY";
    NSString *stringFromDate = [formatter stringFromDate:selectedDate];
    
    BOOL hasCurrentTimeSlot = false;
  //  NSDictionary * currentDay_timeSlot_Dict;
  //  NSInteger setDate;
    [_popup_View setHidden:YES];
    for (NSDictionary *dict  in response_Arr) {
        NSString * str = [dict objectForKey:@"DeliveryDate"];
        if ([stringFromDate isEqualToString:str]) {
            if (![[dict objectForKey:@"Holiday"] isEqualToString:@""]) {
                _lbl_Holiday_Descp.text = [NSString stringWithFormat:@"Sorry, Donations are suspendd on your selected date due to %@. Please select an alternate date for your order delivery.",[dict objectForKey:@"Holiday"]];
                [_popup_View setHidden:NO];
                [self settingTimeSlots:dict andHolidayStatus:hasCurrentTimeSlot];
                hasCurrentTimeSlot = true;
                return;
            }else{
                hasCurrentTimeSlot = false;
                [self settingTimeSlots:dict andHolidayStatus:hasCurrentTimeSlot];
            }

        }
//        currentDay_timeSlot_Dict = dict;
    }

  
}
-(void)settingTimeSlots:(NSDictionary *)timeSlots_dict andHolidayStatus:(BOOL)isHoliday{
    NSInteger setDate;

    if (!isHoliday) {
        setDate = 0;
    }else{
        setDate = 1;

    }
    timeSlot_Arr = [NSMutableArray arrayWithArray:[timeSlots_dict objectForKey:@"DeliveryTimeSlot"]];
    selectedRowAtIndex = -1;
    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:setDate];
    NSDate *minDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setDay:7];
    NSDate *maxDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:minDate options:0];
    [_date_Picker setMinimumDate:minDate];
    [_date_Picker setMaximumDate:maxDate];
    
    [_tbl_TimeSlot reloadData];
}
@end

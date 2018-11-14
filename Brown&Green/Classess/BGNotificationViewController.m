//
//  TRLNotificationViewController.m
//  TRLUser
//
//  Created by vineet patidar on 16/02/17.
//  Copyright © 2017 Jitender. All rights reserved.
//

#import "BGNotificationViewController.h"
#import "NotificationCell.h"

@interface BGNotificationViewController (){
    NSMutableDictionary *loginDictionary;
}
@end

@implementation BGNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Notifications";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [_menuButton setTarget: self.revealViewController];
            [_menuButton setAction: @selector( revealToggle: )];
            
        }
    }
    self.revealViewController.delegate = self;
    
     loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
   // [self getNotifiationList:YES];

    self.revealViewController.delegate = self;
    
    _notificationView.hidden = YES;
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    self.navigationController.navigationBarHidden = NO;

    [self.notificationArray removeAllObjects];
    IOFDB *iofDB = [IOFDB sharedManager];
    
    [self getNotificationDataSource];
//    self.notificationArray= [iofDB getNotification];
    
 
}

-(void) getNotificationDataSource
{
    
    NSString *syncDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSynchDate"];
    NSNumber *memID = [loginDictionary objectForKey:@"RefMembershipID"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    

    if (syncDate==nil)
    {
        [dict setObject:@"2017-05-03 18:52:24.830" forKey:@"filterDate"];
    }
    else{
        [dict setValue:syncDate forKey:@"filterDate"];
    }
    
    [dict setObject:memID forKey:@"MembershipId"];
    GetNotification *noti = [[GetNotification alloc] initWithDict:dict];
    noti.requestDelegate=self;
    [noti startAsynchronous];
    [Utility ShowMBHUDLoader];
}
-(void) GetNotificationFinishedWithSuccessMessage:(NSMutableDictionary *)inData
{
    [Utility hideMBHUDLoader];
    
    NSMutableArray *inerDataArr = [inData objectForKey:@"innerData"];
    if ([inerDataArr isKindOfClass:[NSArray class]] ) {
        NSMutableDictionary *dic= [inerDataArr firstObject];
        self.notificationArray = [dic objectForKey:@"NotificationDetails"];
        lastSyncDate = [inData objectForKey:@"CurrentDate"];
        [[NSUserDefaults standardUserDefaults] setValue:lastSyncDate forKey:@"lastSynchDate"];
    }
    
    if (self.notificationArray.count > 0) {
        [[IOFDB sharedManager] deleteAllNotifications];
        [[IOFDB sharedManager] insertNotification:self.notificationArray];
    }
    
    self.notificationArray = [[IOFDB sharedManager] getNotification];
    
    if ((self.notificationArray.count>0)) {
        _notificationView.hidden = YES;
    }
    else{
       _notificationView.hidden = NO;

    }

    [_tableView reloadData];
    
}

-(void) GetNotificationtFailedWithErrorMessage:(NSString *)inFailedData
{
    [Utility hideMBHUDLoader];
}

#pragma mark - Table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_notificationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!(_notificationArray.count>0)) {
        return nil;
    }
    
    static NSString *cellIdentifier = @"notificationCell";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *notificationText = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[[_notificationArray objectAtIndex:indexPath.row] valueForKey:kNotificationMsg] value:@""]];
    notificationText = [notificationText stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    cell.notificationTextHeight.constant =[Utility getTextHeight:notificationText size:CGSizeMake(kiPhoneWidth-40, CGFLOAT_MAX) font:kDefaultFontForApp];
    
    cell.notificationTextLabel.text = notificationText;
    
    cell.dateLabel.text = [Utility replaceNULL:@"" value:[self dateFormate:[[[_notificationArray objectAtIndex:indexPath.row] valueForKey:kCreatedOn] doubleValue]]];
    
    
    cell._bullateLabel.layer.cornerRadius = cell._bullateLabel.frame.size.width/2;
    [cell._bullateLabel.layer setMasksToBounds:YES];
    

    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([[[_notificationArray objectAtIndex:indexPath.row] valueForKey:kReadStatus] integerValue] == 0) {
//       [self changeStatusOfNotification:YES dictionary:[_notificationArray objectAtIndex:indexPath.row] mode:@"update"];
//    }
//    
    
}

-(NSString *)dateFormate:(double)interval{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss z"];
    
    NSString * dateString = [formatter stringFromDate:date];
    
    date = [formatter dateFromString:dateString];
    // converting into our required date format
    [formatter setDateFormat:@"d-MMM-yyyy HH:mm"];
    NSString *reqDateString = [formatter stringFromDate:date];
    
    return reqDateString;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  NSString *notificationText = [NSString stringWithFormat:@"%@",[[_notificationArray objectAtIndex:indexPath.row] valueForKey:kNotificationMsg]];
    
    if ( [Utility getTextHeight:notificationText size:CGSizeMake(kiPhoneWidth -40, CGFLOAT_MAX) font:kDefaultFontForApp] >28) {
        
        return 40 + [Utility getTextHeight:notificationText size:CGSizeMake(kiPhoneWidth -40, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIs call

/****************************
 * Function Name : - getMerchantReview
 * Create on : - 8 feb 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This funtion are used for get merchant review
 * Organisation Name :- Sirez
 * version no :- 1.0
 ***************************
-(void)getNotifiationList:(BOOL)showHude{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNo];
    [dictionary setValue:kPageNumber forKey:kPageSize];
    [dictionary setValue:[loginDictionary valueForKey:kUserId] forKey:kUserId];
    [dictionary setValue:@"U" forKey:kUserType];

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"notificationListForMerchant"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (showHude == NO) {
                    _tableView.tableFooterView  = nil;
                    
                }
                
                // check login steps
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    totalRecord = [[[dictionary valueForKey:kAPIPayload] valueForKey:kTotal] intValue];
                    
                    NSString *totalUnread = [[dictionary valueForKey:kAPIPayload] valueForKey:kTotalUnread];
                    
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[totalUnread integerValue]];
                    
                    if (pageNumber == 0 ) {
                        if (_notificationArray) {
                            [_notificationArray removeAllObjects];
                        }
                        _notificationArray = [[dictionary valueForKey:kAPIPayload] valueForKey:kNotifications];
                        pageNumber = (int)[_notificationArray count];
                    }
                    else{
                        NSMutableArray *arr = [[dictionary valueForKey:kAPIPayload] valueForKey:kNotifications];
                        
                        if(arr.count > 0){
                            [_notificationArray addObjectsFromArray:arr];
                        }
                        NSLog(@"%lu",(unsigned long)_notificationArray.count);
                        pageNumber = (int)[_notificationArray count];
                    }
                    
                    // show message if no recoed found
                    if (_notificationArray.count > 0) {
                        if (messageLabel) {
                            messageLabel.text = @"";
                            [messageLabel removeFromSuperview];
                        }
                    }
                    
                    else{
                        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
                        messageLabel.text = @"No Review found...";
                        messageLabel.textAlignment = NSTextAlignmentCenter;
                        messageLabel.textColor = [UIColor whiteColor];
                        [self.view addSubview:messageLabel];
                        
                    }
                    
                    [_tableView reloadData];
                    
                    isLoading = NO;
                    
                }
                else{
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                    
                }
                
            });
        }
        else{
            //Remove when API issue is fixed
            
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kTRLError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
    }];
    
    
}


-(void)changeStatusOfNotification:(BOOL)showHude dictionary:(NSMutableDictionary *)notificationDictionary mode:(NSString *)mode{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"U" forKey:kUserType];
    [dictionary setValue:[notificationDictionary valueForKey:kNotificationId]  forKey:kNotificationId];
    [dictionary setValue:mode forKey:kMode];
    [dictionary setValue:[loginDictionary valueForKey:kUserId] forKey:kUserId];



    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"notificationChangeStatus"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // check login steps
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {

                    if ([mode isEqualToString:@"delete"]) {

                    if ([_notificationArray containsObject:notificationDictionary] && _notificationArray.count>0) {
                        
                        [_notificationArray removeObject:notificationDictionary];
                        
                        
                    }
                    }
                    else{
                        
                        if ([_notificationArray containsObject:notificationDictionary] ) {
                            
                            [notificationDictionary setValue:@"1" forKey:kReadStatus];
                            
                            NSMutableDictionary *totalUnreadNotification = [dictionary valueForKey:kAPIPayload];
                            
                            
                            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[totalUnreadNotification valueForKey:kTotalUnread]integerValue]];
                        }
                    }
                    
                        [_tableView reloadData];

                }
                else{
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                    
                }
                
            });
        }
        else{
            //Remove when API issue is fixed
            
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kTRLError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
    }];
    
    
}*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
         NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.notificationArray objectAtIndex:indexPath.row]];
        
        if ([self.notificationArray containsObject:dict]) {
            
            [[IOFDB sharedManager] deleteNotificationsUsingId:[NSString stringWithFormat:@"%@",[dict valueForKey:@"AppNotificationId"]]];
            
            [self.notificationArray removeObject:dict];
            [_tableView reloadData];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSNumber *memID = [loginDictionary objectForKey:@"RefMembershipID"];
            [dic setObject:memID forKey:@"MembershipId"];
            [dic setObject:[dict valueForKey:@"AppNotificationId"] forKey:@"NotificationID"];
            [self deleteNotification:dic];

        }
        
        if (self.notificationArray.count==0) {
            _notificationView.hidden = YES;
        }
        
    }
    
}

#pragma mark - Scrol view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
    if(!isLoading)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 50;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
                _tableView.tableFooterView = spinner;
                
              //  [self getNotifiationList:NO];
            }
            
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clearAllButton_clicked:(id)sender {
    
    [self.notificationArray removeAllObjects];
    [[IOFDB sharedManager] deleteAllNotifications];
    _notificationView.hidden = NO;
    [_tableView reloadData];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSNumber *memID = [loginDictionary objectForKey:@"RefMembershipID"];
    [dict setObject:memID forKey:@"MembershipId"];
    [dict setObject:@"-1" forKey:@"NotificationID"];
    [self deleteNotification:dict];
    
}

-(void)deleteNotification:(NSMutableDictionary*)dictionary{
    
   
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"generics.svc/DeleteMobileNotification"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:@"Code"] isEqualToString:@"OK"]
                    ) {
                    
                   
                    
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

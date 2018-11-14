//
//  BGRevealMenuViewController.m
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "BGRevealMenuViewController.h"
#import "MenuCell.h"
#import "KarmaPointsVC.h"


@interface BGRevealMenuViewController ()
{
    NSMutableArray *menuImagesArray;
    NSMutableArray *menuLabelArray;
    NSMutableDictionary *loginDictionary;
    UISwitch * notificationSwitch;
    NSString *userType;
    NSString *guestUser;
    
    AppDelegate *appDelegate;
    
}
@end

@implementation BGRevealMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    guestUser = [Utility replaceNULL:[kUserDefault valueForKey:kGuestUser] value:@""];
    
    if ([guestUser isEqualToString:kGuestUser]) {
        
        _guestView.hidden = NO;
        menuLabelArray = [NSMutableArray arrayWithObjects:@"Home",@"My Cart",@"Karma",@"Top Karma Points",@"Share App",@"Settings",@"Feedback",@"Login",nil];
        
        menuImagesArray=[NSMutableArray arrayWithObjects:@"home",@"MyCart",@"Donate",@"TopDonors",@"Share",@"Settings",@"feedback",@"login", nil];
    }
    else{
        _guestView.hidden = YES;
        
        menuImagesArray=[NSMutableArray arrayWithObjects:@"home",@"MyAccount",@"MyOrders",@"MyCart",@"Donate",@"MyDonations",@"TopDonors",@"Notifications",@"Payment",@"Share",@"Settings",@"feedback",@"LogOut", nil];
        
        menuLabelArray=[NSMutableArray arrayWithObjects:@"Home",@"My Profile",@"My Orders",@"My Cart",@"Karma",@"My Karma",@"Top Karma Points",@"Notifications",@"Payment",@"Share App",@"Settings",@"Feedback",@"Logout", nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [self setupInitialLayout];
    [self getting_karmaPoints_Service];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)setupInitialLayout{
    
    userImage.layer.cornerRadius= 40;
    [userImage.layer setMasksToBounds:YES];
    
    // get login details
    
    
    if (![[kUserDefault valueForKey:kLoginInfo] isKindOfClass:[NSNull class]]) {
        loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        NSString *fullNameString;
        
        if (![[loginDictionary valueForKey:klastname] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:klastname] length]>0) {
            fullNameString = [NSString stringWithFormat:@"%@ %@",[loginDictionary valueForKey:kfirstname],[loginDictionary valueForKey:klastname]];
        }
        else {
            fullNameString = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:kfirstname]];
        }
        
        userNameLabel.text = fullNameString;
        
        userImage.layer.cornerRadius =  userImage.frame.size.width/2;
        [userImage.layer setMasksToBounds:YES];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = userImage.center;
        
        [activityIndicator startAnimating];
        
        
        // image
        NSString *imageName =[loginDictionary objectForKey:@"Photo"];
       // NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,PROFILEIMAGEURL];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",kProfileImageBaseUrl,imageName];
        
      [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@",url] fromDisk:YES];
        [userImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"profile"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType SDImageCacheTypeNone, NSURL *imageURL) {
            
            if (error) {
                
                
            }
        }];

    }
    
}

-(void) setProfileImage :(NSString*)finalImageUrl{
    NSData *imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:finalImageUrl]];
    userImage.image=[UIImage imageWithData:imageData];
}

#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [menuImagesArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![guestUser isEqualToString:kGuestUser] && indexPath.row == 8) {
        return 0;    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"menuCell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.menuImage.image = [UIImage imageNamed:[menuImagesArray objectAtIndex:indexPath.row]];
    cell.menuLabel.text=[menuLabelArray objectAtIndex:indexPath.row];
    
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = kDefaultLightGreen;
    cell.selectedBackgroundView = myBackView;
    
    if (![guestUser isEqualToString:kGuestUser] && indexPath.row == 8) {
        cell.hidden = YES;
    }
    
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.navigationController.navigationBarHidden = NO;
    
    if ([guestUser isEqualToString:kGuestUser]) {
        
        if (indexPath.row ==0) {
            
            [self performSegueWithIdentifier:khomeSegueIdentifier sender:nil];
        }
        
        else if (indexPath.row ==1) {
            if (appDelegate.checkProductArray.count ==0) {
                
                [self.revealViewController revealToggleAnimated:YES];
                [Utility showAlertViewControllerIn:self title:@"" message:@"Your shoping cart is empty." block:^(int index){
                }];
            }
            else{
                [self performSegueWithIdentifier:kmyCartSegueIdentifier sender:kRevealMenu];
            }
            
        }
        else if (indexPath.row ==2) {
            
            [self performSegueWithIdentifier:kDonateVCSegueIdentifier sender:nil];
        }
        
        else if (indexPath.row ==3) {
            
            [self performSegueWithIdentifier:ktopDonorSegueIdentifier sender:nil];
        }
        
        else if (indexPath.row ==4){
            [self.revealViewController revealToggleAnimated:YES];
            
            NSString *sharedMsg=[NSString stringWithFormat:@"https://www.apptology.com/testing/B&G/1.1/B&G"];
            NSArray* sharedObjects=[NSArray arrayWithObjects:sharedMsg,nil];
            
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:sharedObjects applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[
                                                             UIActivityTypePrint,
                                                             UIActivityTypeCopyToPasteboard,
                                                             UIActivityTypeAssignToContact,
                                                             UIActivityTypeSaveToCameraRoll,
                                                             UIActivityTypeAddToReadingList,
                                                             UIActivityTypeAirDrop,
                                                             UIActivityTypePostToTencentWeibo];
            activityViewController.modalPresentationStyle = UIModalPresentationPopover;
            [self presentViewController:activityViewController animated:YES completion:nil];
            
            activityViewController.completionWithItemsHandler = ^(NSString *activityType,
                                                                  BOOL completed,
                                                                  NSArray *returnedItems,
                                                                  NSError *error){
                if (completed) {
                    
                    NSLog(@"We used activity type%@", activityType);
                    
                } else {
                    
                    NSLog(@"We didn't want to share anything after all.");
                    
                }
                
                if (error) {
                    NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
                }
            };
            
        }
        else if (indexPath.row == 5) {
            [self performSegueWithIdentifier:ksettingSegueIdentifier sender:nil];
        }
        
        else if (indexPath.row ==7) {
            [self performSegueWithIdentifier:kSignInViewSegueIdentifier sender:nil];
        }
        else if (indexPath.row == 6) {
            [self performSegueWithIdentifier:kfeedbackIdentifier sender:nil];
        }
        
    }
    else{
        
        if (indexPath.row ==0) {
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication]delegate];
            appdelegate.editMyOrder = @"";
      //      appdelegate.totalPrice = @"";
           appdelegate.totalItemCount = 0;
//            [appdelegate.checkProductArray removeAllObjects];
            
            
            [self performSegueWithIdentifier:khomeSegueIdentifier sender:nil];
        }
        else if (indexPath.row ==1) {
            [self performSegueWithIdentifier:kregistrationSegueIdentifier sender:kEditMode];
        }
        else if (indexPath.row ==2) {
            [self performSegueWithIdentifier:kMyOrderSegueIdentifier sender:nil];
        }
        else if (indexPath.row ==3) {
            
            if (appDelegate.checkProductArray.count ==0) {
                [self.revealViewController revealToggleAnimated:YES];

                [Utility showAlertViewControllerIn:self title:@"" message:@"Your shoping cart is empty." block:^(int index){
                }];
            }
            else{
                 [self performSegueWithIdentifier:kmyCartSegueIdentifier sender:kRevealMenu];
            }
           
        }
        else if (indexPath.row ==4) {
            
            [self performSegueWithIdentifier:kDonateVCSegueIdentifier sender:nil];
        }
        else if (indexPath.row ==5) {
            
            [self performSegueWithIdentifier:kMyDonationSegueIdentifier sender:nil];
        }
        else if (indexPath.row ==6) {
            
            [self performSegueWithIdentifier:ktopDonorSegueIdentifier sender:nil];
        }
        
        else  if (indexPath.row ==7) {
            [self performSegueWithIdentifier:knotificationSegueIdentifier sender:nil];
        }
        else if (indexPath.row ==9){
            [self.revealViewController revealToggleAnimated:YES];
            
            NSString *sharedMsg=[NSString stringWithFormat:@"https://www.apptology.com/testing/B&G/1.1/B&G"];
            NSArray* sharedObjects=[NSArray arrayWithObjects:sharedMsg,nil];
            
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:sharedObjects applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[
                                                             UIActivityTypePrint,
                                                             UIActivityTypeCopyToPasteboard,
                                                             UIActivityTypeAssignToContact,
                                                             UIActivityTypeSaveToCameraRoll,
                                                             UIActivityTypeAddToReadingList,
                                                             UIActivityTypeAirDrop,
                                                             UIActivityTypePostToTencentWeibo];
            activityViewController.modalPresentationStyle = UIModalPresentationPopover;
            [self presentViewController:activityViewController animated:YES completion:nil];
            
            activityViewController.completionWithItemsHandler = ^(NSString *activityType,
                                                                  BOOL completed,
                                                                  NSArray *returnedItems,
                                                                  NSError *error){
                if (completed) {
                    
                    NSLog(@"We used activity type%@", activityType);
                    
                } else {
                    
                    NSLog(@"We didn't want to share anything after all.");
                    
                }
                
                if (error) {
                    NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
                }
            };
            
        }
        
        else if (indexPath.row ==12) {
            
            [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"Logout" message:@"Are you sure you want to Logout?" block:^(int index){
                
                if (index == 0) {
                    [[GIDSignIn sharedInstance] signOut];
                    [[GIDSignIn sharedInstance] disconnect];
                    [[FBSDKLoginManager new] logOut];
      
                    appDelegate.totalPrice = @"";
                    appDelegate.totalItemCount = 0;
                    [appDelegate.checkProductArray removeAllObjects];

                    
                    [kUserDefault removeObjectForKey:kLoginInfo];
                    [self performSegueWithIdentifier:kSignInViewSegueIdentifier sender:nil];
                }
                else{
                    self.navigationController.navigationBarHidden = YES;
                }
                
            }];
        }
        
        
        else if (indexPath.row == 10) {
            [self performSegueWithIdentifier:ksettingSegueIdentifier sender:nil];
        }
        else if (indexPath.row == 11) {
            [self performSegueWithIdentifier:kfeedbackIdentifier sender:nil];
        }
        
    }
}


-(void)signOutFuntionality{
    
    //    [kUserDefault removeObjectForKey:kLoginInfo];
    //    [kUserDefault removeObjectForKey:kUserLoginType];
    //    [kUserDefault removeObjectForKey:kSkinpAndTry];
    //
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //
    //    AppDelegate *appDelegateTemp = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    TRLUserInitialController *initialController = [storyBoard instantiateViewControllerWithIdentifier:kInitialControllerStoryBoardID];
    //
    //    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:initialController];
    //    appDelegateTemp.window.rootViewController = navigation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    if ([sender isEqualToString:kEditMode]) {
        destViewController.title  = kMyProfile;
    }
    else  if ([sender isEqualToString:kRevealMenu]) {
        destViewController.title  = kRevealMenu;
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            
            
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
    
}

#pragma mark - API call

/****************************
 * Function Name : - signout
 * Create on : - 16 Feb 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used for signout user
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)signout{
    
    /*  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:[loginDictionary valueForKey:kUserId] forKey:kUserId];
     [dictionary setValue:[kUserDefault valueForKey:kDeviceid] forKey:kDeviceid];
     [dictionary setValue:@"ios" forKey:kPlatform];
     
     NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"userLogout"];
     
     [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
     
     if (!error) {
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     
     if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
     
     [self signOutFuntionality];
     
     
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
     
     if([error.domain isEqualToString:kTRLError]){
     dispatch_async(dispatch_get_main_queue(), ^{
     [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
     
     }];
     });
     }
     }
     
     }];*/
    
}

- (IBAction)editButton_clicked:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    
    [self performSegueWithIdentifier:@"myKarmaPointSegueIdentifier" sender:nil];
}


#pragma mark - APIS

-(void)getting_karmaPoints_Service{
    NSString *strRequestURL = @"SZCustomers.svc/GetMyCreditDetails";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *membershipID = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"RefMembershipID"]];
    [params setObject:membershipID forKey:@"MembershipId"];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Content-Type", nil];
    //    [MBProgressHUD showHUDAddedTo:ObjDelegate.window animated:YES];
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
                        karmaPointLabel.text = [NSString stringWithFormat:@"Karma Points-%0.1f",[[[responseDict objectForKey:@"Payload"] objectForKey:@"TotalKarmaPoint"] floatValue]];
                        
                        [loginDictionary setObject:[[responseDict objectForKey:@"Payload"] valueForKey:@"CreditBalance"] forKey:@"CreditBalance"];
                        [loginDictionary setObject:[[responseDict objectForKey:@"Payload"] valueForKey:@"TotalKarmaPoint"] forKey:@"TotalKarmaPoint"];
                        
                        [kUserDefault setValue:[Utility archiveData:loginDictionary] forKey:kLoginInfo];
                        
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
@end

//
//  AppDelegate.m
//  Brown&Green
//
//  Created by vineet patidar on 25/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "AppDelegate.h"
#import <Google/Analytics.h>

@class STPAPIClient;
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // set navigation bar images
    
    self.checkProductArray = [[NSMutableArray alloc] init];
    self.editProductDictionary = [[NSMutableDictionary alloc]init];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"header"]
                                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Set Client ID for Google Sign In
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // [self pingSplash];
    
    
    // set push notification
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // crashlytics
//    [Fabric with:@[[Crashlytics class]]];
        [Fabric with:@[[STPAPIClient class]]];

    
    [self CurrentLocationIdentifier];
    

    GAI *gai = [GAI sharedInstance];
    [gai trackerWithTrackingId:@"UA-99661498-1"];
    
    // Optional: automatically report uncaught exceptions.
    gai.trackUncaughtExceptions = YES;

    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Splash Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [FIRApp configure];

    
    [self autoLogin:application];
    
    // get city list
    [self getCityList];
    
    // get stte list
    [self getStateList];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
    // paypal seting for live and production
 //   [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AT_KmyrghuH0CcfUtMv2TGOIsjWpWc69Y1hjKRXb_pqSR_m9agYUdMhD5ZQDSg7YUrfmdYFH8T2npuKl",PayPalEnvironmentSandbox : @"AQOkOOoFj7m_figyEFedCCj2mnnKxcna7txoaKqpKUGGT8LYlCAlRkyRzqpzPTdsaKDhCw_7XxZX5DsL"}];
    
     [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"AQOkOOoFj7m_figyEFedCCj2mnnKxcna7txoaKqpKUGGT8LYlCAlRkyRzqpzPTdsaKDhCw_7XxZX5DsL"}];

    return YES;
}




/****************************
 * Function Name : - autoLogin
 * Create on : - 23th Nov 2016
 * Developed By : - Ramniwas
 * Description : - method for autoLogin user
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)autoLogin:(UIApplication *)application{
    
    NSMutableDictionary *_loginDictionary= [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if (![[_loginDictionary valueForKey:@"memberStatus"] isKindOfClass:[NSNull class]]) {
        
        if ([[_loginDictionary valueForKey:@"memberStatus"] isEqualToString:@"Y"]) {
            
            UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            BGHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
            
            BGRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            
            revealController.delegate = self;
            
            self.revealViewController = revealController;
            
            self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
            self.window.backgroundColor = [UIColor redColor];
            
            self.window.rootViewController =self.revealViewController;
            [self.window makeKeyAndVisible];
        }
        
    }
   
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return   [[FBSDKApplicationDelegate sharedInstance] application:application
                                                            openURL:url
                                                  sourceApplication:sourceApplication
                                                         annotation:annotation];
    return NO;
}


/* commented on 6 March by Krati
 - (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
 // An example to handle the deep link data.
 UIAlertView *alert = [[UIAlertView alloc]
 initWithTitle:@"Deep-link Data"
 message:[deepLink deepLinkID]
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 [alert show];
 }
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [kUserDefault removeObjectForKey:KAge];
    
}


#pragma mark GoogleSign In
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:app
                                                   openURL:url
                                         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];

    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma - mark - Remote Notification Delegate

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Failed to register notifications");
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", devToken);
    
   [kUserDefault setValue:devToken forKey:@"devicetoken"];
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSMutableDictionary *aps = [userInfo valueForKey:@"aps"];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[aps valueForKey:@"badge"] integerValue]];
    
    [Utility showAlertViewControllerIn:self.window.rootViewController title:@"Notification" message:[aps valueForKey:@"alert"] block:^(int index){
        
        
    }];
    
}


#pragma mark - CLLocation Manager

/****************************
 * Function Name : - CurrentLocationIdentifier
 * Create on : - 23th Nov 2016
 * Developed By : - Ramniwas
 * Description : - This method for get user current location
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)CurrentLocationIdentifier {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        [locationManager requestWhenInUseAuthorization];
        
    }
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    
    self.lat = (double) currentLocation.coordinate.latitude;
    self.lon = (double)  currentLocation.coordinate.longitude;
    
  /*  if (geocoder) {
        [geocoder cancelGeocode];
    }
    geocoder = [[CLGeocoder alloc] init] ;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
            NSString *area = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
                          NSString *nameString = [placemark.addressDictionary valueForKey:@"Name"];
             
             NSString *city = [placemark.addressDictionary objectForKey:@"City"];
             
             NSString *country = [placemark.addressDictionary objectForKey:@"Country"];
             
             NSString *address = [NSString stringWithFormat:@"%@",city];
             
             self.addressString = address;
             
             
             
         }
         else{
             NSLog(@"Geocode failed with error %@", error);
         }
     }]; */
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString * message=nil;
    switch (status) {
            
        case kCLAuthorizationStatusRestricted:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tap on setting to enable location services!";
            
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tlease tap on setting to enable location services!";
            
            break;
        case kCLAuthorizationStatusDenied:
            message=@"Location services are off. Please tap on setting to enable location services!";
            
            
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            break;
            
            
        default:
            
            
            break;
    }
    
    
    
    //    if (message) {
    //         [Utils showAlertViewControllerIn:self.window.rootViewController title:@"PupSmooch" message:message  block:^(int sum) {
    //
    //
    //         }];
    //   }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.lat = 0;
    self.lon = 0;
    // NSLog(@"location off");
    NSString *message=nil;
    if ([error domain] == kCLErrorDomain)
    {
        switch ([error code]){
            case kCLErrorDenied:
                
                break;
                
            default:
                message=@"No GPS coordinates are available. Please take the device outside to an open area.";
                break;
        }
    }
    
    [self CurrentLocationIdentifier];
    
    
}


#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 27 April 2017
 * Developed By : - Ramniwas
 * Description : -  This function for search country
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getCityList{
    
    NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"generics.svc/GetcityList/"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:STATUS] boolValue]== 1) {
                    
                    [UtilityPlist saveData:[NSMutableDictionary dictionaryWithDictionary:dictionary] fileName:kCityList];
                }
                
            });
        }

    }];
    
}

-(void)getStateList{
    
    NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"generics.svc/GetStateList/"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:STATUS] boolValue]== 1) {
                    
                    [UtilityPlist saveData:[NSMutableDictionary dictionaryWithDictionary:dictionary] fileName:kStateList];
                }
                
            });
        }
        
    }];
    
}


#pragma  mark - data Sync

-(void)databaseSync{
    iofDB = [IOFDB sharedManager];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
  
        NSString *lastUpdatedRecordDate = [iofDB getDateFromDataBase];
        [[NSUserDefaults standardUserDefaults] setObject:lastUpdatedRecordDate forKey:@"lastSyncDate"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:lastUpdatedRecordDate forKey:@"FilterDate"];
        TabelRecords *signup = [[TabelRecords alloc] initWithDict:dict];
        signup.requestDelegate=self;
        [signup startAsynchronous];
    }


- (void)tabelRecordsRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData{
    [[NSUserDefaults standardUserDefaults] setObject:[inData objectForKey:@"CurrentDate"] forKey:@"currentDate"];
    NSMutableDictionary *payLoadDic = [inData objectForKey:@"Payload"];
    NSString *currentDate = [inData objectForKey:@"CurrentDate"];
    [[IOFDB sharedManager] deleteDataBaseDate];
    [[IOFDB sharedManager] insertCategory:[payLoadDic valueForKey:kCatList]];
    if(![[payLoadDic valueForKey:kSubCatList] isEqual:[NSNull null]])
        [[IOFDB sharedManager] insertSubCategory:[payLoadDic valueForKey:kSubCatList]];
    if(![[payLoadDic valueForKey:kProductList] isEqual:[NSNull null]])
        [[IOFDB sharedManager] insertProduct :[payLoadDic valueForKey:kProductList]];
    [[IOFDB sharedManager] insertLocation:[payLoadDic valueForKey:kLocationList]];
    [[IOFDB sharedManager] insertPrice:[payLoadDic valueForKey:kPriceList]];
    
    if(![[payLoadDic valueForKey:@"ProductSortList"] isEqual:[NSNull null]]){
    [[IOFDB sharedManager] updateSortOrder:[payLoadDic valueForKey:@"ProductSortList"]];
    }

    
    [[IOFDB sharedManager] insertDate:currentDate];
    iofDB.mArrCategories = [iofDB getCategory];
    iofDB.mArrSubCategories=[iofDB getSubCategory];
    iofDB.mArrProducts = [iofDB getProducts];
    iofDB.mArrLocations = [iofDB getLocations];
    self.dataBaseDate = [iofDB getDateFromDataBase];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *lastSyncDate = [format stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setValue:lastSyncDate forKey:@"lastSyncDate"];
}
-(void) getDataFromLocalJsonFile{
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *filePath;
        if ([kAPIBaseURL isEqualToString:@"http://staging.sirez.com/IOF/IOFFeederREST/"])
        {
            filePath = [[NSBundle mainBundle] pathForResource:@"local_staging" ofType:@"json"];
            
        }
        else
            filePath = [[NSBundle mainBundle] pathForResource:@"databaselocalData" ofType:@"json"];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSMutableDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableDictionary *payLoadDic = [mainDict objectForKey:@"Payload"];
        NSString *currentDate = [mainDict objectForKey:@"CurrentDate"];
        
        [[IOFDB sharedManager] StartTransaction];
        [[IOFDB sharedManager] deleteAllCategories];
        [[IOFDB sharedManager] deleteAllSubCategories];
        [[IOFDB sharedManager] deleteAllProducts];
        [[IOFDB sharedManager] deleteAllPrice];
        [[IOFDB sharedManager] deleteAllLocation];
        [[IOFDB sharedManager] deleteDataBaseDate];
        [[IOFDB sharedManager] insertCategory:[payLoadDic valueForKey:kCatList]];
        if(![[payLoadDic valueForKey:kSubCatList] isEqual:[NSNull null]])
            [[IOFDB sharedManager] insertSubCategory:[payLoadDic valueForKey:kSubCatList]];
        [[IOFDB sharedManager] insertProduct:[payLoadDic valueForKey:kProductList]];
        [[IOFDB sharedManager] insertLocation:[payLoadDic valueForKey:kLocationList]];
        [[IOFDB sharedManager] insertPrice :[payLoadDic valueForKey:kPriceList]];
        [[IOFDB sharedManager] updateSortOrder:[payLoadDic valueForKey:@"ProductSortList"]];
        [[IOFDB sharedManager] insertDate:currentDate];
        [[IOFDB sharedManager] EndTransaction];
        
        //this is background thread
        //here write you code which you want to execute on Background thread:
        //once the code has executed the execution will be thrown to below method
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //this is main thread
            //after completing the background thread code , the execution will come here
            //from here go where ever you want or do here what ever you want
            //but make sure here whatever u do will be on main thread
            
            iofDB.mArrCategories = [iofDB getCategory];
            iofDB.mArrSubCategories=[iofDB getSubCategory];
            iofDB.mArrProducts = [iofDB getProducts];
            iofDB.mArrLocations = [iofDB getLocations];
            self.dataBaseDate = [iofDB getDateFromDataBase];
            [self databaseSync];
            
            
            
        });
    });
    
}

//-(void) getDataFromLocalJsonFile{
//    NSString *filePath;
//    if ([kAPIBaseURL isEqualToString:@"http://staging.sirez.com/IOF/IOFFeederREST/"])
//    {
//        filePath = [[NSBundle mainBundle] pathForResource:@"local_staging" ofType:@"json"];
//        
//    }
//    else{
//        filePath = [[NSBundle mainBundle] pathForResource:@"local_live" ofType:@"json"];
//    }
//    
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSMutableDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSMutableDictionary *payLoadDic = [mainDict objectForKey:@"Payload"];
//    NSString *currentDate = [mainDict objectForKey:@"CurrentDate"];
//    
//    [[IOFDB sharedManager] StartTransaction];
//    [[IOFDB sharedManager] deleteAllCategories];
//    [[IOFDB sharedManager] deleteAllSubCategories];
//    [[IOFDB sharedManager] deleteAllProducts];
//    [[IOFDB sharedManager] deleteAllPrice];
//    [[IOFDB sharedManager] deleteAllLocation];
//    [[IOFDB sharedManager] deleteDataBaseDate];
//    [[IOFDB sharedManager] insertCategory:[payLoadDic valueForKey:kCatList]];
//    if(![[payLoadDic valueForKey:kSubCatList] isEqual:[NSNull null]])
//        [[IOFDB sharedManager] insertSubCategory:[payLoadDic valueForKey:kSubCatList]];
//    [[IOFDB sharedManager] insertProduct:[payLoadDic valueForKey:kProductList]];
//    [[IOFDB sharedManager] insertLocation:[payLoadDic valueForKey:kLocationList]];
//    [[IOFDB sharedManager] insertPrice :[payLoadDic valueForKey:kPriceList]];
//    [[IOFDB sharedManager] updateSortOrder:[payLoadDic valueForKey:@"ProductSortList"]];
//    [[IOFDB sharedManager] insertDate:currentDate];
//    [[IOFDB sharedManager] EndTransaction];
//    iofDB = [IOFDB sharedManager];
//    iofDB.mArrCategories = [iofDB getCategory];
//    iofDB.mArrSubCategories=[iofDB getSubCategory];
//    iofDB.mArrProducts = [iofDB getProducts];
//    iofDB.mArrLocations = [iofDB getLocations];
//    self.dataBaseDate = [iofDB getDateFromDataBase];
//}
- (void)tabelRecordsRequestFailedWithErrorMessage:(NSString *)inMessage
{
    [Utility hideMBHUDLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:inMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}
@end

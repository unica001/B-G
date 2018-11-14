//
//  AppDelegate.h
//  Brown&Green
//
//  Created by vineet patidar on 25/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SWRevealViewController.h"
//#import "BGRevealMenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Google/Analytics.h>
#import "BGRevealMenuViewController.h"
#import "BGHomeViewController.h"
#import "UtilityPlist.h"
#import "TabelRecords.h"
#import "IOFDB.h"
#import <Fabric/Fabric.h>
#import <Stripe/Stripe.h>
#import "PayPalMobile.h"
#import <Firebase.h>

#define ObjDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define  ConfigDelegate [[Config alloc] init]

static NSString * const kClientID = @"549869378228-madtnsp4b4qjfei0hrrmj8jennvld98c.apps.googleusercontent.com";

@protocol GAITracker;
@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate,CLLocationManagerDelegate,TabelRecordsDelegate>{
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    IOFDB *iofDB;

}

@property ( nonatomic) double lat;
@property ( nonatomic) double lon;

@property(nonatomic, strong) id<GAITracker> tracker;

@property ( nonatomic,retain) NSString *addressString;
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic,retain) SWRevealViewController *revealViewController;
@property (nonatomic,retain) NSString  *dataBaseDate;
@property (nonatomic,retain) NSMutableArray *checkProductArray;
@property (nonatomic,retain) UIApplication *application;
@property (nonatomic) BOOL isFromPlaceOrder;
@property(nonatomic) NSMutableDictionary *currentOrder;
@property (nonatomic,retain) NSMutableDictionary *editProductDictionary;
@property (nonatomic) NSInteger totalItemCount;
@property (nonatomic,retain) NSString *editMyOrder;

@property ( nonatomic,retain) NSString *totalPrice;



@end


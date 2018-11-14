//
//  CommonFunctions.h
//  BarApp
//
//  Created by Kipl.Sudheer on 24/06/15.
//  Copyright (c) 2015 KT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <UIKit/UIKit.h>


#import <CommonCrypto/CommonDigest.h>




/**
 *  macros to adjust some screen adjustments according to iPhone screen sizes
 */
#define IsiPhone3p5Inch ([CommonFunctions getDeviceType] == IPHONE3P5INCH)
#define IsiPhone4Inch   ([CommonFunctions getDeviceType] == IPHONE4INCH)
#define IsiPhone4p7Inch   ([CommonFunctions getDeviceType] == IPHONE4P7INCH)
#define IsiPhone5p5Inch   ([CommonFunctions getDeviceType] == IPHONE5P5INCH)


/**
 *  decides and returns the the current device type.
 */
#define IPHONE3P5INCH 10
#define IPHONE4INCH 11
#define IPAD 12
#define IPAD_MINI 13
#define IPHONE4P7INCH 14
#define IPHONE5P5INCH 15


/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON)

#define IS_IPHONE_6PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:39.0/255 green:56.0/255 blue:68.0/255 alpha:1.0]


#define ColorWithRGB255(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

#define ColorWithRGB(r, g, b) [UIColor colorWithRed:r green:g blue:b alpha:1]


#define RGBCOLOR(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

#define RGBCOLORWithAlpha(r, g, b , a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]




@interface CommonFunctions : NSObject


+ (BOOL)connectedToNetwork;
+ (NSString *)documentsDirectory;
+ (void)openEmail:(NSString *)address;
+ (void)openSms:(NSString *)number;
+ (void)openPhone:(NSString *)number;
+ (void)openBrowser:(NSString *)url;
+ (void)openMap:(NSString *)address;
+ (void)showAlert:(NSString *)message;
+ (void)showAlertWithInfo:(NSDictionary*) infoDic;
+ (int)getDeviceType;
+ (void) showAlertWithTitle:(NSString*) alertTitle message:(NSString*) message cancelTitle:(NSString*) cancelTitle otherTitle:(NSString*) otherTitle tag:(NSInteger) tag delegate:(id) delegate withDelay:(float) delay;

+ (BOOL)isValidNumeric:(NSString*)string;

+ (NSString*)convertTomd5HexDigest:(NSString*)input;
+(UIImage*) loadCachedImageFromURL:(NSString*) urlStr;
@end

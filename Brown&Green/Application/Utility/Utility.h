//
//  Utility.h
//  TRLUser
//
//  Created by Jitender on 12/16/16.
//  Copyright © 2016 Jitender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject


#pragma mark - CHECKING A BLANK STRING

+ (BOOL)validateField:(NSString*)field;

#pragma mark - BASE64 IMAGE CONVERSION

+ (NSString *)encodeToBase64String:(UIImage *)image ;

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

+(NSString*)base64forData:(NSData*)theData;
#pragma mark - TIME CONVERSION

+ (NSString *)convertToMinutes:(int)seconds;


#pragma mark - VALIDATE EMAIL ID

+ (BOOL)validateEmail:(NSString*)email;


#pragma mark - VALIDATE NUMBER FOR US

+ (BOOL)validateMobileNumberForUS:(NSString *)numberStr;


#pragma mark - SCALE AN IMAGE

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


#pragma mark - ALERT CONTROLLER WITH ONE BUTTON

+ (void)showAlertViewControllerIn:(UIViewController*)controller title:(NSString*)title message:(NSString*)message block:(void(^)                   (int sum))block;


#pragma mark - ALERT CONTROLLER WITH TWO BUTTONS

+ (void)showAlertViewControllerIn:(UIViewController*)controller withAction:(NSString*)actionOne actionTwo:(NSString*)actionTwo title:(NSString*)title message:(NSString*)message block:(void(^)                                                                                                                           (int tag)                                                                                                                             )block;


#pragma mark - DATE TO STRING

+ (NSString *)convertDateToString:(NSDate *)date dateFormat:(NSString *)dateFormat timeZone:(NSString*)timeZone;


#pragma mark - GET TEXT HEIGHT

+ (CGFloat)getTextHeight:(NSString *)text size:(CGSize)size font:(UIFont *)font;

+ (CGFloat)getTextWidth:(NSString *)text size:(CGSize)size font:(UIFont *)font;


#pragma mark - Keyed archiving method

+ (NSData*)archiveData : (NSMutableDictionary*)archivedDictionary;



#pragma mark - Keyed unarchiving method

+ (NSMutableDictionary*)unarchiveData : (NSData*)unarchivedDictionary;


#pragma mark - Show Loader

+(void)ShowMBHUDLoader;


#pragma mark - Hide Loader

+ (void)hideMBHUDLoader;

#pragma mark - get current date time

+(NSString *)getCurrentDateTime;
+(NSString *)getFormatedDate:(NSString *)intDate;

#pragma mark - get device ID

+(NSString *)getDeviceID;

#pragma mark - check mobile number validation

+(BOOL)isValidPassword:(NSString *)passwordString;

+ (NSString *)replaceNULL:(id)object value:(NSString *)value;

+(NSString *)makePhoneNumberFormate:(NSString *)phoneNumber;

+(NSString*) unescape:(NSString*) string;
@end

//
//  Config.h
//  Assetz
//
//  Created by Anand Shukla on 11/18/15.
//  Copyright (c) 2015 Anand Shukla. All rights reserved.
//

#import <Foundation/Foundation.h>



#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight  [UIScreen mainScreen].bounds.size.height

extern NSString *siteAPIURL;
extern NSString *ShareAPI;
extern NSString *imageAPIURL;
extern NSString *ThumbAPIURL;
extern NSString * ProfileImgURL;

#define kScreenType @"ScreenType"

#define kDeviceToken @"DeviceToken"
#define kDevicetype @"2"

#define FINAL_DONATIONLIST @"finalDonationList"

@interface Config : NSObject

-(void)setStringForString:(NSString *)value forKey:(NSString *)key;
-(NSString *)getValueForKey:(NSString *)key;
-(void)deleteStoredValue:(NSString *)key;
-(void)setStringForArray:(NSMutableArray *)array forKey:(NSString *)key;
-(NSMutableArray *)getValueForArrayKey:(NSString *)key;
-(BOOL)getBoolValueForKey:(NSString *)boolKey;
-(void)setBoolValue:(BOOL)isTrue   ForKey:(NSString *)boolKey;

-(void)setInteger:(NSInteger)integer forKey:(NSString *)defaultName;
-(NSInteger)getIntegerForKey:(NSString *)integerKey;
@end













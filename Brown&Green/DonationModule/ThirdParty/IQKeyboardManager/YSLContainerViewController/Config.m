//
//  Config.m
//  Assetz
//
//  Created by Anand Shukla on 11/18/15.
//  Copyright (c) 2015 Anand Shukla. All rights reserved.
//

#import "Config.h"
@implementation Config


// NSString *siteAPIURL    =   @"http://staging.sirez.com/BrownAndGreens/FeederREST/"; sanbox
//http://staging.sirez.com/BrownAndGreens/FeederREST/SZCustomers.svc/getCustomerOrderSchedule_v3
 //http://staging.sirez.com/BrownAndGreens/FeederREST/avatars/Customers/

// live
// NSString *siteAPIURL    =   @"http://staging.sirez.com/BrownAndGreens/FeederREST/";

// NSString *imageAPIURL    =   @"http://staging.sirez.com/BrownAndGreens/Admin/avatars/DonationProducts/";
// NSString *ThumbAPIURL = @" http://staging.sirez.com/BrownAndGreens/Admin/avatars/DonationProducts/Thumb";
// NSString * ProfileImgURL = @"http://staging.sirez.com/BrownAndGreens/FeederREST/avatars/Customers/";


// production
NSString *imageAPIURL    =   @"http://cp.brownandgreens.com.au/avatars/DonationProducts/";
NSString *ThumbAPIURL = @"http://cp.brownandgreens.com.au/avatars/DonationProducts/Thumb";
NSString * ProfileImgURL = @"http://cp.brownandgreens.com.au/avatars/Customers/";

-(void)setStringForString:(NSString *)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)getValueForKey:(NSString *)key{
   NSString * returnKey = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return returnKey;
}
-(void)deleteStoredValue:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

-(void)setStringForArray:(NSMutableArray *)array forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSMutableArray *)getValueForArrayKey:(NSString *)key{
    NSMutableArray * returnKey = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return returnKey;
}
-(void)setBoolValue:(BOOL)isTrue   ForKey:(NSString *)boolKey{
    [[NSUserDefaults standardUserDefaults] setBool:isTrue forKey:boolKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)getBoolValueForKey:(NSString *)boolKey{
    return [[NSUserDefaults standardUserDefaults] boolForKey:boolKey];
    
}

-(void)setInteger:(NSInteger)integer forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setInteger:integer forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)getIntegerForKey:(NSString *)integerKey{
    return [[NSUserDefaults standardUserDefaults] integerForKey:integerKey];
}
@end

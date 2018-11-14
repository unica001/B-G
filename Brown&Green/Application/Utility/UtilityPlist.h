//
//  UtilityPlist.h
//  TRLUser
//
//  Created by vineet patidar on 03/02/17.
//

#import <Foundation/Foundation.h>

@interface UtilityPlist : NSObject
+ (void)saveData:(NSMutableDictionary *)dict fileName:(NSString *)fileName;
+(NSDictionary *)getData:(NSString *)fileName;
@end

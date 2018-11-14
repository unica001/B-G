//
//  SkinTypeUtility.m
//  TRLUser
//
//  Created by vineet patidar on 03/02/17.
//

#import "UtilityPlist.h"

@implementation UtilityPlist

+ (void)saveData:(NSMutableDictionary *)dict fileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    //make a file name to write the data to using the documents directory:
    fileName = [NSString stringWithFormat:@"%@/%@.plist",documentsDirectory,fileName];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:fileName atomically:YES];
    
 }
+(NSDictionary *)getData:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    fileName = [NSString stringWithFormat:@"%@/%@.plist",documentsDirectory,fileName];
    
    NSData *data1 = [NSData dataWithContentsOfFile:fileName];
    NSDictionary *dictdayData = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    NSLog(@"%@",dictdayData);
    
    return dictdayData;
    
}
@end

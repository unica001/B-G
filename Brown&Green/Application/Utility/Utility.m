//
//  Utility.m
//  TRLUser
//
//  Created by Jitender on 12/16/16.
//  Copyright © 2016 Jitender. All rights reserved.
//

#import "Utility.h"
#import "MBProgressHUD.h"
#import "PhoneNumberFormatter.h"

@implementation Utility

#pragma mark - VALIDATING EMPTY TEXTFIELD

+ (BOOL)validateField:(NSString*)field{
    if (field) {
        
        field = [field stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (field.length > 0) {
            return TRUE;
        }
    }
    return FALSE;
}


#pragma mark - GET CURRENT DATE TIME

+(NSString *)getCurrentDateTime{

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString *)getDeviceID{

    NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"UDID:: %@", uniqueIdentifier);
    
    return uniqueIdentifier;
}

#pragma mark - BASE64 IMAGE CONVERSION

+ (NSString *)encodeToBase64String:(UIImage *)image {
    
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+(NSString*)base64forData:(NSData*)theData{
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


#pragma mark - CONVERT SECONDS TO MINUTES

+ (NSString *)convertToMinutes:(int)seconds{
    
    int minINT = seconds/60;
    if(minINT < 1)
    {
        minINT = 1;
    }
    NSString *min = [NSString stringWithFormat:@"%d",minINT];
    
    return min;
}


#pragma mark - VALIDATE EMAIL ID

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if ([emailTest evaluateWithObject:email] == YES)
        return TRUE;
    else
        return FALSE;
}


#pragma mark - VALIDATE NUMBER FOR US

+ (BOOL)validateMobileNumberForUS:(NSString *)numberStr{
    
    if(numberStr.length < 7 || numberStr.length > 16 )
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
    
}


#pragma mark - SCALE AN IMAGE

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




#pragma mark - CONVERT DATE TO STRING

+ (NSString *)convertDateToString:(NSDate *)date dateFormat:(NSString *)dateFormat timeZone:(NSString*)timeZone {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZone]];
    NSString *localDateString = [dateFormatter stringFromDate:date];
    return localDateString;
}

+ (CGFloat)getHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

+ (CGFloat)getTextHeight:(NSString *)text size:(CGSize)size font:(UIFont *)font
{
    
    if ([text isKindOfClass:[NSNull class]]) {
        return 0.0;
    }
    CGSize constraint = CGSizeMake(size.width, CGFLOAT_MAX);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:context].size;
    
    return ceil(boundingBox.height);
}

+ (CGFloat)getTextWidth:(NSString *)text size:(CGSize)size font:(UIFont *)font
{
    CGSize constraint = CGSizeMake(CGFLOAT_MAX,size.height );
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:context].size;
    
    return ceil(boundingBox.width);
}

#pragma mark - ALERT CONTROLLER WITH ONE BUTTON

+(void)showAlertViewControllerIn:(UIViewController*)controller title:(NSString*)title message:(NSString*)message block:(void(^)
                                                                                                                        (int sum)
                                                                                                                        
                                                                                                                        )block{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert ];
    
    UIAlertAction * actionOk=[ UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        block(1);
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:actionOk];
    [controller presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - ALERT CONTROLLER WITH TWO BUTTONS

+(void)showAlertViewControllerIn:(UIViewController*)controller withAction:(NSString*)actionOne actionTwo:(NSString*)actionTwo title:(NSString*)title message:(NSString*)message block:(void(^)
                                                                                                                                                                                       (int tag)
                                                                                                                                                                                       
                                                                                                                                                                                       )block{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert ];
    
    
    UIAlertAction * action1=[ UIAlertAction actionWithTitle:actionOne style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        block(0);
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction * action2=[ UIAlertAction actionWithTitle:actionTwo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        block(1);
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [controller presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark - Keyed archiving method

+ (NSData*)archiveData : (NSMutableDictionary*)archivedDictionary{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:archivedDictionary];
    
    return data;
    
}



#pragma mark - Keyed archiving method

+ (NSMutableDictionary*)unarchiveData:(NSData *)unarchivedDictionary{
    
    NSMutableDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:unarchivedDictionary];
    
    return data;
    
}

#pragma mark - Keyed archiving method

+ (void)ShowMBHUDLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate * myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
        [MBProgressHUD showHUDAddedTo:myDelegate.window animated:YES];
    });
}




+ (void)hideMBHUDLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate * myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
        [MBProgressHUD hideHUDForView:myDelegate.window animated:YES];
    });
}

+(BOOL)isValidPassword:(NSString *)passwordString
{
    //NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,15}";
//    NSString *stricterFilterString = @"^(?=.*\\d)(?=.*[$#$@$!%*?&])[A-Za-z\\d$#$@$!%*?&]{6,15}";
    
    
    NSString *stricterFilterString = @"^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{6,15}";
    
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:passwordString];
}

#pragma  mark - Date formate

+(NSString *)getFormatedDate:(NSString *)intDate{
    NSString *strdate = @"";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[intDate doubleValue]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    if ([[df stringFromDate:[NSDate date]] isEqualToString:[df stringFromDate:date]]) {
        [df setDateFormat:@"hh:mm a"];
        strdate = [df stringFromDate:date];
    }
    else if ([[df stringFromDate:[[NSDate date] dateByAddingTimeInterval:-60*60*24]] isEqualToString:[df stringFromDate:date]])
    {
        strdate = @"Yesterday";
    }
    else{
        strdate =  [df stringFromDate:date];
    }
    return strdate;
    
}

+ (NSString *)replaceNULL:(id)object value:(NSString *)value{
    if ([object isKindOfClass:[NSNull class]]) {
        return value;
    }
    else if (![object isKindOfClass:[NSString class]]) {
        return [object stringValue];
    }
    else if([object isEqualToString:@""]){
        return value;
    }
    return object;
}


+(NSString *)makePhoneNumberFormate:(NSString *)phoneNumber{

        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
        NSLog(@"%@",[formatter formatForUS:phoneNumber]);
       phoneNumber = [formatter formatForUS:phoneNumber];
        
    
    return phoneNumber;
}

+(NSString*) unescape:(NSString*) string
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@".*?\\+.*?\\+.*?\\+.*?\\+.*?\\+.*?\\+" options:0 error:nil];
    
    
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    
    NSLog(@"%@", modifiedString);
   return modifiedString;

}
@end

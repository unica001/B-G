//
//  CommonFunctions.m
//  BarApp
//
//  Created by Kipl.Sudheer on 24/06/15.
//  Copyright (c) 2015 KT. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions




+ (NSString *)documentsDirectory {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    return [paths objectAtIndex:0];
}


+(void)showAlert:(NSString *)message
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Brown & Greens" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [errorAlert show];
}



+ (int)getDeviceType
{
#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    
#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)
    
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
    
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON)
    
#define IS_IPHONE_6PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON)
    
    static int deviceType = 0;
    if (deviceType == 0) {
        if (IS_IPAD) deviceType = IPAD;
        else if (IS_IPHONE && IS_IPHONE_5) deviceType = IPHONE4INCH;
        else if (IS_IPHONE && IS_IPHONE_6) deviceType = IPHONE4P7INCH;
        else if (IS_IPHONE && IS_IPHONE_6PLUS) deviceType = IPHONE5P5INCH;
        else if (IS_IPHONE) deviceType = IPHONE3P5INCH;
    }
    return deviceType;
}

+ (void) showAlertWithTitle:(NSString*) alertTitle message:(NSString*) message cancelTitle:(NSString*) cancelTitle otherTitle:(NSString*) otherTitle tag:(NSInteger) tag delegate:(id) delegate withDelay:(float) delay
{
    if(IOS_VERSION<8.0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
        [alertView setTag:tag];
        [alertView performSelector:@selector(show) withObject:nil afterDelay:delay];
    }
    else
    {
        
        float delayInSeconds = delay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // code to be executed on the main queue after delay
            UIAlertController *alert;
            
            NSString *alTitle = alertTitle;
            
            if(alTitle == nil || alTitle.length<=0)
                alTitle= @"";
            
            
            alert = [UIAlertController alertControllerWithTitle:alTitle message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:ok];
            
            //            [[CommonFunctions getNavigationControllerTopVC] presentViewController:alert animated:YES completion:nil];
            
        });
    }
}


+(BOOL)isValidNumeric:(NSString*)string{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}

+(UIImage*) loadCachedImageFromURL:(NSString*) urlStr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    if (! [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSData *imageData;
    NSArray *urlComponents = [urlStr componentsSeparatedByString:@"/"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[urlComponents lastObject]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        imageData = [[NSData alloc] initWithContentsOfFile:filePath];
    }
    else
    {
        imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlStr]];
        [imageData writeToFile:filePath atomically:YES];
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}




@end

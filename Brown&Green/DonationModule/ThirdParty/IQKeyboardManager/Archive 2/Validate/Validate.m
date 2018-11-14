//
//  Validate.m
//  GiftMail
//
//  Created by Shivam on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Validate.h"


@implementation Validate

/**
 * Function name isNull                         
 *                                              
 * @params: NSString *str                       
 *                                              
 * @object: function to check a string to null  
 *
 * return BOOL
 */

+ (BOOL)isNull:(NSString*)str{
	if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || str==nil) {
		return YES;
	}
	return NO;
}
/**
 * Function name isValidEmailId                
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid email id  
 *
 * return BOOL
 */
+ (BOOL)isValidEmailId:(NSString*)email
{
    //abc@gmail.com
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
	return [emailTest evaluateWithObject:email];
}
/**
 * Function name isValidMobileNumber           
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid Mobile # 
 *
 * return BOOL
 */
+ (BOOL)isValidMobileNumber:(NSString*)number
{
    number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([number length]<5 || [number length]>17) {
		return FALSE;
	}
	NSString *Regex = @"^([0-9]*)$"; 
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex]; 
	
    return [mobileTest evaluateWithObject:number];
}
/**
 * Function name isValidUserName                
 *                                             
 * @params: NSString                            
 *                                              
 * @object: function to check a valid user name 
 *
 * return BOOL
 */
+ (BOOL) isValidUserName:(NSString*)userName{
    NSString *regex=@"^[a-z0-9_-]{2,15}$";
    NSPredicate *userNameTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [userNameTest evaluateWithObject:userName];
}


/*
 * Function name isValidPassword                
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid password 
 *
 * return BOOL
 */


+ (BOOL) isValidPassword:(NSString*)password{
    NSString *regex=@"^[A-Za-z0-9_-[!#$%&@*()^]]{4,}$";
    NSPredicate *passwordTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [passwordTest evaluateWithObject:password];
}

+ (BOOL) isValidAge:(NSString*)age {
    NSString *regex=@"^[0-9_-]{1,3}$";
    NSPredicate *ageTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [ageTest evaluateWithObject:age];
}

+(BOOL) validateStringContainsAlphabetsOnly:(NSString*)string
{
    //NSLog(@"this is called");
    NSCharacterSet *strCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    strCharSet = [strCharSet invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:strCharSet];
    if (r.location != NSNotFound) {
        return NO;
    }else
        return YES;
}

+(BOOL) validateStringContainsAlphanumericOnly:(NSString*)string
{
    NSCharacterSet *strCharSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    strCharSet = [strCharSet invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:strCharSet];
    if (r.location != NSNotFound) {
        return NO;
    }else
        return YES;
}

+(BOOL)validateZipCode:(NSString *)zipCode{
    //This is validation for zip Code 1111 AB or 1111AB
    NSString *pattern = @"^[0-9]{4}\\s?[a-zA-Z]{2}$";
    NSError *error;
    NSRegularExpression *regularExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange textRange = NSMakeRange(0, zipCode.length);
    NSRange matchRange = [regularExp rangeOfFirstMatchInString:zipCode options:NSMatchingReportProgress range:textRange];
    if (matchRange.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)validateMobileNumber:(NSString *)mobileNumber{
    NSString *pattern = @"^[0-9]{10}$";
    NSError *error;
    NSRegularExpression *regularExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange textRange = NSMakeRange(0,mobileNumber.length);
    NSRange matchRange = [regularExp rangeOfFirstMatchInString:mobileNumber options:NSMatchingReportProgress range:textRange];
    if (matchRange.location != NSNotFound) {
        return YES;
        // //////NSLog(@"valide mobile number");
    }else{
        return NO;
        // //////NSLog(@"invalid mobile number");
    }
}


@end

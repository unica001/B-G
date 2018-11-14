//
//  DHValidation.m
//  ceol
//
//  Created by Ben McRedmond on 24/05/2009.
//  Copyright 2009 Ben McRedmond. All rights reserved.
//

#import <stdarg.h>
#import "DHValidation.h"

// Basic Validators
NSString * const DHValidateAlpha = @"validateAlpha:";
NSString * const DHValidateAlphaSpaces = @"validateAlphaSpaces:";
NSString * const DHValidateAlphaNumeric = @"validateAlphanumeric:";
NSString * const DHValidateAlphaNumericDash = @"validateAlphanumericDash:";
NSString * const DHValidateName = @"validateName:";
NSString * const DHValidateNotEmpty = @"validateNotEmpty:";
NSString * const DHValidateEmail = @"validateEmail:";

// Validations that take second parameters
NSString * const DHValidateMatchesConfirmation = @"validateMatchesConfirmation:";
NSString * const DHValidateMinimumLength = @"validateMinimumLength:";
NSString * const DHValidateCustomAsync = @"asyncValidationMethod:";
NSString * const DHValidateCustom = @"customValidationMethod:";
NSString * const DHCancelAsync = @"cancelAsync:";

@implementation DHValidation

@synthesize delegate;

- (id) init {        
    return [self initWithErrorMessages:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"Letters only",                        DHValidateAlpha,
                        @"Letters and Spaces Only",             DHValidateAlphaSpaces,
                        @"Letters and Numbers Only",            DHValidateAlphaNumeric,
                        @"Letters, Numbers and Dashes Only",    DHValidateAlphaNumericDash,
                        @"Letters only",                        DHValidateName,
                        @"Can't be empty",                      DHValidateNotEmpty,
                        @"Invalid Email Address",               DHValidateEmail, 
                        @"Does not match confirmation",         DHValidateMatchesConfirmation, 
                        @"",                                    DHValidateCustomAsync, 
                        @"",                                    DHValidateCustom, 
                        @"",                                    DHCancelAsync, nil]];
}

- (id) initWithErrorMessages: (NSDictionary *) errors {
    self = [super init];
    
    if(self)
    {
        errorTable = [[NSMutableDictionary alloc] initWithCapacity:7];
        asyncErrorFields = [[NSMutableDictionary alloc] initWithCapacity:1];
        errorStrings = [errors mutableCopy];
    }
    
    return self;
}

//- (void) dealloc {
//    [errorTable release];
//    [errorStrings release];
//    [asyncErrorFields release];
//    [super dealloc];
//}


- (NSArray *) validateObject: (id) object tag: (NSString *) tag errorField: (UITextField *) errorField rules: (NSString * const) firstRule, ... {
    tempErrors = [[NSMutableArray alloc] initWithCapacity:1];

    NSString *nextRule = firstRule;
    currentTag = tag;
    currentErrorField = errorField;
    
    va_list arguments;
    va_start(arguments, firstRule);        
    
    while(nextRule)
    {
        [self validateRule:nextRule candidate:object tag:tag];
        nextRule = va_arg(arguments, NSString * const);
    }

    va_end(arguments);    
    
    [self updateErrorFieldDelegate:errorField withErrors:tempErrors];    
    return tempErrors;
}

- (NSArray *) validateObjectWithParamaters: (id) object tag: (NSString *) tag errorField: (UITextField *) errorField rules: (id) firstRule, ... {
    tempErrors = [[NSMutableArray alloc] initWithCapacity:1];

    id nextObject = firstRule;
    currentTag = tag;
    currentErrorField = errorField;
    
    va_list arguments;
    va_start(arguments, firstRule);
    
    while(nextObject)
    {
        [self validateRuleWithParamater:nextObject candidate:object tag:tag parameter:va_arg(arguments, id)];
        nextObject = va_arg(arguments, id);
    }

    va_end(arguments);
    
    [self updateErrorFieldDelegate:errorField withErrors:tempErrors];    
    return tempErrors;
}

- (void) updateErrorFieldDelegate:errorField withErrors:errors {
    // If they've provided an errorField we'll assume they've setup their delegate
    if(errorField && [delegate respondsToSelector:@selector(updateErrorField:withErrors:)])
    {
        [delegate updateErrorField:errorField withErrors:errors];
    }
}

- (void) validateRule: (NSString * const) rule candidate: (id) candidate tag: (NSString *) tag  {
    [self validateRuleWithParamater:rule candidate: candidate tag:tag parameter:nil];
}

- (void) validateRuleWithParamater: (NSString * const) rule candidate: (id) candidate tag: (NSString *) tag parameter: (id) parameter {
    SEL selector = NSSelectorFromString([rule stringByAppendingString:@"parameter:"]);
    BOOL isValid;
    
    // Check if this method takes a paramter
    if([self respondsToSelector:selector])
    {
        isValid = [self performSelector:selector withObject:candidate withObject:parameter] ? YES : NO;
    }
    else
    {
        selector = NSSelectorFromString(rule);
        isValid = [self performSelector:selector withObject:candidate] ? YES : NO;
    }
    
    [self modifyErrorTable:tag method:rule isValid:isValid];
    if(!isValid) [tempErrors addObject:[errorStrings objectForKey:rule]];
}

- (void) modifyErrorTable: (NSString *) tag method: (NSString * const) method isValid: (BOOL) isValid {
    // Check whether there's an entry already in the error table
    if([errorTable objectForKey:tag] == nil)
        [errorTable setObject:[NSMutableDictionary dictionaryWithCapacity:1] forKey:tag];
    
    // Update the 'table'
    [[errorTable objectForKey:tag] setObject:[NSNumber numberWithBool:isValid] forKey:method];
}

- (int) errorCount {
    int errors = 0;
    
    NSEnumerator *enumerator = [errorTable objectEnumerator];
    NSEnumerator *innerEnumerator;
    
    // The only objects in our table should be mutable dictionaries
    NSMutableDictionary *value;
    NSNumber *innerValue;    

    while((value = [enumerator nextObject]))
    {
        innerEnumerator = [value objectEnumerator];
        while((innerValue = [innerEnumerator nextObject]))
        {
            if(![innerValue boolValue]) ++errors;
        }
    }
    
    return errors;
}

- (int) errorCountForTag: (NSString *) tag {
    int errors = 0;
    
    NSEnumerator *enumerator = [[errorTable objectForKey:tag] objectEnumerator];
    NSNumber *value;
    
    while((value = [enumerator nextObject]))
    {
        if(![value boolValue]) ++errors;
    }
    
    return errors;
}

- (void) reset {
    [errorTable removeAllObjects];
}

// ======================
// = Validation Methods =
// ======================
- (BOOL) validateAlpha: (NSString *) candidate {
    return [self validateStringInCharacterSet:candidate characterSet:[NSMutableCharacterSet letterCharacterSet]];
}

- (BOOL) validateAlphaSpaces: (NSString *) candidate {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

- (BOOL) validateAlphanumeric: (NSString *) candidate {
    return [self validateStringInCharacterSet:candidate characterSet:[NSMutableCharacterSet alphanumericCharacterSet]];
}

- (BOOL) validateAlphanumericDash: (NSString *) candidate {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"-_. "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

- (BOOL) validateName: (NSString *) candidate {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"'- "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

- (BOOL) validateUserName: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


- (BOOL) validateStringInCharacterSet: (NSString *) string characterSet: (NSMutableCharacterSet *) characterSet {
    // Since we invert the character set if it is == NSNotFound then it is in the character set.
    return ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) ? NO : YES;
}

- (BOOL) validateNotEmpty: (NSString *) candidate {
    return ([candidate length] == 0) ? NO : YES;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 

    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)isValidEmailId:(NSString*)email
{
    //abc@gmail.com
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validatePhone:(NSString*)phone {
  
    NSString *phoneRegex = @"^(\\+){0,1}(\\d|\\s|\\(|\\)){3,18}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [test evaluateWithObject:phone];
}

- (BOOL)validateCompareDate:(NSString*)startTStamp endDate:(NSString*)endTStamp {
    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:[startTStamp doubleValue]];
    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:[endTStamp doubleValue]];

    NSComparisonResult comparison = [startDate compare:endDate];
        if (comparison == NSOrderedAscending)
            return YES;
        else
            return NO;
  
}
- (BOOL)validatePassword:(NSString *)password {
    
    // 1. Upper case.
  
    if ([[password componentsSeparatedByCharactersInSet:[NSCharacterSet uppercaseLetterCharacterSet]] count] < 2)
        return NO;
    
    if ([[password componentsSeparatedByCharactersInSet:[NSCharacterSet lowercaseLetterCharacterSet]] count] < 2)
        return NO;
    
//    // 2. Length.
//    if ([password length] < 6)
//        return NO;
    
    // 3. Special characters.
    // Change the specialCharacters string to whatever matches your requirements.
//    NSString *specialCharacters = @"!#€%&/()[]=?$§*'";
//    if ([[password componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:specialCharacters]] count] < 2)
//        return NO;
    
    // 4. Numbers.
    if ([[password componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] count] < 2)
        return NO;
    
    return YES;
}

- (BOOL) validateMatchesConfirmation: (NSString *) candidate parameter: (NSString *) confirmation {
    return [candidate isEqualToString:confirmation];
}

- (BOOL) validateMinimumLength: (NSString *) candidate parameter: (int) length {
    [errorStrings setObject:[NSString stringWithFormat:@"Not longer than %d characters", length] forKey:DHValidateMinimumLength];
	
	//NSLog(@"%d",[candidate length]);
    return ([candidate length] == length) ? YES : NO;
}

// This is to allow thing like making a web request to make a validation
// For example to check if a username is available.
- (void) asyncValidationMethod: (id) candidate parameter: (NSInvocation *) invocation {    
    // Make us the delegate of this DHass, so we get the response
    [[invocation target] setDelegate:self];
    
    [invocation setArgument:&candidate atIndex:2];
    [invocation invoke];
    
    //[asyncErrorFields setObject:currentErrorField forKey:currentTag];
}

- (void) asyncMethodComplete: (NSString *) tag withResult: (BOOL) result withMessage: (NSString *) message {
    if(!result) [delegate updateErrorField:[asyncErrorFields objectForKey:tag] withErrors:[NSArray arrayWithObject:message]];
    [self modifyErrorTable:tag method:DHValidateCustomAsync isValid:result];
    [asyncErrorFields removeObjectForKey:tag];
}

- (id) customValidationMethod: (id) candidate parameter: (NSInvocation *) invocation {
    if([[invocation target] respondsToSelector:@selector(errorMessageFor:)])
    {
        NSString *method; 
        [invocation getArgument:&method atIndex:3];
        
        NSString *errorMessage = [[invocation target] errorMessageFor:method];
        [errorStrings setObject:errorMessage forKey:DHValidateCustom];
    }
    
    [invocation setArgument:&candidate atIndex:2];
    [invocation invoke];
    
    id returnValue;
    [invocation getReturnValue:&returnValue];

    return returnValue;
}

- (BOOL) cancelAsync: (id) candidate parameter: (NSArray *) tagAndTarget {
    [[tagAndTarget objectAtIndex:1] cancelAsync:[tagAndTarget objectAtIndex:0]];
    [self modifyErrorTable:[tagAndTarget objectAtIndex:0] method:DHValidateCustomAsync isValid:YES];
    return YES;
}

-(BOOL)usernameWhiteSpaewith:(NSString*)username
{
  BOOL returnValue=NO;
  NSRange whiteSpaceRange = [username rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
  if (whiteSpaceRange.location != NSNotFound) {
    returnValue=YES;
      }
  
  return returnValue;
}


@end

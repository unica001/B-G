//
//  DHValidation.h
//  ceol
//
//  Created by Ben McRedmond on 24/05/2009.
//  Copyright 2009 Ben McRedmond. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const DHValidateAlpha;
extern NSString * const DHValidateAlphaSpaces;
extern NSString * const DHValidateAlphaNumeric;
extern NSString * const DHValidateAlphaNumericDash;
extern NSString * const DHValidateName;
extern NSString * const DHValidateNotEmpty;
extern NSString * const DHValidateEmail;
extern NSString * const DHValidateMatchesConfirmation;
extern NSString * const DHValidateMinimumLength;
extern NSString * const DHValidateCustomAsync;
extern NSString * const DHValidateCustom;
extern NSString * const DHCancelAsync;

@protocol DHValidationDelegate  <NSObject>

@optional
- (void) updateErrorField: (id) errorField withErrors: (NSArray *) errors;
- (NSString *) errorMessageFor: (NSString *) method;
- (void) cancelAsync:(id) tagAndTarget;
@end

@interface DHValidation : NSObject<NSFileManagerDelegate>
{
    NSMutableDictionary *errorTable;
    NSMutableDictionary *errorStrings;
    
    NSMutableDictionary *asyncErrorFields;
    BOOL asyncInProgress;
    
    NSString *currentTag;
    UITextField *currentErrorField;
    
   // id delegate;      /// need to change
    
    // Variables for this validation only
    NSMutableArray *tempErrors;
}

@property (assign) id <DHValidationDelegate> delegate;

- (id) initWithErrorMessages: (NSDictionary *) errors;

- (NSArray *) validateObject: (id) object tag: (NSString *) tag errorField: (UITextField *) errorField rules: (NSString * const) firstRule, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray *) validateObjectWithParamaters: (id) object tag: (NSString *) tag errorField: (UITextField *) errorField rules: (id) firstRule, ... NS_REQUIRES_NIL_TERMINATION;
- (void) validateRule: (NSString * const) rule candidate: (id) candidate tag: (NSString *) tag;
- (void) validateRuleWithParamater: (NSString * const) rule candidate: (id) candidate tag: (NSString *) tag parameter: (id) parameter;
- (void) modifyErrorTable: (NSString *) tag method: (NSString * const) method isValid: (BOOL) isValid;
- (int) errorCount;
- (int) errorCountForTag: (NSString *) tag;
- (void) reset;

// Delegates
- (void) updateErrorFieldDelegate:errorField withErrors:errors;

// Basic Validators
- (BOOL) validateAlpha: (NSString *) candidate;
- (BOOL) validateAlphaSpaces: (NSString *) candidate;
- (BOOL) validateAlphanumeric: (NSString *) candidate;
- (BOOL) validateAlphanumericDash: (NSString *) candidate;
- (BOOL) validateStringInCharacterSet: (NSString *) string characterSet: (NSMutableCharacterSet *) characterSet;
- (BOOL) validateNotEmpty: (NSString *) candidate;
- (BOOL) validateEmail: (NSString *) candidate;
- (BOOL) validateName: (NSString *) candidate;
- (BOOL) validatePassword:(NSString *)password ;
- (BOOL) validatePhone:(NSString*)phone ;
- (BOOL)isValidEmailId:(NSString*)email;
- (BOOL) validateUserName: (NSString *) candidate;


// Complex validators (requires second parameter)
- (BOOL) validateMatchesConfirmation: (NSString *) candidate parameter: (NSString *) confirmation;
- (BOOL) validateMinimumLength: (NSString *) candidate parameter: (int) length;
- (void) asyncValidationMethod: (id) candidate parameter: (NSInvocation *) invocation;
- (void) asyncMethodComplete: (NSString *) tag withResult: (BOOL) result withMessage: (NSString *) message;
- (BOOL)validateCompareDate:(NSString*)startTStamp endDate:(NSString*)endTStamp ;
// Valiator Cancels
- (BOOL) cancelAsync: (id) candidate parameter: (NSArray *) tagAndTarget;
-(BOOL)usernameWhiteSpaewith:(NSString*)username;
@end
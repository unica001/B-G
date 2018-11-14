//
//  Control.m
//  TRLUser
//
//  Created by Jitender on 12/16/16.
//  Copyright © 2016 Jitender. All rights reserved.
//

#import "Control.h"

@implementation Control

#pragma mark - VALIDATING EMPTY TEXTFIELD

+ (UITextField *)newTextFieldWithOptions:(NSMutableDictionary *)options frame:(CGRect)frame delgate:(id)delegate{
    //Intilization and assign delegate
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = delegate;
//    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    //Setup Textfields option here
    if ([options valueForKey:kTextFeildOptionKeyboardType]) {
        textField.keyboardType = [[options valueForKey:kTextFeildOptionKeyboardType] intValue];
    }
    if ([options valueForKey:kTextFeildOptionReturnType]) {
        textField.returnKeyType = [[options valueForKey:kTextFeildOptionReturnType] intValue];
    }
    
    if ([options valueForKey:kTextFeildOptionAutocorrectionType]) {
        textField.autocorrectionType = [[options valueForKey:kTextFeildOptionAutocorrectionType] intValue];
    }
    
    if ([options valueForKey:kTextFeildOptionAutocapitalizationType]) {
        textField.autocapitalizationType = [[options valueForKey:kTextFeildOptionAutocapitalizationType] intValue];
    }
    
    if ([options valueForKey:kTextFeildOptionIsPassword]) {
        textField.secureTextEntry = [[options valueForKey:kTextFeildOptionIsPassword] intValue];
    }
    
    if ([options valueForKey:kTextFeildOptionPlaceholder]) {
        textField.placeholder = [options valueForKey:kTextFeildOptionPlaceholder];
    }
    
    if ([options valueForKey:kTextFeildOptionFont]) {
        textField.font = [options valueForKey:kTextFeildOptionFont];
    }
    else{
        textField.font = kDefaultFontForTextField;
    }
    
    return textField;
}



@end

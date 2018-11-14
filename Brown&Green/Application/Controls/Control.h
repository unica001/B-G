//
//  Control.h
//  TRLUser
//
//  Created by Jitender on 12/16/16.
//  Copyright © 2016 Jitender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Control : NSObject

#pragma mark - Application TextField

+ (UITextField *)newTextFieldWithOptions:(NSMutableDictionary *)options frame:(CGRect)frame delgate:(id)delegate;

@end

//
//  PhoneNumberFormatter.h
//  ContactsFree
//
//  Created by ITGC on 9/21/11.
//  Copyright 2011 Micheal's MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhoneNumberFormatter : NSObject {
	NSDictionary *predefinedFormats;
}

- (NSString *)formatForUS:(NSString *)phoneNumber;

@end

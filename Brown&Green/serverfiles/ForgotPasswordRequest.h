//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol ForgotPasswordRequestDelegate

@required
-(void)ForgotPasswordRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)ForgotPasswordRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface ForgotPasswordRequest : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

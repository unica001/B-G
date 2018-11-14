//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol SignupUserServerRequestDelegate

@required
-(void)SignupUserServerRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)SignupUserServerRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface SignupUserServerRequest : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

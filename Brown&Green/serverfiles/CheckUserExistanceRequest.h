//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol CheckUserExistanceRequestDelegate

@required
-(void)CheckUserExistanceRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)CheckUserExistanceRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface CheckUserExistanceRequest : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

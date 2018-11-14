//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol UpdateOneTimeOrderRequestDelegate

@required

-(void)UpdateOneTimeOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)UpdateOneTimeOrderRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface UpdateOneTimeOrderRequest : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

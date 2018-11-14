//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol CancelOrderRequestDelegate

@required
-(void)CancelOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)CancelOrderRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface CancelOrder : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

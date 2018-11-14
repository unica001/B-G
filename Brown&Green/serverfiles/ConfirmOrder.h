//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol ConfirmOrderRequestDelegate

@required
-(void)ConfirmOrderRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)ConfirmOrderRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface ConfirmOrder : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

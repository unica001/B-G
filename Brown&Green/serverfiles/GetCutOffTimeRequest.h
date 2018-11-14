//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol GetCutOffTimeRequestDelegate

@required
-(void)GetCutOffTimeRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)GetCutOffTimeRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface GetCutOffTimeRequest : IOFServer{
}
-(id)initWithGet;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol GetSummaryDetailRequestDelegate

@required
-(void)GetSummaryDetailRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)GetSummaryDetailRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface GetSummaryDetail : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

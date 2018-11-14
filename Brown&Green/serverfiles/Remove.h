//
//  SignupUserServerRequest.h
//  MPR
//
//  Created by Haider Abbas on 06/12/13.
//  Copyright (c) 2013 Haider Abbas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOFServer.h"

@protocol RemovePromoCodeRequestDelegate

@required
-(void)RemovePromoCodeRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)RemovePromoCodeRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface Remove : IOFServer{
}
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;

@end

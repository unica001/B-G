//
//  PaskrServer.m
//  PaskrRelayLite
//
//  Created by Vineet on 08/04/13.
//  Copyright (c) 2013 Vineet. All rights reserved.
//

#import "IOFServer.h"

@implementation IOFServer
@synthesize requestDelegate = mRequestDelegate,
isSuccess = mIsSuccess,
responseStatus = mResponseStatus,
responseMessage = mResponseMessage;



- (id)initWithURL:(NSURL *)requestUrl
{
    if(self = [super initWithURL:requestUrl])
    {
        self.isSuccess = NO;
        self.responseStatus = 0;
        self.responseMessage = @"";
        [super setTimeOutSeconds:90];
    }
    return self;
}




- (void)parseResponseHeader:(NSDictionary *)responseDictionary
{
    if((responseDictionary != nil) && ([responseDictionary count] > 0) )
    {
        //		self.responseStatus  =   [[responseDictionary  objectForKey:@"s"] intValue];
        //		self.responseMessage =   [responseDictionary  objectForKey:@"e"];
        //
        //		if(self.responseStatus == 1)
        //		{
        //			self.isSuccess = YES;
        //		}
    }
    
}

@end

//
//  CreateLead.m
//  OSTLite
//
//  Created by Gaurav Dalal on 17/02/14.
//  Copyright (c) 2014 ITGCMAC2. All rights reserved.
//

#import "GetCutOffTimeRequest.h"
#import "SBJSON.h"

@implementation GetCutOffTimeRequest

- (id)initWithGet{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,GETCUTOFFTIME];
    if(self = [super initWithURL:[NSURL URLWithString:url]])    {
      
        [self setRequestMethod:@"GET"];
      
        [self addRequestHeader:@"Accept" value:@"application/json"];
        [self addRequestHeader:@"content-type" value:@"application/json"];
        [self setDelegate:self];
    }
    return self;
}

- (void)requestFinished:(ASIHTTPRequest *)req{
    NSString *responseString = [req responseString];
    NSLog(@"Response_GetCutOffTimeRequest= %@",responseString);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSError *err = nil;
  self.dictionary  = [parser objectWithString:responseString error:&err];
    
    [super parseResponseHeader:self.dictionary];
    //NSMutableDictionary *dataDictionary = [self.dictionary valueForKey:PAYLOAD];
    
    if(self.requestDelegate != nil && ([self.requestDelegate conformsToProtocol:@protocol(GetCutOffTimeRequestDelegate)]))
    {
        if (![[self.dictionary valueForKey:CODE] isEqualToString:OK] ) {
            
            NSString *ErrorMsg = [NSString stringWithFormat:@"%@",[self.dictionary valueForKey:ERRORMSG]];
            
            [self.requestDelegate performSelectorOnMainThread:@selector(GetCutOffTimeRequestFailedWithErrorMessage:) withObject:ErrorMsg waitUntilDone:NO];
        }
        else {
            
            [self.requestDelegate performSelectorOnMainThread:@selector(GetCutOffTimeRequestFinishedWithSuccessMessage:) withObject:self.dictionary waitUntilDone:NO];
        }
    }
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)req{
    NSString *responseString = [req responseString];
    NSLog(@"Response_GetCutOffTimeRequest= %@",responseString);

    if(self.requestDelegate != nil && ([self.requestDelegate conformsToProtocol:@protocol(GetCutOffTimeRequestDelegate)]))
    {
        [self.requestDelegate performSelectorOnMainThread:@selector(GetCutOffTimeRequestFailedWithErrorMessage:) withObject:@"Request cannot be completed" waitUntilDone:NO];
    }
}
@end

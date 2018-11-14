//
//  CreateLead.m
//  OSTLite
//
//  Created by Gaurav Dalal on 17/02/14.
//  Copyright (c) 2014 ITGCMAC2. All rights reserved.
//

#import "GetSummaryDetail.h"
#import "SBJSON.h"

@implementation GetSummaryDetail

- (id)initWithDict:(NSMutableDictionary *)inDict{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,GETSUMMARYDETAILS];
    if(self = [super initWithURL:[NSURL URLWithString:url]])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inDict options:NSJSONWritingPrettyPrinted error:&error];
        [self setRequestMethod:@"POST"];
        [self appendPostData:jsonData];
        [self addRequestHeader:@"Accept" value:@"application/json"];
        [self addRequestHeader:@"content-type" value:@"application/json"];
        [self setDelegate:self];
    }
    return self;
}

- (void)requestFinished:(ASIHTTPRequest *)req{
    NSString *responseString = [req responseString];
    
    NSLog(@"Response_GetSummaryDetail= %@",responseString);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSError *err = nil;
    self.dictionary  = [parser objectWithString:responseString error:&err];
    
    [super parseResponseHeader:self.dictionary];
    //NSMutableDictionary *dataDictionary = [self.dictionary valueForKey:PAYLOAD];
    
    if(self.requestDelegate != nil && ([self.requestDelegate conformsToProtocol:@protocol(GetSummaryDetailRequestDelegate)]))
    {
        if (![[self.dictionary valueForKey:CODE] isEqualToString:OK] ) {
            
            NSString *ErrorMsg = [NSString stringWithFormat:@"%@",[self.dictionary valueForKey:ERRORMSG]];
            
            [self.requestDelegate performSelectorOnMainThread:@selector(GetSummaryDetailRequestFailedWithErrorMessage:) withObject:ErrorMsg waitUntilDone:NO];
        }
        else {
            
            [self.requestDelegate performSelectorOnMainThread:@selector(GetSummaryDetailRequestFinishedWithSuccessMessage:) withObject:self.dictionary waitUntilDone:NO];
        }
    }
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)req{
    NSString *responseString = [req responseString];
    
    NSLog(@"Response_GetSummaryDetail= %@",responseString);

    if(self.requestDelegate != nil && ([self.requestDelegate conformsToProtocol:@protocol(GetSummaryDetailRequestDelegate)]))
    {
        [self.requestDelegate performSelectorOnMainThread:@selector(GetSummaryDetailRequestFailedWithErrorMessage:) withObject:@"Request cannot be completed" waitUntilDone:NO];
    }
}
@end

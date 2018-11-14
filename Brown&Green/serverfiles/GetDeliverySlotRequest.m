//
//  GetDeliverySlotRequest.m
//  iOrderFresh
//
//  Created by priya on 27/08/15.
//  Copyright (c) 2015 ashish. All rights reserved.
//

#import "GetDeliverySlotRequest.h"
#import "SBJSON.h"
@implementation GetDeliverySlotRequest
- (id)initWithDict:(NSMutableDictionary *)inDict{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,GetDeliverySlot];
    if(self = [super initWithURL:[NSURL URLWithString:url]])
    {
        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inDict options:NSJSONWritingPrettyPrinted error:&error];
        [self setRequestMethod:@"GET"];
//        [self appendPostData:jsonData];
        [self addRequestHeader:@"Accept" value:@"application/json"];
        [self addRequestHeader:@"content-type" value:@"application/json"];
        [self setDelegate:self];
    }
    return self;
}

- (void)requestFinished:(ASIHTTPRequest *)req{
    
    NSString *responseString = [req responseString];
    
    NSLog(@"Response_GetDeliverySlotRequest= %@",responseString);
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSError *err = nil;
    self.dictionary  = [parser objectWithString:responseString error:&err];
    
    [super parseResponseHeader:self.dictionary];
    //NSMutableDictionary *dataDictionary = [self.dictionary valueForKey:PAYLOAD];
    
    if(self.requestDelegate != nil && ([self.requestDelegate conformsToProtocol:@protocol(GetDeliverySlotRequestDelegate)]))
    {
        if (![[self.dictionary valueForKey:CODE] isEqualToString:OK] ) {
            
            NSString *ErrorMsg = [NSString stringWithFormat:@"%@",[self.dictionary valueForKey:ERRORMSG]];
            
            [self.requestDelegate performSelectorOnMainThread:@selector(GetDeliverySlotRequestFailedWithErrorMessage:) withObject:ErrorMsg waitUntilDone:NO];
        }
        else {
            
            [self.requestDelegate performSelectorOnMainThread:@selector(GetDeliverySlotRequestFinishedWithSuccessMessage:) withObject:self.dictionary waitUntilDone:NO];
        }
    }
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)req{
    NSString *responseString = [req responseString];
    
    NSLog(@"Response_GetDeliverySlotRequest= %@",responseString);
    if(self.requestDelegate != nil && ([self.requestDelegate conformsToProtocol:@protocol(GetDeliverySlotRequestDelegate)]))
    {
        [self.requestDelegate performSelectorOnMainThread:@selector(GetDeliverySlotRequestFailedWithErrorMessage:) withObject:@"Request cannot be completed" waitUntilDone:NO];
    }
}

@end

//
//  GetDeliverySlotRequest.h
//  iOrderFresh
//
//  Created by priya on 27/08/15.
//  Copyright (c) 2015 ashish. All rights reserved.
//

#import "IOFServer.h"
@protocol GetDeliverySlotRequestDelegate
@required

-(void)GetDeliverySlotRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
-(void)GetDeliverySlotRequestFailedWithErrorMessage:(NSString *)inFailedData;

@end

@interface GetDeliverySlotRequest : IOFServer
-(id)initWithDict:(NSMutableDictionary *)inDict;

@property (nonatomic, retain) NSMutableDictionary *mainDict;
@property (nonatomic, retain) NSDictionary *dictionary;
@end

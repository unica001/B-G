//
//  ChangePassword.h
//  OSTLite
//
//  Created by Gaurav Dalal on 06/03/14.
//  Copyright (c) 2014 ITGCMAC2. All rights reserved.
//

#import "IOFServer.h"

@protocol TabelRecordsDelegate

@required
- (void)tabelRecordsRequestFinishedWithSuccessMessage:(NSMutableDictionary *)inData;
- (void)tabelRecordsRequestFailedWithErrorMessage:(NSString *)inMessage;
@end



@interface TabelRecords : IOFServer
@property(strong,nonatomic) NSDictionary *dictionary;

-(id)initWithDict:(NSMutableDictionary *)inDict;
@end


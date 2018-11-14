#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface IOFServer : ASIFormDataRequest {
    id mRequestDelegate;
    BOOL mIsSuccess;
    
    NSInteger mResponseStatus;
    NSString  *mResponseMessage;
    
}

@property (nonatomic) BOOL isSuccess;
@property (nonatomic) NSInteger responseStatus;
@property (nonatomic, retain) NSString  *responseMessage;
@property (nonatomic, retain) id requestDelegate;

- (id)initWithURL:(NSURL *)requestUrl;
- (void)parseResponseHeader:(NSDictionary *)responseDictionary;

@end


//
//  ConnectionManager.h
//  WebServiceBlocks
//
//  Created by ios on 11/8/16.
//  Copyright © 2016 Naren. All rights reserved.
//

/***************************\ *
 * Class Name : - ConnectionManager
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - Network manager class having a singleton object.
 * Organisation Name :- Sirez
 * version no :- 1.0
 * Modified By :- Vineet kumar Patidar
 * Modified Date :-
 * Modified Reason :-
 * \***************************/

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define KAppName @"Brown&Green"

typedef void (^kResultBlock)(NSDictionary *dictionary, NSError *error);
typedef NS_ENUM(NSInteger, kHttpMethodType) {
    kHttpMethodTypeGet      = 0,    // GET
    kHttpMethodTypePost     = 1,    // POST
    kHttpMethodTypeDelete   = 2,    // DELETE
    kHttpMethodTypePut      = 3     // PUT
};

typedef NS_ENUM(NSInteger, kHttpStatusCode) {
    kHttpStatusCodeOK   = 0,    //200 SUCCESS
    kHttpStatusCodeNoResponse   = 1,    //204 NO RESPONSE
    kHttpStatusCodeBadRequest   = 2,    //400 BAD REQUEST
    kHttpStatusCodeUnAuthorized   = 3,    //401 UNAUTHORIZED
    kHttpStatusCodeNoSession   = 4,    //404 NO SESSION
};



@interface ConnectionManager : NSObject

+(ConnectionManager *)sharedInstance;

- (void)sendPOSTRequestForURL:(NSString *)url params:(NSMutableDictionary*)paramsData timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;
- (void)sendGETRequestForURL:(NSString *)url params:(NSMutableDictionary*)paramsData timeoutInterval:(NSTimeInterval)timeoutInterval showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

- (void)sendPUTRequestForURL:(NSString *)strUrl params:(NSMutableDictionary*)paramsDict timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

//-(void)uploadImageToS3WithThumbnail:(UIImage *)image fileName:(NSString *)fileName completion:(kResultBlock)completion;
//-(void)uploadImageToS3:(UIImage *)image fileName:(NSString *)fileName completion:(kResultBlock)completion;
- (void)ShowMBHUDLoader;
- (void)hideMBHUDLoader;

///Kiran


- (void) startRequestWithHttpMethod:(kHttpMethodType) httpMethodType withHttpHeaders:(NSMutableDictionary*) headers withServiceName:(NSString*) serviceName withParameters:(NSMutableDictionary*) params withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) uploadImagewithHttpHeaders:(NSMutableDictionary*)headers withParameters:(NSMutableDictionary*)params withServiceName:(NSString*)serviceName withFilePath:(NSURL*)filePath withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void) startRequestForMultipartFormDataWithHttpHeaders:(NSMutableDictionary*) headers withServiceName:(NSString*) serviceName withParameters:(NSMutableDictionary*) params withImageFile:(BOOL)isImagefile withImageInfo:(NSData*) imageInfo withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




@end

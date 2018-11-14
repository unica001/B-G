//
//  ConnectionManager.m
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
 * Modified Date :- 18th Nov 2016
 * Modified Reason :- Modifiy the Webservice method and Add uplaod Image S3 functions
 * \***************************/

#import "ConnectionManager.h"

@implementation ConnectionManager

static ConnectionManager *connectionManagerSharedInstance = nil;

/***************************\ *
 * Function Name : - Creation Singleton Object
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - Creating a singleton object for the class to be used in entire project for network calls.
 * Organisation Name :- Sirez
 * version no :- 1.0
 * \***************************/

+(ConnectionManager *)sharedInstance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        connectionManagerSharedInstance = [[ConnectionManager alloc] init];
    });
    return connectionManagerSharedInstance;
}

/***************************\ *
 * Function Name : - Post Method
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - Post call for posting data to server .
 * Organisation Name :- Sirez
 * version no :- 1.0
 * Modified Date :- 17th Nov 2016
 * Modified Reason :- Making Improving in naming conventions
 * \***************************/

- (void)sendPOSTRequestForURL:(NSString *)strUrl params:(NSMutableDictionary*)paramsDict timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion
{
    if (showHUD == YES) {
        [self ShowMBHUDLoader];
    }
    
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDict
                                                       options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [urlRequest setValue:@"Accept" forHTTPHeaderField:@"Content-Type"];

    [urlRequest setValue:@"1.1" forHTTPHeaderField:@"version"];
    
    
    
    NSLog(@"Parameter %@",paramsDict);
    
//    NSData *paramData = [self createPostHttpBody:paramsDict];
   // NSData *paramData = [self createPostHttpBody:paramsDict];

    
    urlRequest.HTTPBody = jsonData;
    urlRequest.timeoutInterval = timeoutInterval;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                      if (showHUD) {
                                          [self hideMBHUDLoader];
                                      }
                                      
                                      NSLog(@"connection Error %@",connectionError);
                                      
                                      if (!connectionError) {
                                          
                                          NSError* error;
                                          
                                          NSString *newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          
                                          NSLog(@"Json String :- %@",newStr);
                                          
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:NSJSONReadingMutableContainers
                                                                                                 error:&error];
                                          if (error) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  if (showSystemError == YES) {
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                      [alert show];
                                                  }
                                                  
                                              });
                                              completion(nil,error);
                                          }
                                          else{
                                              
                                              
                                              if ([[json valueForKey:kAPICode] intValue] == -1) {
                                                  NSString *payloadString = [json valueForKey:@"payload"];
                                                  NSError *error;
                                                  NSDictionary *jsonExtracted = [NSJSONSerialization JSONObjectWithData:[payloadString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                                options:NSJSONReadingMutableContainers error:&error];
                                                  
                                                  if(error){
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          if (showSystemError == YES) {
                                                              
                                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                              [alert show];
                                                          }
                                                      });
                                                      completion(nil,error);
                                                  }
                                                  else{
                                                      
                                                      NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : [jsonExtracted valueForKey:kAPIMessage]};
                                                      
                                                      NSError *pupSmoochError = [NSError errorWithDomain:kUNKCUSTOMError code:[[jsonExtracted valueForKey:kAPIErrorCode] integerValue] userInfo:errorDictionary];
                                                      completion(nil,pupSmoochError);
                                                  }
                                              }
                                              else{
                                                  completion(json,connectionError);
                                              }
                                              
                                          }
                                          
                                      }
                                      else{
                                          // No internet or connection timed out condition
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //Request TimeOut
                                              if ((connectionError.code == -1000 || connectionError.code == -1002 || connectionError.code == -1003 || connectionError.code == -1004 || connectionError.code == -1008 || connectionError.code == -1011)&& showSystemError == YES)
                                              {
                                                  
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  
                                              }
                                              //Invalid Domin or bad request
                                              else if (connectionError.code == -1001 && showSystemError == YES)
                                              {
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgServerNotResponding delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  
                                              }
                                              //NetworkConection Lost Or Internet Not Working Lost
                                              else if ((connectionError.code == -1005 || connectionError.code == -1009) && showSystemError == YES)
                                              {
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                              }
                                              else
                                              {
                                                  if (showSystemError == YES) {
                                                      
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:connectionError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                      [alert show];
                                                  }
                                                  
                                              }
                                          });
                                          completion(nil,connectionError);
                                      }
                                      
                                  }];
    [task resume];
}

/***************************\ *
 * Function Name : - Post Method
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - Post call for posting data to server .
 * Organisation Name :- Sirez
 * version no :- 1.0
 * Modified Date :- 17th Nov 2016
 * Modified Reason :- Making Improving in naming conventions
 * \***************************/

- (void)sendPUTRequestForURL:(NSString *)strUrl params:(NSMutableDictionary*)paramsDict timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion
{
    
    
    //username and password value
  /*  NSString *merchentName = KpaymentMerchentName;
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", [merchentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], KPaymentMerchantpassword];
   NSData *authData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString* authStrData = [[NSString alloc] initWithData:[authData base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed] encoding:NSASCIIStringEncoding];*/
    // Forming Basic Authorization string Header
    
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", KpaymentMerchentName, KPaymentMerchantpassword];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64EncodedStringWithOptions:0];
    
    if (showHUD == YES) {
        [self ShowMBHUDLoader];
    }
    
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDict
                                                       options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    
  //  NSURL *URL = [NSURL URLWithString:strUrl];
    NSURL *URL = [[NSURL alloc] initWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    urlRequest.HTTPMethod = @"PUT";
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    
    NSLog(@"Parameter %@",paramsDict);
    
    //    NSData *paramData = [self createPostHttpBody:paramsDict];
    // NSData *paramData = [self createPostHttpBody:paramsDict];
    
    
    urlRequest.HTTPBody = jsonData;
    urlRequest.timeoutInterval = timeoutInterval;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                      if (showHUD) {
                                          [self hideMBHUDLoader];
                                      }
                                      
                                      NSLog(@"connection Error %@",connectionError);
                                      
                                      if (!connectionError) {
                                          
                                          NSError* error;
                                          
                                          NSString *newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          
                                          NSLog(@"Json String :- %@",newStr);
                                          
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:NSJSONReadingMutableContainers
                                                                                                 error:&error];
                                          if (error) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  if (showSystemError == YES) {
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                      [alert show];
                                                  }
                                                  
                                              });
                                              completion(nil,error);
                                          }
                                          else{
                                              
                                              
                                              if ([[json valueForKey:kAPICode] intValue] == -1) {
                                                  NSString *payloadString = [json valueForKey:@"payload"];
                                                  NSError *error;
                                                  NSDictionary *jsonExtracted = [NSJSONSerialization JSONObjectWithData:[payloadString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                                options:NSJSONReadingMutableContainers error:&error];
                                                  
                                                  if(error){
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          if (showSystemError == YES) {
                                                              
                                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                              [alert show];
                                                          }
                                                      });
                                                      completion(nil,error);
                                                  }
                                                  else{
                                                      
                                                      NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : [jsonExtracted valueForKey:kAPIMessage]};
                                                      
                                                      NSError *pupSmoochError = [NSError errorWithDomain:kUNKCUSTOMError code:[[jsonExtracted valueForKey:kAPIErrorCode] integerValue] userInfo:errorDictionary];
                                                      completion(nil,pupSmoochError);
                                                  }
                                              }
                                              else{
                                                  completion(json,connectionError);
                                              }
                                              
                                          }
                                          
                                      }
                                      else{
                                          // No internet or connection timed out condition
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //Request TimeOut
                                              if ((connectionError.code == -1000 || connectionError.code == -1002 || connectionError.code == -1003 || connectionError.code == -1004 || connectionError.code == -1008 || connectionError.code == -1011)&& showSystemError == YES)
                                              {
                                                  
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  
                                              }
                                              //Invalid Domin or bad request
                                              else if (connectionError.code == -1001 && showSystemError == YES)
                                              {
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgServerNotResponding delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  
                                              }
                                              //NetworkConection Lost Or Internet Not Working Lost
                                              else if ((connectionError.code == -1005 || connectionError.code == -1009) && showSystemError == YES)
                                              {
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                              }
                                              else
                                              {
                                                  if (showSystemError == YES) {
                                                      
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:connectionError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                      [alert show];
                                                  }
                                                  
                                              }
                                          });
                                          completion(nil,connectionError);
                                      }
                                      
                                  }];
    [task resume];
}
/***************************\ *
 * Function Name : - Get Method
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - Get call for fetching data from server .
 * Organisation Name :- Sirez
 * version no :- 1.0
 * \***************************/

- (void)sendGETRequestForURL:(NSString *)strUrl params:(NSMutableDictionary*)paramsData timeoutInterval:(NSTimeInterval)timeoutInterval showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // [self ShowMBHUDLoader];
    });
    
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    urlRequest.HTTPMethod = @"GET";
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    urlRequest.HTTPBody = nil;
    
    if (paramsData != nil) {
        
        NSString * urlString = [self createGetUrl:paramsData];
        NSLog(@"%@", urlString);
        
        if([strUrl hasSuffix:@"?"])
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",strUrl,urlString]];
        }
        else
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",strUrl,urlString]];
        }
        
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                      
                                      // No internet or connection timed out condition
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (connectionError.code == -1001)
                                          {
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:KAppName message:@"Connection timed out. Check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                              [alert show];
                                              
                                          }
                                      });
                                      
                                      [self hideMBHUDLoader];
                                      
                                      if (!connectionError) {
                                          
                                          NSError* error;
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:kNilOptions
                                                                                                 error:&error];
                                          if (error) {
                                              completion(nil,error);
                                          }
                                          else{
                                              
                                              completion(json,connectionError);
                                          }
                                          
                                      }
                                      else{
                                          completion(nil,connectionError);
                                          
                                      }
                                      
                                  }];
    [task resume];
}

/***************************\ *
 * Function Name : - Create Post HTTP Body
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - This method is used for converting dictionary into data that needs to be posted in the post call.
 * Organisation Name :- Sirez
 * version no :- 1.0
 * Modified Date :-
 * Modified Reason :-
 * \***************************/

- (NSData *)createPostHttpBody : (NSMutableDictionary *)sharingDictionary
{
    NSMutableArray * parameterArray = [[NSMutableArray alloc]init];
    
    for (NSString * keyValue in sharingDictionary.allKeys)
    {
        NSString* keyString = [NSString stringWithFormat:@"%@=%@",keyValue,[sharingDictionary valueForKey:keyValue]];
        [parameterArray addObject:keyString];
    }
    
    NSString * postString;
    postString = [parameterArray componentsJoinedByString:@"&"];
    NSLog(@"%@", postString);
    
    return [postString dataUsingEncoding:NSUTF8StringEncoding];
}

/***************************\ *
 * Function Name : - Create Get Url
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - This method is used for converting dictionary into values and appending them in the base url that needs to be called in the get call.
 * Organisation Name :- Sirez
 * version no :- 1.0
 * \***************************/

- (NSString *)createGetUrl : (NSMutableDictionary *)sharingDictionary
{
    NSMutableArray * parameterArray = [[NSMutableArray alloc]init];
    
    for (NSString * keyValue in sharingDictionary.allKeys)
    {
        NSString* keyString = [NSString stringWithFormat:@"%@=%@",keyValue,[sharingDictionary valueForKey:keyValue]];
        [parameterArray addObject:keyString];
    }
    
    NSString * postString;
    postString = [parameterArray componentsJoinedByString:@"&"];
    NSLog(@"%@", postString);
    
    return postString;
}

///***************************\ *
// * Function Name : - Start Loader
// * Create on : - 14th Nov 2016
// * Developed By : - Naren Gairola
// * Description : - This method is used for showing loader on screen.
// * Organisation Name :- Sirez
// * version no :- 1.0
// * Modified Date :-
// * Modified Reason :-
// * \***************************/
//
//- (void)ShowMBHUDLoader
//{
//    // Getting View from the last viewcontroller on window
//    // UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
//    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD showHUDAddedTo:window animated:YES];
//    });
//}
//
///****************************
// * Function Name : - Hide Loader
// * Create on : - 14th Nov 2016
// * Developed By : - Naren Gairola
// * Description : - This method is used for hiding loader on screen.
// * Organisation Name :- Sirez
// * version no :- 1.0
// ****************************/
//
//- (void)hideMBHUDLoader
//{
//    // Getting View from the last viewcontroller on window
//    //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//     UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:window animated:YES];
//    });
//}

#pragma mark - Keyed archiving method

- (void)ShowMBHUDLoader
{
     dispatch_async(dispatch_get_main_queue(), ^{
    AppDelegate * myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    [MBProgressHUD showHUDAddedTo:myDelegate.window animated:YES];
     });
}


- (void)hideMBHUDLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
    AppDelegate * myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    [MBProgressHUD hideHUDForView:myDelegate.window animated:YES];
    });
}

/****************************
 * Function Name : - uploadImageToS3WithThumbnail
 * Create on : - 5 jan  2017
 * Developed By : - Ramniwas Patidar
 * Description : - This method is used for Upload image with thumbnail in 200x200 size.
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

//////Kiran

- (void) startRequestWithHttpMethod:(kHttpMethodType) httpMethodType withHttpHeaders:(NSMutableDictionary*) headers withServiceName:(NSString*) serviceName withParameters:(NSMutableDictionary*) params withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *serviceUrl = [kAPIBaseURL stringByAppendingString:serviceName];
    NSLog(@"Headers\n%@", headers);
    NSLog(@"Params\n%@", params);
    NSLog(@"ServiceUrl\n%@", serviceUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (headers != nil)
    {
        NSArray *allHeaders = [headers allKeys];
        
        for (NSString *key in allHeaders)
        {
            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    
    /*   [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
     __block NSMutableString *query = [NSMutableString stringWithString:@""];
     
     NSError *err;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
     NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSLog(@"jsonString %@", jsonString);
     query = jsonString;
     
     return query;
     }];*/
    
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        __block NSMutableString *query = [NSMutableString stringWithString:@""];
        
        NSError *err;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
        NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString %@", jsonString);
        query = jsonString;
        
        return query;
    }];
    
    
    switch (httpMethodType)
    {
        case kHttpMethodTypeGet:
        {
            [manager GET:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                if (failure != nil)
                {
                    failure(operation,error);
                }
            }];
        }
            break;
        case kHttpMethodTypePost:
        {
            [manager POST:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error:\n %@", error);
                if (failure != nil)
                {
                    failure(operation,error);
                }
            }];
        }
            break;
        case kHttpMethodTypeDelete:
        {
            [manager DELETE:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                if (failure != nil)
                {
                    failure(operation,error);
                }
                
            }];
            
        }
            break;
        case kHttpMethodTypePut:
        {
            [manager PUT:serviceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                
                if (success != nil)
                {
                    success(operation,responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                if (failure != nil)
                {
                    failure(operation,error);
                }
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void) uploadImagewithHttpHeaders:(NSMutableDictionary*)headers withParameters:(NSMutableDictionary*)params withServiceName:(NSString*)serviceName withFilePath:(NSURL*)filePath withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    /* if (![CommonFunctions isNetworkRechable])
     {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NO INTERNET CONNECTION" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];
     
     [MBProgressHUD hideHUDForView:[APPDELEGATE window] animated:YES];
     
     return;
     }*/
    
    NSString *serviceUrl = [kAPIBaseURL stringByAppendingString:serviceName];
    NSLog(@"Headers\n %@", headers);
    NSLog(@"Params\n %@", params);
    NSLog(@"ServiceUrl\n %@", serviceUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if (headers != nil)
    {
        NSArray *allHeaders = [headers allKeys];
        
        for (NSString *key in allHeaders)
        {
            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    [manager POST:serviceUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         if (success != nil)
         {
             success(operation,responseObject);
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         if (failure != nil)
         {
             failure(operation,error);
         }
     }];
}

- (void) startRequestForMultipartFormDataWithHttpHeaders:(NSMutableDictionary*) headers withServiceName:(NSString*) serviceName withParameters:(NSMutableDictionary*) params withImageFile:(BOOL)isImagefile withImageInfo:(NSData*) imageInfo withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success withFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"Headers\n %@", headers);
    serviceName = [kAPIBaseURL stringByAppendingString:serviceName];
    
    NSLog(@"ServiceUrl\n %@", serviceName);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (headers != nil)
    {
        NSArray *allHeaders = [headers allKeys];
        
        for (NSString *key in allHeaders)
        {
            
            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    [manager POST:serviceName parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString * mimeType;
        NSString * fileName;
        if(isImagefile){
            mimeType = @"image/png";
            fileName = @"image.png";
        }
        else{
            mimeType = @"video/mp4";
            fileName = @"video.mp4";
        }
        [formData appendPartWithFileData:imageInfo name:@"file" fileName:fileName mimeType:mimeType];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if (success != nil)
        {
            success(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if (failure != nil)
        {
            failure(operation,error);
        }
        
    }];
}










@end

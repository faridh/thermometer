//
//  APIRequester.m
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import "APIRequester.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

#define kWeatherAPIKey @"679bd8713697628c84115b45cfa70e2d"

@implementation APIRequester


+ (NSString *)formatWeatherAPIURLWithLatitude:(double)latitude Longitude:(double)longitude
{
    NSString *tempURLPath = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial&APPID=%@",
                             latitude, longitude, kWeatherAPIKey];
    return  tempURLPath;
}

+ (void)get:(NSString *)apiEndpoint WithParams:(NSDictionary *)params
    Success:(void (^)(NSDictionary *response))successBlock
      Error:(void (^)(NSURLResponse *errorResponse, NSError *error))errorBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.operationQueue.maxConcurrentOperationCount = 10;
    [manager GET:apiEndpoint parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if(successBlock)
            successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (  error.code == kCFURLErrorNotConnectedToInternet ) {
            #warning ToDo
//            [ViewDecorator executeAlertViewWithTitle:@"Error"
//                                          AndMessage:@"No hay una conexión disponible a Internet."];
        }
        if(errorBlock)
            errorBlock(task.response, error);
    }];
    
}


+ (void)post:(NSString *)apiEndpoint WithParams:(NSDictionary *)params
     Success:(void (^)(NSDictionary *response))successBlock
       Error:(void (^)(NSURLResponse *errorResponse, NSError *error))errorBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes
                                                         setByAddingObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.operationQueue.maxConcurrentOperationCount = 10;
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"admin" password:@"Pr0piedadeS"];
    
    [manager POST:apiEndpoint parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ( successBlock )
            successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        #warning ToDo
//        if (  error.code == kCFURLErrorNotConnectedToInternet ) {
//            [ViewDecorator executeAlertViewWithTitle:@"Error"
//                                          AndMessage:@"No hay una conexión disponible a Internet."];
//        }
        if ( errorBlock )
            errorBlock(task.response, error);
    }];
}

@end

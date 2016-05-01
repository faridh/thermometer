//
//  APIRequester.h
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequester : NSObject

+ (NSString *)formatWeatherAPIURLWithLatitude:(double)latitude Longitude:(double)longitude;

+ (void)get:(NSString *)apiEndpoint WithParams:(NSDictionary *)params
    Success:(void (^)(NSDictionary *response))successBlock
      Error:(void (^)(NSURLResponse *errorResponse, NSError *error))errorBlock;

+ (void)post:(NSString *)apiEndpoint WithParams:(NSDictionary *)params
     Success:(void (^)(NSDictionary *response))successBlock
       Error:(void (^)(NSURLResponse *errorResponse, NSError *error))errorBlock;

@end

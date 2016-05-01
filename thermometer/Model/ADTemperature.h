//
//  ADTemperature.h
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTemperature : NSObject

@property (nonatomic, copy, readonly) NSNumber *temperatureF;
@property (nonatomic, copy, readonly) NSNumber *temperatureC;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSDate *updatedAt;

- (id)init;
- (id)initWithDictionary:(NSDictionary *)weatherModel;
+ (NSString *)formattedTemperature:(NSNumber *)temperature;

@end

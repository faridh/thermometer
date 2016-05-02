//
//  ADTemperature.m
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import "ADTemperature.h"
#import "NSString+Utils.h"

@implementation ADTemperature

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSString *)formattedTemperature:(NSNumber *)temperature {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
    return [numberFormatter stringFromNumber:temperature];
}

- (id)init
{
    self = [super init];
    if ( self ) {
        _city = @"Unknown";
        _temperatureF = [NSNumber numberWithInt:-460];
        _temperatureC = [NSNumber numberWithInt:-273];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)weatherModel
{
    self = [self init];
    if ( self ) {
        NSString *city = (NSString *)weatherModel[@"name"];
        if ( [city isEmpty] ) city = @"Unknown";
        _city = city;
        
        float rawFarenheit = [weatherModel[@"main"][@"temp"] floatValue];
        float rawCelsius = (rawFarenheit - 32) / 1.8f;
        NSNumber *temperatureF = [NSNumber numberWithFloat:rawFarenheit];
        NSNumber *temperatureC = [NSNumber numberWithFloat:rawCelsius];
        _temperatureF = temperatureF;
        _temperatureC = temperatureC;
        _updatedAt = [NSDate date];
    }
    return self;
}

@end

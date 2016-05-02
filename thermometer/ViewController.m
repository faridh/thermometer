//
//  ViewController.m
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import "ViewController.h"
#import "APIRequester.h"
#import "ADTemperature.h"
#import "ViewDecorator.h"
#import <TSMessages/TSMessage.h>

@interface ViewController () {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geoCoder;
    CLPlacemark *currentPlacemark;
    double currentLatitude;
    double currentLongitude;
}

@end

@implementation ViewController

@synthesize gradientView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocationServices];
    
    // Glitter ¯\_(ツ)_/¯
    _shimmeringTempMainView = [[FBShimmeringView alloc] initWithFrame:self.view.bounds];
    _shimmeringTempMainView.contentView = _tempMainLabel;
    [_backgroundView addSubview:_shimmeringTempMainView];
    
    // City Name on init
    _cityNameLabel.text = @"-";
    // Farenheit on init
    _tempMainLabel.text = @"-460 °F";
    // Celsius on init
    _tempSecondaryLabel.text = @"-273 °C";
    
}

- (void)updateLabelsWithTemperature:(ADTemperature *)temp
{
    // Farenheit on init
    _tempMainLabel.text = [NSString stringWithFormat:@"%@ °F", [ADTemperature formattedTemperature:temp.temperatureF]];
    // Celsius on init
    _tempSecondaryLabel.text = [NSString stringWithFormat:@"%@ °C", [ADTemperature formattedTemperature:temp.temperatureC]];
}

- (void)updateBackgroundWithTemperature:(ADTemperature *)temp
{
    UIColor *mainColor = [ViewDecorator colorForTemperature:[temp.temperatureF intValue]];

    for ( CALayer *tempLayer in gradientView.layer.sublayers ) [tempLayer removeFromSuperlayer];

    CAGradientLayer *gradView = [ViewDecorator gradientViewWithColors:@[(id)mainColor.CGColor,
                                                                        (id)mainColor.CGColor,
                                                                        (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor]
                                                        Frame:gradientView.frame];
    [gradientView.layer addSublayer:gradView];
    _backgroundView.backgroundColor = mainColor;
    
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)setupLocationServices;
{
    geoCoder = [[CLGeocoder alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if ( IS_OS_8_OR_LATER ) {
        [locationManager requestWhenInUseAuthorization];
    }
}

- (void)restartLocationManager
{
    [locationManager stopUpdatingLocation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [locationManager startUpdatingLocation];
    });
}

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    currentLatitude = currentLocation.coordinate.latitude;
    currentLongitude = currentLocation.coordinate.longitude;
    
    [geoCoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                       if ( !error ) {
                           currentPlacemark = placemarks[0];
                           NSString *apiURL = [APIRequester formatWeatherAPIURLWithLatitude:currentLatitude Longitude:currentLongitude];
                           
                           _shimmeringTempMainView.shimmering = YES;
                           [APIRequester get:apiURL WithParams:@{} Success:^(NSDictionary *response) {
                            
                               _shimmeringTempMainView.shimmering = NO;
                               ADTemperature *temp = [ADTemperature new];
                               temp = [[ADTemperature alloc] initWithDictionary:response];
                               [self updateLabelsWithTemperature:temp];
                               [self updateBackgroundWithTemperature:temp];
                               _cityNameLabel.text = temp.city;
                               
                           } Error:^(NSURLResponse *errorResponse, NSError *error) {
                               _shimmeringTempMainView.shimmering = NO;
                               [TSMessage showNotificationWithTitle:@"Error"
                                                           subtitle:@"Some error occurred. Will retry in one minute."
                                                               type:TSMessageNotificationTypeError];
                           }];
                           
                       } else {
                           [self restartLocationManager];
                           [TSMessage showNotificationWithTitle:@"Error"
                                                       subtitle:@"Some error occurred. Please check your internet connectivity."
                                                           type:TSMessageNotificationTypeError];
                       }
    }];
    
    [self restartLocationManager];
    [TSMessage showNotificationWithTitle:@"Notice"
                                subtitle:@"Getting temperature information for current area."
                                    type:TSMessageNotificationTypeMessage];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            [locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusNotDetermined:
            [TSMessage showNotificationWithTitle:@"Error"
                                        subtitle:@"Turn on location services in Settings > Privacy > Location Services in order to be able to get temperature information for your area."
                                            type:TSMessageNotificationTypeError];
        default:
            break;
    }
}

@end

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
    
    gradientView = [UIView new];
    gradientView.frame = _backgroundView.frame;
    [_backgroundView insertSubview:gradientView belowSubview:_tempMainLabel];
    
    // Farenheit on init
    _tempMainLabel.text = @"-460.0 °F";
    // Celsius on init
    _tempSecondaryLabel.text = @"-273.0 °C";
    
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
    UIColor *mainColor = [ViewDecorator colorForTemperature:[temp.temperatureF doubleValue]];

    [gradientView removeFromSuperview];
    gradientView.frame = _backgroundView.frame;
    CAGradientLayer *gradView = [ViewDecorator gradientViewWithColors:@[(id)mainColor.CGColor,
                                                                        (id)mainColor.CGColor,
                                                                        (id)mainColor.CGColor,
                                                                        (id)mainColor.CGColor,
                                                                        (id)[UIColor lightGrayColor].CGColor]
                                                        Frame:gradientView.frame];
    [gradientView.layer addSublayer:gradView];
    _backgroundView.backgroundColor = mainColor;
    [_backgroundView insertSubview:gradientView belowSubview:_tempMainLabel];
    
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
                           
                           [APIRequester get:apiURL WithParams:@{} Success:^(NSDictionary *response) {
                            
                               ADTemperature *temp = [ADTemperature new];
                               temp = [[ADTemperature alloc] initWithDictionary:response];
                               [self updateLabelsWithTemperature:temp];
                               [self updateBackgroundWithTemperature:temp];
                               
                           } Error:^(NSURLResponse *errorResponse, NSError *error) {
                               NSLog(@"Error: %@", error);
                           }];
                           
                       } else {
                           // ToDo: !!!
                       }
    }];
    
    [locationManager stopUpdatingLocation];
    [TSMessage showNotificationWithTitle:@"Notice"
                                subtitle:@"Calculating temperature for current area."
                                    type:TSMessageNotificationTypeMessage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [locationManager startUpdatingLocation];
    });
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
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Allow location services in order to provide the temperature for your area" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        default:
            break;
    }
}

@end

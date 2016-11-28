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
#import <AdColony/AdColony.h>
@import GoogleMobileAds;

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
    [self setupLocationServices];
    
    [self setupBannerAd];
    // [self setupMediumBannerAd];
    
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
    
    [super viewDidLoad];
}

- (void)loadView {
    
    // [self createAndLoadMoPubInterstitial];
    // [self createAndLoadAdColonyInterstitial];
    // [self createAndLoadAdMobInterstitial];
    
    [super loadView];
}

- (void)setupBannerAd {
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"374614b337144367b1508f861fc64433" size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    CGRect frame = self.adView.frame;
    CGSize size = [self.adView adContentViewSize];
    frame.origin.y = [[UIScreen mainScreen] applicationFrame].size.height - size.height + 20; // UIStatusBar height ¯\_(ツ)_/¯
    frame.origin.x = ([[UIScreen mainScreen] applicationFrame].size.width - size.width)/2;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    [self.adView loadAd];
}

- (void)setupMediumBannerAd {
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"db8d3260b92041ef85f5819cf43356e1" size:MOPUB_MEDIUM_RECT_SIZE];
    self.adView.delegate = self;
    CGRect frame = self.adView.frame;
    CGSize size = [self.adView adContentViewSize];
    frame.origin.y = [[UIScreen mainScreen] applicationFrame].size.height - size.height; // + 20 UIStatusBar height ¯\_(ツ)_/¯
    frame.origin.x = ([[UIScreen mainScreen] applicationFrame].size.width - size.width)/2;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    [self.adView loadAd];
}

- (void)createAndLoadAdColonyInterstitial {
    __weak ViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AdColony requestInterstitialInZone:@"vze535c70848ec45d2b5" options:nil success:^(AdColonyInterstitial * _Nonnull ad) {
            [ad showWithPresentingViewController:weakSelf];
        } failure:^(AdColonyAdRequestError * _Nonnull error) {
            //
        }];
    });
}

- (void)createAndLoadAdMobInterstitial {
    self.gInterstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9b" ];
    [self.gInterstitial loadRequest:request];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.gInterstitial.isReady) {
            [self.gInterstitial presentFromRootViewController:self];
        } else {
            NSLog(@"Ad wasn't ready");
        }
    });
}

- (void)createAndLoadMoPubInterstitial {
    // Instantiate the interstitial using the class convenience method.
    // Fullscreen: 06c231f847f94698b69ce0449ce25765
    // RewardedVideo: bafb19995cd14805a8624f4047b0fb8a
    self.interstitial = [MPInterstitialAdController
                         interstitialAdControllerForAdUnitId:@"06c231f847f94698b69ce0449ce25765"];
    // Fetch the interstitial ad.
    [self.interstitial loadAd];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.interstitial.ready) {
            [self.interstitial showFromViewController:self];
        }
        else {
            // The interstitial wasn't ready, so continue as usual.
        }
    });
}

// Present the ad only after it is ready.
- (void)levelDidEnd {
    if (self.interstitial.ready) [self.interstitial showFromViewController:self];
    else {
        // The interstitial wasn't ready, so continue as usual.
    }
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
                                                                        (id)mainColor.CGColor]
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

- (void)dealloc {
    self.adView = nil;
}

#pragma mark - MPAdViewDelegate methods
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
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

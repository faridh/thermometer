//
//  ViewController.h
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBShimmeringView.h"
#import "MPAdView.h"
#import "MPInterstitialAdController.h"
@import GoogleMobileAds;

@interface ViewController : UIViewController <MPAdViewDelegate,
                                                MPInterstitialAdControllerDelegate,
                                                CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (nonatomic, retain) MPInterstitialAdController *interstitial;
@property (nonatomic, strong) GADInterstitial *gInterstitial;
@property (nonatomic, retain) MPAdView *adView;

@property (strong, nonatomic) FBShimmeringView *shimmeringTempMainView;

@property (strong, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempMainLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempSecondaryLabel;

@end


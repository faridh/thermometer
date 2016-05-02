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

@interface ViewController : UIViewController <CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;

@property (strong, nonatomic) FBShimmeringView *shimmeringTempMainView;

@property (strong, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempMainLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempSecondaryLabel;

@end


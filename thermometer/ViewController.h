//
//  ViewController.h
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) UIView *gradientView;

@property (strong, nonatomic) IBOutlet UILabel *tempMainLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempSecondaryLabel;

@end


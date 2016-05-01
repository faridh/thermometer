//
//  ViewDecorator.m
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import "ViewDecorator.h"
#import "UIColor+Utils.h"

@implementation ViewDecorator

static ViewDecorator *_instance = nil;

/**
 * Singleton accesor to the static object.
 * @return id - A Singleton ViewDecorator
 */
+ (ViewDecorator *) instance
{
    @synchronized([ViewDecorator class]) {
        if ( !_instance ) {
            [self new];
        }
        return _instance;
    }
    return nil;
}

+ (id)alloc
{
    @synchronized([ViewDecorator class]) {
        if ( _instance == nil ) {
            _instance = [super alloc];
        }
        return _instance;
    }
    return nil;
}

- (id)init
{
    if (self = [super init]) {
        NSLog(@"ViewDecorator: init()");
    }
    return self;
}

+ (CAGradientLayer *)gradientViewWithColors:(NSArray *)colors Frame:(CGRect)frame;
{
    UIView *view = [UIView new];
    view.frame = frame;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = colors;
//    
//    if ( colors.count == 3 ) {
//        NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],
//                                      [NSNumber numberWithInt:0.8],
//                                      [NSNumber numberWithInt:1.0], nil];
//        gradient.locations = gradientLocations;
//    }

    return gradient;
}

+ (UIColor *)colorForTemperature:(double)temperature
{
    if ( temperature >= 100 ) {
        return [UIColor wineColor];
    } else if ( temperature >= 90 && temperature <= 99 ) {
        return [UIColor raspberryRedColor];
    } else if ( temperature >= 80 && temperature <= 89 ) {
        return [UIColor brickColor];
    } else if ( temperature >= 70 && temperature <= 79 ) {
        return [UIColor goldenPoppyColor];
    } else if ( temperature >= 60 && temperature <= 69 ) {
        return [UIColor patinaColor];
    } else if ( temperature >= 50 && temperature <= 59 ) {
        return [UIColor brightOliveColor];
    } else if ( temperature >= 40 && temperature <= 49 ) {
        return [UIColor jadeColor];
    } else if ( temperature >= 30 && temperature <= 39 ) {
        return [UIColor lapisColor];
    } else if ( temperature >= 20 && temperature <= 29 ) {
        return [UIColor midnightBlueColor];
    } else if ( temperature >= 10 && temperature <= 19 ) {
        return [UIColor musselShellColor];
    } else if ( temperature >= 0 && temperature <= 9 ) {
        return [UIColor hydrangeaColor];
    } else if ( temperature < 0 ) {
        return [UIColor bleachColor];
    } else {
        return [UIColor bleachColor];
    }
}

@end

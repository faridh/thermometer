//
//  ViewDecorator.h
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewDecorator : NSObject

#pragma mark - Initialization
+ (ViewDecorator *)instance;
+ (CAGradientLayer *)gradientViewWithColors:(NSArray *)colors Frame:(CGRect)frame;
+ (UIColor *)colorForTemperature:(int)temperatue;
+ (UIImage *)imageWithColor:(UIColor *)color AndBounds:(CGSize)bounds;

@end
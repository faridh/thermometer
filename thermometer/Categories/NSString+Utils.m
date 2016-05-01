//
//  NSString+Utils.m
//  thermometer
//
//  Created by Phoenix on 4/30/16.
//  Copyright © 2016 Adrenalin. All rights reserved.
//

#import "NSString+Utils.h"
#import <UIKit/UIKit.h>

@implementation NSString(Utils)

- (BOOL)isEmpty
{
    BOOL isEmpty = NO;
    if ( !self ) return YES;
    if ( self == nil ) return YES;
    if ( [self isKindOfClass:[NSNull class]] ) return YES;
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( [trimmedString isEqualToString:@"(null)"] ) return YES;
    if ( [trimmedString isEqualToString:@""] ) return YES;
    return isEmpty;
}

@end

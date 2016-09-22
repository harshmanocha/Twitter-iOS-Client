//
//  NSNumber+AddToLong.m
//  Twitter
//
//  Created by harsh.man on 21/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "NSNumber+AddToLong.h"

@implementation NSNumber (AddToLong)

- (NSNumber *)addToLong:(long)value {
    return [NSNumber numberWithLong:([self longValue] + value)];
}

@end

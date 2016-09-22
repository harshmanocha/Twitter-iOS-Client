//
//  NSNumber+NegateBoolean.m
//  Twitter
//
//  Created by harsh.man on 21/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "NSNumber+NegateBoolean.h"

@implementation NSNumber (NegateBoolean)

- (NSNumber *)negateBool {
    return [NSNumber numberWithBool:![self boolValue]];
}

@end

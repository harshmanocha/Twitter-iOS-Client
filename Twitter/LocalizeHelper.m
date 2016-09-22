//
//  LocalizeHelper.m
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "LocalizeHelper.h"
#import "UIKit/UIKit.h"

#define SELECTED_LANGUAGE_CODE LocalizedString(@"language code")

static LocalizeHelper* SingleLocalSystem = nil;

static NSBundle* myBundle = nil;

@implementation LocalizeHelper

+ (LocalizeHelper*) sharedLocalSystem {
    // lazy instantiation
    if (SingleLocalSystem == nil) {
        SingleLocalSystem = [[LocalizeHelper alloc] init];
    }
    return SingleLocalSystem;
}

- (id) init {
    self = [super init];
    if (self) {
        myBundle = [NSBundle mainBundle];
    }
    return self;
}

- (NSString*) localizedStringForKey:(NSString*) key {
    return [myBundle localizedStringForKey:key value:@"" table:nil];
}

- (void) setLanguage:(NSString*) lang {
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj" ];
    if (path == nil) {
        myBundle = [NSBundle mainBundle];
    } else {
        myBundle = [NSBundle bundleWithPath:path];
        if (myBundle == nil) {
            myBundle = [NSBundle mainBundle];
        }
    }
}

+ (void)addViewForRefreshingLocalizedText:(id<RefreshLocalizedTextOnViewProtocol>)view {
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:@selector(addViewForRefreshingLocalizedText:) withObject:view];
}

+ (NSString *)localizedNumberString:(NSNumber *)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:SELECTED_LANGUAGE_CODE]];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    return numberString;
}

@end

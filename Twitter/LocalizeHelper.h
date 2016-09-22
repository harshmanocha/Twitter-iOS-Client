//
//  LocalizeHelper.h
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefreshLocalizedTextOnViewProtocol <NSObject>
- (void)refreshLocalizedText;
@end

#define LocalizedString(key) [[LocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]

#define LocalizationSetLanguage(language) [[LocalizeHelper sharedLocalSystem] setLanguage:(language)]

@interface LocalizeHelper : NSObject

+ (LocalizeHelper*) sharedLocalSystem;

- (NSString*) localizedStringForKey:(NSString*) key;

- (void) setLanguage:(NSString*) lang;

+ (void)addViewForRefreshingLocalizedText:(id<RefreshLocalizedTextOnViewProtocol>)view;

+ (NSString *)localizedNumberString:(NSNumber *)number;

@end

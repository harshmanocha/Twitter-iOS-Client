//
//  Language+CoreDataClass.h
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Language : NSManagedObject

+ (Language *)languageWithName:(NSString *)languageName
              withLanguageCode:(NSString *)languageCode
                      isChosen:(nullable NSNumber *)isChosen
              intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Language+CoreDataProperties.h"

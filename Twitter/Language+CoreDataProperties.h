//
//  Language+CoreDataProperties.h
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Language+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Language (CoreDataProperties)

+ (NSFetchRequest<Language *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *languageName;
@property (nullable, nonatomic, copy) NSString *languageCode;
@property (nullable, nonatomic, copy) NSNumber *isChosen;

@end

NS_ASSUME_NONNULL_END

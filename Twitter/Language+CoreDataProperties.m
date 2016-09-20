//
//  Language+CoreDataProperties.m
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Language+CoreDataProperties.h"

@implementation Language (CoreDataProperties)

+ (NSFetchRequest<Language *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Language"];
}

@dynamic languageName;
@dynamic languageCode;
@dynamic isChosen;

@end

//
//  Language+CoreDataClass.m
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Language+CoreDataClass.h"

@implementation Language

+ (Language *)languageWithName:(NSString *)languageName
              withLanguageCode:(NSString *)languageCode
                      isChosen:(nullable NSNumber *)isChosen
      intoManagedObjectContext:(NSManagedObjectContext *)context {
    Language *language = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Language"];
    request.predicate = [NSPredicate predicateWithFormat:@"languageCode = %@", languageCode];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Error in loading language from CoreData for user with languageCode %@", languageCode);
    }
    else if (![matches count]) {
        language = [NSEntityDescription insertNewObjectForEntityForName:@"Language"
                                             inManagedObjectContext:context];
        language.languageCode = languageCode;
        language.languageName = languageName;
        language.isChosen = @NO;
        if (isChosen)
            language.isChosen = isChosen;
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    else {
        language = [matches lastObject];
    }
    
    return language;
}

@end

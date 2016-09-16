//
//  User.h
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (User *)userWithDictionary:(NSDictionary *)dictionary
      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)loadUsersFromArray:(NSArray *)usersDictArray
       intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"

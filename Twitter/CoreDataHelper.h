//
//  CoreDataHelper.h
//  Twitter
//
//  Created by harsh.man on 22/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"

@interface CoreDataHelper : NSObject

/**
 Return an instance of @p NSManagedObjectContext
 */
+ (NSManagedObjectContext *)managedObjectContext;

/**
 Save the managed object context
 */
+ (void)saveManagedObjectContext;

@end

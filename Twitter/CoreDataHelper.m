//
//  CoreDataHelper.m
//  Twitter
//
//  Created by harsh.man on 22/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "CoreDataHelper.h"
#import "UIKit/UIKit.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+ (void)saveManagedObjectContext {
    NSError *error = nil;
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

@end

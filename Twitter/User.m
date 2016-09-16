//
//  User.m
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "User.h"
#import "Tweet.h"

@implementation User

// Insert code here to add functionality to your managed object subclass

+ (User *)userWithDictionary:(NSDictionary *)dictionary
      inManagedObjectContext:(NSManagedObjectContext *)context {
    User *user = nil;
    
    
    NSString *screenName = dictionary[@"screen_name"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"screenname = %@", screenName];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    }
    else if (![matches count]) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:context];
        user.idStr = dictionary[@"id_str"];
        user.screenname = screenName;
        user.name = dictionary[@"name"];
        
        user.profileImageUrl = dictionary[@"profile_image_url"];
        if ([user.profileImageUrl hasPrefix:@"http://"])
            user.profileImageUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
         
        user.tagline = dictionary[@"description"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    else {
        user = [matches lastObject];
    }
    
    return user;
}

+ (NSArray *)loadUsersFromArray:(NSArray *)usersDictArray
        intoManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSMutableArray *users = [NSMutableArray array];
    
    for (NSDictionary *userDictionary in usersDictArray) {
        User *user = [User userWithDictionary:userDictionary
                       inManagedObjectContext:context];
        
        [users addObject:user];
    }
    
    return users;
}

@end

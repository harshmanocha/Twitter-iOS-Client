//
//  User+CoreDataProperties.m
//  Twitter
//
//  Created by harsh.man on 21/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic userID;
@dynamic name;
@dynamic profileImageURL;
@dynamic screenName;
@dynamic tagline;
@dynamic followers;
@dynamic following;
@dynamic tweets;

@end

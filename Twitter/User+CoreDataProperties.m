//
//  User+CoreDataProperties.m
//  
//
//  Created by harsh.man on 16/09/16.
//
//

#import "User.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic name;
@dynamic profileImage;
@dynamic profileImageUrl;
@dynamic screenname;
@dynamic tagline;
@dynamic idStr;
@dynamic tweets;
@dynamic followers;
@dynamic following;

@end

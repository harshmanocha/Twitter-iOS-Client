//
//  User+CoreDataProperties.m
//  
//
//  Created by harsh.man on 15/09/16.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic name;
@dynamic profileImage;
@dynamic profileImageUrl;
@dynamic screenname;
@dynamic tagline;
@dynamic generatedByApiEndPoint;
@dynamic tweets;

@end

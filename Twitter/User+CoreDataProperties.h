//
//  User+CoreDataProperties.h
//  
//
//  Created by harsh.man on 15/09/16.
//
//

#import "User.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *idStr;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSData *profileImage;
@property (nullable, nonatomic, copy) NSString *profileImageUrl;
@property (nullable, nonatomic, copy) NSString *screenname;
@property (nullable, nonatomic, copy) NSString *tagline;
@property (nullable, nonatomic, copy) NSString *generatedByApiEndPoint;
@property (nullable, nonatomic, retain) NSSet<Tweet *> *tweets;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet<Tweet *> *)values;
- (void)removeTweets:(NSSet<Tweet *> *)values;

@end

NS_ASSUME_NONNULL_END

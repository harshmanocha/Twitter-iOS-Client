//
//  User+CoreDataProperties.h
//  
//
//  Created by harsh.man on 16/09/16.
//
//

#import "User.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *profileImageUrl;
@property (nullable, nonatomic, copy) NSString *screenname;
@property (nullable, nonatomic, copy) NSString *tagline;
@property (nullable, nonatomic, copy) NSString *idStr;
@property (nullable, nonatomic, retain) NSSet<Tweet *> *tweets;
@property (nullable, nonatomic, retain) NSSet<User *> *followers;
@property (nullable, nonatomic, retain) NSSet<User *> *following;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet<Tweet *> *)values;
- (void)removeTweets:(NSSet<Tweet *> *)values;

- (void)addFollowersObject:(User *)value;
- (void)removeFollowersObject:(User *)value;
- (void)addFollowers:(NSSet<User *> *)values;
- (void)removeFollowers:(NSSet<User *> *)values;

- (void)addFollowingObject:(User *)value;
- (void)removeFollowingObject:(User *)value;
- (void)addFollowing:(NSSet<User *> *)values;
- (void)removeFollowing:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END

//
//  Tweet+CoreDataProperties.h
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *favoriteCount;
@property (nullable, nonatomic, retain) NSNumber *favorited;
@property (nonatomic, retain) NSString *idStr;
@property (nullable, nonatomic, retain) NSString *replyToId;
@property (nullable, nonatomic, retain) NSNumber *retweetCount;
@property (nullable, nonatomic, retain) NSNumber *retweeted;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) Tweet *retweetedTweet;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END

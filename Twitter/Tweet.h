//
//  Tweet.h
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <TwitterKit/twitterKit.h>
#import "User.h"

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, strong) TWTRAPIClient *client;

- (BOOL) retweet;
- (BOOL) favorite;

+ (Tweet *)tweetWithTwitterInfo:(NSDictionary *)tweetDictionary
         generatedByApiEndPoint:(NSString *)apiEndPoint
         inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)loadTweetsFromArray:(NSArray *)tweets
          generatedByApiEndPoint:(NSString *)apiEndPoint
        intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Tweet+CoreDataProperties.h"

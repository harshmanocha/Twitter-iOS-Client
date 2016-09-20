//
//  TimelineViewController.h
//  Twitter
//
//  Created by harsh.man on 06/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterKit/TwitterKit.h"
#import "MBProgressHUD.h"
#import "TweetCell.h"

@protocol TimelineDelegate <NSObject>

- (void)postTweet: (NSString *)withText;
- (void)signOut;

@end

@interface TimelineViewController : UITableViewController <TweetCellDelegate>

@property (nonatomic, strong) TWTRAPIClient *client;
@property (strong, nonatomic) NSString * twitterRequestApiEndPoint;
@property (strong, nonatomic) NSMutableDictionary * requestParams;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshTweetsControl;
@property (strong, nonatomic) MBProgressHUD *loadingIndicator;

@property (weak, nonatomic) UITableView *tweetTableView;

@property (nonatomic, weak) id <TimelineDelegate> delegate;

- (void)refreshTweets;
- (void)getMoreTweets;
- (void)loadDataFromPersistentStorage;

+ (NSManagedObjectContext *)managedObjectContext;

@end

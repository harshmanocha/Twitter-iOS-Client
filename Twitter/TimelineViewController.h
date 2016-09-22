//
//  TimelineViewController.h
//  Twitter
//
//  Created by harsh.man on 06/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

@protocol TimelineDelegate <NSObject>

/**
 Functionality to compose and post new tweet.
 
 @param withText The initial text that should be added to the new tweet. This can be helpful for adding user handle(s) when replying to a tweet.
 */
- (void)postTweet:(NSString *)withText;

/**
 Functionality to sign out from the app.
 */
- (void)signOut;

@end

/**
 View controller for Twitter Timeline.
 This is an abstract view-controller, and should not be instantiated. 
 It can be subclassed by view controllers like User Timeline and Home Timeline.
 */
@interface TimelineViewController : UITableViewController <TweetCellDelegate>

/**
 The API end point to which requests for fetching tweets of a timeline should be made.
 This is an abstract propoerty and should be set up by the subclass before the viewDidLoad of this class is called.
 */
@property (strong, nonatomic) NSString * twitterRequestApiEndPoint;

/**
 The request parameters that need to be sent along with the request to the Twitter API while fetching tweets for the timeline.
 This is an abstract propoerty and should be set up by the subclass before the viewDidLoad of this class is called.
 */
@property (strong, nonatomic) NSMutableDictionary * requestParams;

/**
 The table view containing the tweets.
 This is an abstract propoerty and should be set up by the subclass before the viewDidLoad of this class is called.
 */
@property (weak, nonatomic) UITableView *tweetTableView;

/**
 Array containing the tweets that need to be displayed on the timeline.
 */
@property (strong, nonatomic) NSArray *tweets;

/**
 A delegate implementing functionality of @p TimelineDelegate protocol such that a tweet can be easily posted from the timeline.
 */
@property (nonatomic, weak) id <TimelineDelegate> delegate;

@end

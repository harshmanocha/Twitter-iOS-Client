//
//  TimelineViewController.m
//  Twitter
//
//  Created by harsh.man on 06/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "TimelineViewController.h"
#import "Tweet.h"
#import "User.h"
#import "LocalizeHelper.h"
#import "MBProgressHUD.h"
#import "CoreDataHelper.h"
#import "TwitterAPI.h"

@interface TimelineViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshTweetsControl;
@property (strong, nonatomic) MBProgressHUD *loadingIndicator;

- (void)refreshTweets;
- (void)getMoreTweets;
- (void)loadDataFromPersistentStorage;

@end

@implementation TimelineViewController

NSString * const IdentifierForTweetCell = @"TweetCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tweetTableView registerNib:[UINib nibWithNibName:IdentifierForTweetCell bundle:nil]
              forCellReuseIdentifier:IdentifierForTweetCell];
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetTableView.estimatedRowHeight = 105;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    self.refreshTweetsControl = [[UIRefreshControl alloc] init];
    [self.tweetTableView addSubview:self.refreshTweetsControl];
    [self.refreshTweetsControl addTarget:self
                                  action:@selector(refreshTweets)
                        forControlEvents:UIControlEventValueChanged];
    self.loadingIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadDataFromPersistentStorage];
    [self getRecentTweets];
}

- (void)loadDataFromPersistentStorage {
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"generatedByApiEndPoint = %@", self.twitterRequestApiEndPoint]];
    NSSortDescriptor * createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                          ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    self.tweets = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (void)getRecentTweets {
    if (!self.tweets.count) {
        [self refreshTweets];
        return;
    }
    NSString *sinceTweetID = [self.tweets[0] tweetID];
    [self.requestParams setObject:sinceTweetID forKey:@"since_id"];
    NSError *clientError;
    NSURLRequest *request = [[TwitterAPI sharedInstanceOfApiClient] URLRequestWithMethod:@"GET"
                                                                                     URL:self.twitterRequestApiEndPoint
                                                                              parameters:self.requestParams
                                                                                   error:&clientError];
    if (request) {
        [[TwitterAPI sharedInstanceOfApiClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSArray *moreTweets = [Tweet loadTweetsFromArray:json
                                          generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                        intoManagedObjectContext:[CoreDataHelper managedObjectContext]];
                if (moreTweets.count > 0) {
                    NSLog(@"Got %lu more new recent tweets", (unsigned long)moreTweets.count);
                    self.tweets = [moreTweets arrayByAddingObjectsFromArray:self.tweets];
                    [self.tweetTableView reloadData];
                    [self getRecentTweets];
                } else {
                    NSLog(@"No more recent tweets available");
                    [self.loadingIndicator hideAnimated:YES];
                    [self.tweetTableView reloadData];
                }
            }
        }];
    }
}

- (void)refreshTweets {
    NSLog(@"Fetching/refreshing tweets");
    [self.requestParams removeObjectsForKeys:@[@"max_id", @"since_id"]];
    NSError *clientError;
    NSURLRequest *request = [[TwitterAPI sharedInstanceOfApiClient] URLRequestWithMethod:@"GET"
                                                                                     URL:self.twitterRequestApiEndPoint
                                                                              parameters:self.requestParams
                                                                                   error:&clientError];
    if (request) {
        [[TwitterAPI sharedInstanceOfApiClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                self.tweets = [Tweet loadTweetsFromArray:json
                                  generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                intoManagedObjectContext:[CoreDataHelper managedObjectContext]];
                [self.tweetTableView reloadData];
            }
            [self.loadingIndicator hideAnimated:YES];
            [self.refreshTweetsControl endRefreshing];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:IdentifierForTweetCell];
    tweetCell.tweet = self.tweets[indexPath.row];
    tweetCell.delegate = self;
    if (indexPath.row == self.tweets.count - 3) {
        NSLog(@"End of list reached...");
        [self getMoreTweets];
    }
    return tweetCell;
}

- (void) getMoreTweets {
    [self.requestParams removeObjectForKey:@"since_id"];
    NSString *maxTweetID = [self.tweets[self.tweets.count - 1] tweetID];
    if (!maxTweetID) {
        return;
    }
    [self.requestParams setObject:maxTweetID forKey:@"max_id"];
    NSError *clientError;
    NSURLRequest *request = [[TwitterAPI sharedInstanceOfApiClient] URLRequestWithMethod:@"GET"
                                                                                     URL:self.twitterRequestApiEndPoint
                                                                              parameters:self.requestParams
                                                                                   error:&clientError];
    if (request) {
        [[TwitterAPI sharedInstanceOfApiClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSArray *moreTweets = [Tweet loadTweetsFromArray:json
                                          generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                        intoManagedObjectContext:[CoreDataHelper managedObjectContext]];
                if (moreTweets.count > 1) {
                    NSLog(@"Got %lu more tweets", (unsigned long)moreTweets.count);
                    self.tweets = [self.tweets arrayByAddingObjectsFromArray:moreTweets];
                    [self.tweetTableView reloadData];
                }
                else {
                    NSLog(@"No more tweets available");
                }
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onReply:(TweetCell *)tweetCell {
    Tweet *tweetToBeRepliedTo = tweetCell.tweet;
    NSMutableString *tweetInitialText = [[NSMutableString alloc] init];
    if (tweetToBeRepliedTo.retweetedTweet)
        [tweetInitialText appendString:[NSString stringWithFormat:@"@%@ ", tweetToBeRepliedTo.retweetedTweet.user.screenName]];
    [tweetInitialText appendString:[NSString stringWithFormat:@" @%@ ", tweetToBeRepliedTo.user.screenName]];
    
    [self.delegate  postTweet:tweetInitialText];
}

@end

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

@interface TimelineViewController ()

@end

@implementation TimelineViewController

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register tweet cell nib
    [self.tweetTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]
              forCellReuseIdentifier:@"TweetCell"];
    
    // set self as table view data source and delegate
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetTableView.estimatedRowHeight = 105;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    
    // add pull to refresh tweets control
    self.refreshTweetsControl = [[UIRefreshControl alloc] init];
    [self.tweetTableView addSubview:self.refreshTweetsControl];
    [self.refreshTweetsControl addTarget:self
                                  action:@selector(refreshTweets)
                        forControlEvents:UIControlEventValueChanged];
    
    // show loading indicator
    self.loadingIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self loadDataFromPersistentStorage];
    
    [self getRecentTweets];
    
//    [TimelineViewController addViewForRedrawing:self.tweetTableView];
}

- (void)loadDataFromPersistentStorage {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [TimelineViewController managedObjectContext];
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
        
    NSString *sinceIdStr = [self.tweets[0] idStr];
    NSLog(@"About to fetch recent tweets with since id: %@", sinceIdStr);
    [self.requestParams setObject:sinceIdStr forKey:@"since_id"];
    
    NSError *clientError;
    NSURLRequest *request = [self.client URLRequestWithMethod:@"GET"
                                                          URL:self.twitterRequestApiEndPoint
                                                   parameters:self.requestParams
                                                        error:&clientError];
    if (request) {
        [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                NSArray *moreTweets = [Tweet loadTweetsFromArray:json
                                          generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                        intoManagedObjectContext:[TimelineViewController managedObjectContext]];
                if (moreTweets.count > 0) {
                    NSLog(@"Got %lu more new recent tweets", (unsigned long)moreTweets.count);
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:moreTweets];
                    [temp addObjectsFromArray:self.tweets];
                    self.tweets = [temp copy];
                    [self.loadingIndicator hideAnimated:YES];
                    [self.tweetTableView reloadData];
                    [self getRecentTweets];
                }
                else {
                    NSLog(@"No more recent tweets available");
                    [self.loadingIndicator hideAnimated:YES];
                    [self.tweetTableView reloadData];
                }
            }
            else {
                NSLog(@"Error: %@", connectionError);
            }
        }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}

- (void)refreshTweets {
    
    NSLog(@"Fetching/refreshing tweets");
    
    [self.requestParams removeObjectForKey:@"max_id"];
    [self.requestParams removeObjectForKey:@"since_id"];
    
    NSError *clientError;
    NSURLRequest *request = [self.client URLRequestWithMethod:@"GET"
                                                          URL:self.twitterRequestApiEndPoint
                                                   parameters:self.requestParams
                                                        error:&clientError];
    
    if (request) {
        [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                self.tweets = [Tweet loadTweetsFromArray:json
                               generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                intoManagedObjectContext:[TimelineViewController managedObjectContext]];
                [self.tweetTableView reloadData];
            }
            else {
                NSLog(@"Error: %@", connectionError);
            }
            [self.loadingIndicator hideAnimated:YES];
            [self.refreshTweetsControl endRefreshing];
        }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    tweetCell.tweet = self.tweets[indexPath.row];
    tweetCell.delegate = self;
    
    // if data for the third-last cell is requested, then obtain more data
    if (indexPath.row == self.tweets.count - 3) {
        NSLog(@"End of list reached...");
        [self getMoreTweets];
    }
//    [TimelineViewController addViewForRedrawing:tweetCell.backgroundView];
    return tweetCell;
}

- (void) getMoreTweets {
    [self.requestParams removeObjectForKey:@"since_id"];
    
    // if no previous max id str available, then don't do anything
    NSString *maxIdStr = [self.tweets[self.tweets.count - 1] idStr];
    if (!maxIdStr) {
        return;
    }
    
    [self.requestParams setObject:maxIdStr forKey:@"max_id"];
    
    NSError *clientError;
    NSURLRequest *request = [self.client URLRequestWithMethod:@"GET"
                                                          URL:self.twitterRequestApiEndPoint
                                                   parameters:self.requestParams
                                                        error:&clientError];
    if (request) {
        [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                NSArray *moreTweets = [Tweet loadTweetsFromArray:json
                                          generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                        intoManagedObjectContext:[TimelineViewController managedObjectContext]];
                if (moreTweets.count > 1) {
                    NSLog(@"Got %lu more tweets", moreTweets.count);
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tweets];
                    [temp addObjectsFromArray:moreTweets];
                    self.tweets = [temp copy];
                    [self.tweetTableView reloadData];
                }
                else {
                    NSLog(@"No more tweets available");
                }
            }
            else {
                NSLog(@"Error: %@", connectionError);
            }
        }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // unhighlight selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)onReply:(TweetCell *)tweetCell {
    Tweet *tweetToBeRepliedTo = tweetCell.tweet;
    NSMutableString *tweetInitialText = [[NSMutableString alloc] init];
    if (tweetToBeRepliedTo.retweetedTweet)
        [tweetInitialText appendString:[NSString stringWithFormat:@"@%@ ", tweetToBeRepliedTo.retweetedTweet.user.screenname]];
    
    [tweetInitialText appendString:[NSString stringWithFormat:@" @%@ ", tweetToBeRepliedTo.user.screenname]];
    
    [self.delegate  postTweet:tweetInitialText];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

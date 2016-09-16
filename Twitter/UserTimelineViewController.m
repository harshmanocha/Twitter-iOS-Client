//
//  HomeTimelineViewController.m
//  Twitter
//
//  Created by harsh.man on 31/08/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "UserTimelineViewController.h"

@implementation UserTimelineViewController

- (void)viewDidLoad {
    if (!self.userId)
        self.userId = [Twitter sharedInstance].sessionStore.session.userID;
    
    NSMutableDictionary *paramsForUserTimeline = [[NSMutableDictionary alloc] initWithDictionary:@{@"user_id":self.userId}];
    self.client = [[TWTRAPIClient alloc] init];
    
    [self setTweetTableView:_userTimelineTableView];
    [self setTwitterRequestApiEndPoint:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
    [self setRequestParams:paramsForUserTimeline];
    
    NSLog(@"About to show user timeline of user with ID: %@", self.userId);
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.userId)
        [self.navigationController setTitle:@"TOBECHANGED"];
    else
        [self.tabBarController setTitle:NSLocalizedString(@"User Timeline", nil)];
}

- (void)loadDataFromPersistentStorage {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [TimelineViewController managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idStr = %@", self.userId]];
    
    User *user = [[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy] firstObject];
    
    if (user) {
        self.tweets = [[user tweets] allObjects];
        NSSortDescriptor * createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
        self.tweets = [self.tweets sortedArrayUsingDescriptors:@[createdAtSortDescriptor]];
    }
    
    [self.tableView reloadData];
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

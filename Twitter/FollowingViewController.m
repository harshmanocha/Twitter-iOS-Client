//
//  FollowingViewController.m
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "FollowingViewController.h"

@interface FollowingViewController ()

@end

@implementation FollowingViewController

- (void)viewDidLoad {
    
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    NSMutableDictionary *paramsForFollowingList = [[NSMutableDictionary alloc] initWithDictionary:@{@"user_id":userID}];
    self.client = [[TWTRAPIClient alloc] init];
    
    [self setUsersTableView:_followingTableView];
    [self setTwitterRequestApiEndPoint:@"https://api.twitter.com/1.1/friends/list.json"];
    [self setRequestParams:paramsForFollowingList];
    [self loadDataFromPersistentStorageForUserId:userID];
    [LocalizeHelper addViewForRefreshingLocalizedText:self];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"Switched to following tab");
    [self refreshLocalizedText];
}

- (void)refreshLocalizedText {
    [self.tabBarController setTitle:LocalizedString(@"Following")];
}

- (void)loadDataFromPersistentStorageForUserId:(NSString *)userId {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [UsersTableViewController managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idStr = %@", userId]];
    
    self.currentUser = [[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy] firstObject];
    if (self.currentUser) {
        self.users = [self.currentUser.following allObjects];
        NSSortDescriptor * createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.users = [self.users sortedArrayUsingDescriptors:@[createdAtSortDescriptor]];
        NSLog(@"Number of fetched followers from core data: %lu", (unsigned long)self.users.count);
    }
    else {
        NSLog(@"Current user not found in DB");
    }
    
    [self.tableView reloadData];
}

- (void)setRelationshipOnUsers:(nullable NSArray *)users {
    if (!users)
        users = self.users;
    [self.currentUser addFollowing:[NSSet setWithArray:self.users]];
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

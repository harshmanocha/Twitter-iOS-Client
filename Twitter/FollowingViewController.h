//
//  FollowingViewController.h
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "UsersTableViewController.h"
#import "LocalizeHelper.h"

@interface FollowingViewController : UsersTableViewController <RefreshLocalizedTextOnViewProtocol>

@property (strong, nonatomic) IBOutlet UITableView *followingTableView;
@property (nonatomic, strong) User * currentUser;

- (void)loadDataFromPersistentStorageForUserId:(NSString *)userId;

@end

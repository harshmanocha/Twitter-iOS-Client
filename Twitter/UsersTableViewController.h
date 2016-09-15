//
//  UsersTableTableViewController.h
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterKit/TwitterKit.h"
#import "MBProgressHUD.h"
#import "User.h"

@interface UsersTableViewController : UITableViewController

@property (nonatomic, strong) TWTRAPIClient *client;

@property (strong, nonatomic) NSString * twitterRequestApiEndPoint;
@property (strong, nonatomic) NSMutableDictionary * requestParams;

@property (weak, nonatomic) UITableView *usersTableView;

@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSString *nextCursor;
@property (strong, nonatomic) UIRefreshControl *refreshUsersControl;
@property (strong, nonatomic) MBProgressHUD *loadingIndicator;

- (void)refreshUsers;
- (void)getMoreUsers;
- (void)loadDataFromPersistentStorage;

+ (NSManagedObjectContext *)managedObjectContext;

@end

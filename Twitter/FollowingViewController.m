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
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tabBarController setTitle:NSLocalizedString(@"Following", nil)];
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

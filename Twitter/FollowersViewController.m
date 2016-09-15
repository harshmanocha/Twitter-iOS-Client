//
//  FollowersViewController.m
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "FollowersViewController.h"

@interface FollowersViewController ()

@end

@implementation FollowersViewController

- (void)viewDidLoad {

    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    NSMutableDictionary *paramsForFollowersList = [[NSMutableDictionary alloc] initWithDictionary:@{@"user_id":userID}];
    self.client = [[TWTRAPIClient alloc] init];
    
    [self setUsersTableView:_followersTableView];
    [self setTwitterRequestApiEndPoint:@"https://api.twitter.com/1.1/followers/list.json"];
    [self setRequestParams:paramsForFollowersList];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tabBarController setTitle:NSLocalizedString(@"Followers", nil)];
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

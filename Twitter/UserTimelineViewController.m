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
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    NSMutableDictionary *paramsForUserTimeline = [[NSMutableDictionary alloc] initWithDictionary:@{@"user_id":userID}];
    self.client = [[TWTRAPIClient alloc] init];
    
    [self setTweetTableView:_userTimelineTableView];
    [self setTwitterRequestApiEndPoint:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
    [self setRequestParams:paramsForUserTimeline];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tabBarController setTitle:@"User Timeline"];
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

//
//  HomeTimelineViewController.m
//  Twitter
//
//  Created by harsh.man on 06/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "HomeTimelineViewController.h"
#import "TwitterAPI.h"

@interface HomeTimelineViewController ()

@end

@implementation HomeTimelineViewController

- (void)viewDidLoad {
    [self setTweetTableView:_homeTimelineTableView];
    [self setTwitterRequestApiEndPoint:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    [self setRequestParams:[[NSMutableDictionary alloc] initWithDictionary:@{}]];
    [LocalizeHelper addViewForRefreshingLocalizedText:self];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Switched to home feed tab");
    [self refreshLocalizedText];
}

- (void)refreshLocalizedText {
    [self.tabBarController setTitle:LocalizedString(@"Home Feed")];
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

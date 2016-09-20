//
//  TabBarController.m
//  Twitter
//
//  Created by harsh.man on 02/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "TabBarController.h"
#import "TwitterKit/TwitterKit.h"
#import "HomeTimelineViewController.h"
#import "UserTimelineViewController.h"
#import "LocalizeHelper.h"

@implementation TabBarController

@synthesize tabBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeTimelineViewController *homeTimelineViewController = (HomeTimelineViewController *)[[self viewControllers] objectAtIndex:0];
    [homeTimelineViewController setDelegate:self];
    
    UserTimelineViewController *userTimelineViewController = (UserTimelineViewController *)[[self viewControllers] objectAtIndex:1];
    [userTimelineViewController setDelegate:self];
    [self refreshLocalizedText];
    
    [LocalizeHelper addViewForRefreshingLocalizedText:self];
}

- (void)refreshLocalizedText {
    [[self.tabBar.items objectAtIndex:0] setTitle:LocalizedString(@"Home Feed")];
    [[self.tabBar.items objectAtIndex:1] setTitle:LocalizedString(@"User Timeline")];
    [[self.tabBar.items objectAtIndex:2] setTitle:LocalizedString(@"Following")];
    [[self.tabBar.items objectAtIndex:3] setTitle:LocalizedString(@"Followers")];
}

- (void) postTweet: (nullable NSString *)withText {
    NSLog(@"Ready to post tweet");
    NSLog(@"via class %@", [self class]);
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    if (withText) {
        NSLog(@"Initial text: %@", withText);
        [composer setText:withText];
    }
        
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}

- (IBAction)tweetButtonPressed:(id)sender {
    NSLog(@"Tweet button pressed by user");
    [self postTweet:NULL];
}

- (void)signOut {
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    NSLog(@"About to log out User ID: %@", userID);
    [[Twitter sharedInstance].sessionStore logOutUserID:userID];
    [self performSegueWithIdentifier:@"signOutSegue" sender:self];
}

- (IBAction)signOutFromTwitter:(id)sender {
    [self signOut];
}

@end

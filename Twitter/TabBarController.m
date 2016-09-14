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

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeTimelineViewController *homeTimelineViewController = (HomeTimelineViewController *)[[self viewControllers] objectAtIndex:0];
    [homeTimelineViewController setDelegate:self];
    
    UserTimelineViewController *userTimelineViewController = (UserTimelineViewController *)[[self viewControllers] objectAtIndex:1];
    [userTimelineViewController setDelegate:self];
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

- (IBAction)signOutFromTwitter:(id)sender {
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    NSLog(@"About to log out User ID: %@", userID);
    [[Twitter sharedInstance].sessionStore logOutUserID:userID];
    [self performSegueWithIdentifier:@"signOutSegue" sender:self];
}

@end

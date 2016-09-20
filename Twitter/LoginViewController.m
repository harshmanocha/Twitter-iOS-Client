//
//  LoginViewController.m
//  Twitter
//
//  Created by harsh.man on 30/08/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "LoginViewController.h"
#import "TimelineViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self refreshLocalizedText];
    
    self.twitterLogoView.transform = CGAffineTransformMakeScale(1, 1);
    // use twitter brand bg color
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0f green:192/255.0f blue:255/255.0f alpha:1.0f];
    [LocalizeHelper addViewForRefreshingLocalizedText:self];
}

- (void)refreshLocalizedText {
    [self.loginButton setTitle:LocalizedString(@"Login with Twitter")
                      forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLoginWithTwitter:(id)sender {
    // animate the logo
    [UIView animateWithDuration:.3 animations:^{
        self.twitterLogoView.transform = CGAffineTransformMakeScale(30, 30);
        self.view.backgroundColor = [UIColor whiteColor];
    }];
    
    
    [self.loadingSpinner startAnimating];
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        // bring the logo back
        self.twitterLogoView.transform = CGAffineTransformMakeScale(1, 1);
        self.view.backgroundColor = [UIColor colorWithRed:46/255.0f green:182/255.0f blue:255/255.0f alpha:1.0f];
        
        [self.loadingSpinner stopAnimating];
        
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            self.wasLoginSuccessful = YES;
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"IsAlreadyLoggedIn"];
            
            [self performSegueWithIdentifier:@"loginSeque" sender:NULL];
            
        } else {
            NSLog(@"Session error: %@", [error localizedDescription]);
            self.wasLoginSuccessful = NO;
        }
    }];
}

@end

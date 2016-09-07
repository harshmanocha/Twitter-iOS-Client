//
//  LoginViewController.h
//  Twitter
//
//  Created by harsh.man on 30/08/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterKit/TwitterKit.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *twitterLogoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@property (nonatomic) BOOL wasLoginSuccessful;

@end

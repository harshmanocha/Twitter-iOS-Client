//
//  LoginViewController.h
//  Twitter
//
//  Created by harsh.man on 30/08/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterKit/TwitterKit.h"
#import "LocalizeHelper.h"

@interface LoginViewController : UIViewController<RefreshLocalizedTextOnViewProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *twitterLogoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic) BOOL wasLoginSuccessful;

@end

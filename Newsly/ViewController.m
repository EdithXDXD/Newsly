//
//  ViewController.m
//  Newsly
//
//  Created by Ruyin Shao on 11/19/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "NewsTitlePage.h"
@import Firebase;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginManager * faceBookLoginManager = [[FBSDKLoginManager alloc] init];
    faceBookLoginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    [faceBookLoginManager logOut];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.delegate = self;
    loginButton.readPermissions =  @[@"public_profile", @"email", @"user_friends"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (error == nil) {
        // ...
        [self performSegueWithIdentifier:@"directToMain" sender:nil];
        
    } else {
       
    }
    
    
    // add user info to firebase authentication
    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                     credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRUser *user, NSError *error) {
                                  if (error) {
                                      // ...
                                      return;
                                  }
                                  // User successfully signed in. Get user data from the FIRUser object
                                  // ...
                              }];
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //direct to main page
    if ([segue.identifier isEqualToString:@"directToMain"]){
        UITabBarController * tabController = (UITabBarController *)segue.destinationViewController;
        UINavigationController *navController = (UINavigationController *)tabController.viewControllers[0];
        NewsTitlePage *controller = (NewsTitlePage *)navController.topViewController;
        controller = [segue destinationViewController];
    }
}

@end

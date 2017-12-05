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
@import Firebase;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    } else {
        NSLog(error.localizedDescription);
    }
    
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

@end

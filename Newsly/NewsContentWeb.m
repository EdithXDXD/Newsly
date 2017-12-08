//
//  NewsContentWeb.m
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "NewsContentWeb.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface NewsContentWeb ()
@property (weak, nonatomic) IBOutlet UIWebView *newsDisplay;
@property (strong, nonatomic) FIRDatabaseReference *ref;


@end

@implementation NewsContentWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    // load web page
    self.newsDisplay.delegate = self;
    NSURL *url = [NSURL URLWithString:_newsUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.newsDisplay setScalesPageToFit:YES];
    [_newsDisplay loadRequest:urlRequest];
    
    //initialize firebase
    self.ref = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] setValue:@{@"NewsList":_newsUrl}];
//    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        // Get user value
//        NSLog(@"local error: %@", snapshot.description);
//        // ...
//    } withCancelBlock:^(NSError * _Nonnull error) {
//       // NSLog(@"local error: %@", error.localizedDescription);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //Check if the web view loadRequest is sending an error message
    //NSLog(@"Web view Error : %@",error);
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

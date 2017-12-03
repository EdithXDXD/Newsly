//
//  NewsContentWeb.m
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "NewsContentWeb.h"

@interface NewsContentWeb ()
@property (weak, nonatomic) IBOutlet UIWebView *newsDisplay;

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

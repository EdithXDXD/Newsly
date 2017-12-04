//
//  NewsModel.m
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "NewsModel.h"
#import "News.h"
@interface NewsModel()
@property NSString* googleNewsAPIKey;
@end

@implementation NewsModel

+(instancetype) sharedModel{
    static NewsModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
        
    });
    
    return _sharedModel;
}

- (instancetype) init{
    self = [super init];
    if (self){
        _headlines = [[NSMutableArray alloc] init];
        _favoritedNews = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) addFavorite: (News*) news{
    [self.favoritedNews addObject:news
     ];
    
}
-(void) requestHeadlines{
    
    // clear headlines
    [self.headlines removeAllObjects];
    /*Get JSON Data from Google News API */
    //1. Send google api request
    self.googleNewsAPIKey = @"de3b0f3f8231437dbb55f9593a428cfd";
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://newsapi.org/v2/everything?sources=bbc-news,abc-news,cnn,business-insider,bloomberg,the-wall-street-journal&page=1&language=en&apiKey=de3b0f3f8231437dbb55f9593a428cfd"];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *headlines = json[@"articles"];
    
    for (NSDictionary* head in headlines){
        News * newsObject = [[News alloc] init];
        newsObject.title = head[@"title"];
        newsObject.ImageURL = head[@"urlToImage"];
        newsObject.shortDescrip = head[@"description"];
        newsObject.publishTime = head[@"publishedAt"];
        newsObject.contentURL = head[@"url"];
        [self.headlines addObject:newsObject];
    }
    
}

-(void) searchNewsByKeyword:(NSString*) keyword{
    // clear headlines
    [self.headlines removeAllObjects];
    
    //1. Send google api request
    self.googleNewsAPIKey = @"de3b0f3f8231437dbb55f9593a428cfd";
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://newsapi.org/v2/everything?q=%@&apiKey=%@",keyword, _googleNewsAPIKey];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *headlines = json[@"articles"];
    
    for (NSDictionary* head in headlines){
        News * newsObject = [[News alloc] init];
        newsObject.title = head[@"title"];
        newsObject.ImageURL = head[@"urlToImage"];
        newsObject.shortDescrip = head[@"description"];
        newsObject.publishTime = head[@"publishedAt"];
        newsObject.contentURL = head[@"url"];
        [self.headlines addObject:newsObject];
    }
}

-(void) searchNewsByKeywordAndSource:(NSString*) keyword :(NSString *)source{
    
    // clear headlines
    [self.headlines removeAllObjects];
    
    //1. Send google api request
    self.googleNewsAPIKey = @"de3b0f3f8231437dbb55f9593a428cfd";
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://newsapi.org/v2/top-headlines?q=%@&sources=%@&apiKey=%@",keyword,source, _googleNewsAPIKey];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *headlines = json[@"articles"];
    
    for (NSDictionary* head in headlines){
        News * newsObject = [[News alloc] init];
        newsObject.title = head[@"title"];
        newsObject.ImageURL = head[@"urlToImage"];
        newsObject.shortDescrip = head[@"description"];
        newsObject.publishTime = head[@"publishedAt"];
        newsObject.contentURL = head[@"url"];
        [self.headlines addObject:newsObject];
    }
}


-(void) searchNewsByKeywordAndSource:(NSString*) keyword sortBy:(NSString*) sortedBy{
    
    // clear headlines
    [self.headlines removeAllObjects];
    
    //1. Send google api request
    self.googleNewsAPIKey = @"de3b0f3f8231437dbb55f9593a428cfd";
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://newsapi.org/v2/top-headlines?q=%@&sortBy=%@&apiKey=%@",keyword,sortedBy, _googleNewsAPIKey];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *headlines = json[@"articles"];
    
    for (NSDictionary* head in headlines){
        News * newsObject = [[News alloc] init];
        newsObject.title = head[@"title"];
        newsObject.ImageURL = head[@"urlToImage"];
        newsObject.shortDescrip = head[@"description"];
        newsObject.publishTime = head[@"publishedAt"];
        newsObject.contentURL = head[@"url"];
        [self.headlines addObject:newsObject];
    }
}

-(void) searchNewsByKeywordAndSource:(NSString*) keyword :(NSString *)source sortBy:(NSString*) sortedBy{
    
    // clear headlines
    [self.headlines removeAllObjects];
    
    //1. Send google api request
    self.googleNewsAPIKey = @"de3b0f3f8231437dbb55f9593a428cfd";
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://newsapi.org/v2/top-headlines?q=%@&sources=%@&sortBy=%@&apiKey=%@",keyword,source,sortedBy, _googleNewsAPIKey];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *headlines = json[@"articles"];
    
    for (NSDictionary* head in headlines){
        News * newsObject = [[News alloc] init];
        newsObject.title = head[@"title"];
        newsObject.ImageURL = head[@"urlToImage"];
        newsObject.shortDescrip = head[@"description"];
        newsObject.publishTime = head[@"publishedAt"];
        newsObject.contentURL = head[@"url"];
        [self.headlines addObject:newsObject];
    }
}


@end

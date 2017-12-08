//
//  NewsModel.m
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "NewsModel.h"
#import "News.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseStorage;

@interface NewsModel()
@property NSString* googleNewsAPIKey;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSString *userID;
@property BOOL initialized;

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
        //initialize firebase
        self.ref = [[FIRDatabase database] reference];
        self.userID = [FIRAuth auth].currentUser.uid;
    }
    return self;
}

-(void) addFavorite: (News*) news{
    //update local
    [self.favoritedNews addObject:news];
    
    // update remote Firebaseß
    NSMutableArray * newsTitles = [[NSMutableArray alloc] init];
    NSMutableArray * newsUrls = [[NSMutableArray alloc] init];
    
    for (News* n in self.favoritedNews){
        [newsTitles addObject: n.title];
        [newsUrls addObject:n.contentURL];
    }
    
    [[[[_ref child:@"users"] child:self.userID]child:@"NewsLists"] setValue:@{@"newsTitles":(NSArray*)newsTitles,@"newsUrls":(NSArray*)newsUrls}];
}

- (void) removeFavorite: (News *) news{
    //update local
    for (int i =0;i < [self.favoritedNews count]; ++i){
        News* currNew = self.favoritedNews[i];
        if ([currNew.contentURL isEqualToString:news.contentURL]){
            [self.favoritedNews removeObjectAtIndex:i];
            break;
        }
    }
   
    // update remote Firebaseß
    NSMutableArray * newsTitles = [[NSMutableArray alloc] init];
    NSMutableArray * newsUrls = [[NSMutableArray alloc] init];
    
    for (News* n in self.favoritedNews){
        [newsTitles addObject: n.title];
        [newsUrls addObject:n.contentURL];
    }
    
     [[[[_ref child:@"users"] child:self.userID]child:@"NewsLists"] setValue:@{@"newsTitles":(NSArray*)newsTitles,@"newsUrls":(NSArray*)newsUrls}];
    
}

/*Check whether current news stored is duplicated*/
- (BOOL) duplicated:(News *)news{
    for (News* n in self.favoritedNews){
        if ([n.contentURL isEqualToString:news.contentURL]){
            return YES;
        }
    }
    return FALSE;
}

/*Sync Firebase fav list*/
-(void) syncFIRFavList{
    //make sure won't crash when first initialized
    [[[_ref child:@"users"] child:self.userID]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.initialized = YES;
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        self.initialized = NO;
    }];
    
    if (self.initialized){
        [self.favoritedNews removeAllObjects];
        [[[[_ref child:@"users"] child:self.userID] child:@"NewsLists"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            // Get user value
            NSArray* titleTemp = snapshot.value[@"newsTitles"];
            NSArray* urlTemp = snapshot.value[@"newsUrls"];
            for (int i =0; i < titleTemp.count; ++i){
                News * newsTemp = [[News alloc] init];
                newsTemp.title = titleTemp[i];
                newsTemp.contentURL = urlTemp[i];
                [self addFavorite:newsTemp];
            }

        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
    
}

//default news list
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

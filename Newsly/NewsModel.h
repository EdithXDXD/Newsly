//
//  NewsModel.h
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface NewsModel : NSObject
@property (strong, nonatomic) NSMutableArray* headlines;
@property (strong, nonatomic) NSMutableArray* favoritedNews;

// Creating the model
+ (instancetype) sharedModel;

//Accessing the news information
- (void) requestHeadlines;
- (void) addFavorite: (News*) news;
- (void) removeFavorite: (News *) news;
- (BOOL) duplicated: (News *) news;

//sync firebase

- (void) syncFIRFavList;

//searches
- (void) searchNewsByKeyword:(NSString*) keyword;
- (void) searchNewsByKeywordAndSource:(NSString*) keyword :(NSString *)source;
- (void) searchNewsByKeywordAndSource:(NSString*) keyword :(NSString *)source sortBy:(NSString*) sortedBy;
- (void) searchNewsByKeywordAndSource:(NSString*) keyword sortBy:(NSString*) sortedBy;

@end

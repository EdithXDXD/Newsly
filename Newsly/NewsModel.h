//
//  NewsModel.h
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (strong, nonatomic) NSMutableArray* headlines;

// Creating the model
+ (instancetype) sharedModel;
//Accessing the news information

- (void) requestHeadlines;
@end

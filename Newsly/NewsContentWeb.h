//
//  NewsContentWeb.h
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsContentWeb : UIViewController

// url passed from the previous page
@property (strong, nonatomic) NSString* newsUrl;
@property (strong, nonatomic) NSString* newsTitle;
@property (strong, nonatomic) News* mNews;
@end

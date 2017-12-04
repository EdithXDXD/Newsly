//
//  SearchNewsPage.h
//  Newsly
//
//  Created by Ruyin Shao on 12/3/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SearchNewsByCondition)(NSString *keyword, NSString *sortedBy, NSString* sources);

@interface SearchNewsPage : UIViewController
@property (copy, nonatomic) SearchNewsByCondition goSearchNews;
@end

//
//  NewsTitleCell.h
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
/** ID */
#define NewsTitleID @"NewsTitleCell"
#define NewsTitleHeight 150

@interface NewsTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *shortDescription;

@end

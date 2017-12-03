//
//  NewsTitlePage.m
//  Newsly
//
//  Created by Ruyin Shao on 12/2/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "NewsTitlePage.h"
#import "NewsTitleCell.h"
#import "NewsModel.h"
#import "News.h"
#import "NewsContentWeb.h"

@interface NewsTitlePage ()
@property (strong, nonatomic) NewsModel *dataModel;
@property (strong, nonatomic) NSString* selectedNewsUrl; //for content page

@end

@implementation NewsTitlePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataModel = [NewsModel sharedModel];
    [self.dataModel requestHeadlines];
    UINib *nib = [UINib nibWithNibName:NewsTitleID bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:NewsTitleID];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.dataModel.headlines count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsTitleID forIndexPath:indexPath];
    // Configure the cell...
    if (cell == nil){
         cell = [[NewsTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsTitleID];
    }
   
    News* currNews = self.dataModel.headlines[indexPath.row];
    
    cell.newsTitle.text = [currNews title];

    //get image
    NSURL *url = [NSURL URLWithString:currNews.ImageURL];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    cell.newsImage.image = tmpImage;
    cell.shortDescription.text = [currNews shortDescrip];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // store the url for next page
    News* currNews = self.dataModel.headlines[indexPath.row];
    
    self.selectedNewsUrl = [currNews contentURL];
   // redirect to next page
    [self performSegueWithIdentifier:@"webDisplay" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull NewsTitleCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
 
    

    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"webDisplay"]){
        NewsContentWeb * contentPage = [segue destinationViewController];
        contentPage.newsUrl = self.selectedNewsUrl;
    }
}

@end

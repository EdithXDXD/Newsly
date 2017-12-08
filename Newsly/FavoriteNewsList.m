//
//  FavoriteNewsList.m
//  Newsly
//
//  Created by Ruyin Shao on 12/8/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "FavoriteNewsList.h"
#import "NewsContentWeb.h"
#import "NewsModel.h"
#import "News.h"

@interface FavoriteNewsList ()
@property (strong, nonatomic) NewsModel* dataModel;
@property (strong, nonatomic) NSString* urlSelected;
@property (strong, nonatomic) NSString* titleSelected;

@end

@implementation FavoriteNewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
   self.dataModel = [NewsModel sharedModel];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataModel favoritedNews] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorNews" forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favorNews"];
    }
    
    cell.textLabel.text = [(News* )[[self.dataModel favoritedNews] objectAtIndex:indexPath.row] title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.urlSelected = [(News* )self.dataModel.favoritedNews[indexPath.row] contentURL];
    self.titleSelected = [(News* )[[self.dataModel favoritedNews] objectAtIndex:indexPath.row] title];
    [self performSegueWithIdentifier:@"displayFavorite" sender:nil];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // delete from data model
    [self.dataModel removeFavorite:(News* )self.dataModel.favoritedNews[indexPath.row]];
    // delete from table view
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



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
    if ([segue.identifier isEqualToString:@"displayFavorite"]){
        NewsContentWeb * newsContentPage = segue.destinationViewController;
       // initialize members
        newsContentPage.newsUrl = self.urlSelected;
        newsContentPage.newsTitle = self.titleSelected;
       
        News* newTemp = [[News alloc] init];
        newTemp.contentURL = self.urlSelected;
        newTemp.title = self.titleSelected;
        newsContentPage.mNews = newTemp;
        
    }
}


@end

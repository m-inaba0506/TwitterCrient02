//
//  TimeLineTableViewController.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import "TimeLineTableViewController.h"
#import "DetailViewController.h"
#import "ReplyTableViewController.h"
#import "MyTabBarController.h"


#define REFRESH_HEADER_HEIGHT 52.0f


@interface TimeLineTableViewController ()

@end

@implementation TimeLineTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad{
    
    
    [super viewDidLoad];
    
    
    self.accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *twitterType =
    
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
     
                                               options:NULL
     
                                            completion:^(BOOL granted, NSError *error) {
                                                
                                                if (granted) {
                                                    
                                                    self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    
                                                    if (self.twitterAccounts > 0) {
                                                        
                                                        //ACAccount *account = [self.twitterAccounts lastObject];
                                                        _account = [self.twitterAccounts objectAtIndex:0];
                                                        
                                                        self.identifier = _account.identifier;
                                                        
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                        });
                                                        
                                                    }
                                                    
                                                    else {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                        });
                                                        
                                                    }
                                                    
                                                }
                                                
                                                else {
                                                    
                                                    NSLog(@"Account Error: %@", [error localizedDescription]);
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                    });
                                                    
                                                }
                                                
                                            }];
    
    
    self.mainQueue = dispatch_get_main_queue();
    
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    self.accountStore = [[ACAccountStore alloc] init]; // アカウントストアの初期化
    
    //  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"]; // この行はテーブルビューセルの再利用で必要（iOS6以降)
    
    // iOS6以降のセル再利用のパターン
    [self.tableView registerClass:[TimeLineCell class] forCellReuseIdentifier:@"TimeLineCell"];
    
    
    
    [self aaa];
   // [self imadake];
    
    
//    //更新
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self
//                       action:@selector(startDownload)
//             forControlEvents:UIControlEventValueChanged];
//    self.refreshControl = refreshControl;
//    //ここまで
    
    _account = [self.twitterAccounts objectAtIndex:0];
    
    _name2 = _account.username;
    
  [self addPullToRefreshHeader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!self.timelineData) { // このif節は超重要！
        return 1;
    } else {
        return [self.timelineData count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iOS6以降のセル再利用のパターン
    
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    /*if (self.timelineData) {
     
     cell.tweetTextLabel.text = self.httpErrorMessage;
     
     cell.tweetTextLabelHeight = 24;
     
     } else*/ if (!self.timelineData) {
         cell.tweetTextLabel.text = @"Loading...";
         cell.tweetTextLabelHeight = 200;
         
     } else {
         
         NSString *name = [[[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];


         
         NSString *text = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
         
         
         
         CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:16]
                             
                             constrainedToSize:CGSizeMake(300, 1000)
                             
                                 lineBreakMode:NSLineBreakByWordWrapping];
         
         cell.tweetTextLabelHeight = labelSize.height;
         
         cell.tweetTextLabel.text = text;
         
         cell.nameLabel.text = name;
         
         
         
         cell.imageView.image = [UIImage imageNamed:@"blank.png"];
         
         
         
         UIApplication *application = [UIApplication sharedApplication];
         
         application.networkActivityIndicatorVisible = YES;
         
         
         dispatch_async(self.imageQueue, ^{
             
             NSString *url;
             
             NSDictionary *tweetDictionary = [self.timelineData objectAtIndex:indexPath.row];
             
             
             
             if ([[tweetDictionary allKeys] containsObject:@"retweeted_status"]) {
                 
                 // リツイートの場合はretweeted_statusキー項目が存在する
                 
                 url = [[[tweetDictionary objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"profile_image_url"];
                 
             } else {
                 
                 url = [[tweetDictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
                 
             }
             
             
             
             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
             
             dispatch_async(self.mainQueue, ^{
                 
                 UIApplication *application = [UIApplication sharedApplication];
                 
                 application.networkActivityIndicatorVisible = NO;
                 
                 UIImage *image = [[UIImage alloc] initWithData:data];
                 
                 cell.imageView.image = image;
                 
                 [cell setNeedsLayout];
                 
             });
             
         });
     }
    cell.imageView.layer.masksToBounds = YES;                    //imageViewの角丸
    cell.imageView.layer.cornerRadius = 7.0;                     //imageViewの角丸

    _favorited = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"favorited"];
    self.fav1 = @1;
    if([_favorited isEqualToNumber:_fav1])
    {
        cell.ribon.hidden = NO;
    }else{
        cell.ribon.hidden = YES;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSString *content = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16]
                           constrainedToSize:CGSizeMake(300, 1000)
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 35;
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }w
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    // Navigation logic may go here. Create and push another view controller.
    
    TimeLineCell *cell = (TimeLineCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    detailViewController.name = cell.nameLabel.text;
    
    detailViewController.text = cell.tweetTextLabel.text;
    
    detailViewController.image = cell.imageView.image;
    
    detailViewController.name2 = self.name2;
   
    detailViewController.idStr = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"id_str"];

    
    detailViewController.favorited = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"favorited"];
    
    
    ////////////////
    //ReplyTweetSheetViewController *replyTweetSheetViewController = [segue destinationViewController];
    
    detailViewController.identifier = self.identifier;
    detailViewController.selectAccount = _account;
    ///////////////////
    
    // ...
    
    detailViewController.hidesBottomBarWhenPushed = YES;
    
    
    // Pass the selected object to the new view controller.
    
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}




- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
   // [super viewDidLoad];
    
    //  Step 1:  Obtain access to the user's Twitter accounts
    
    ACAccountType *twitterType =
    
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
     
                                               options:NULL
     
                                            completion:^(BOOL granted, NSError *error) {
                                                
                                                if (granted) {
                                                    
                                                    //  Step 2:  Create a request
                                                    
                                                    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    
                                                  
                                                   NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"@"/1.1/statuses/home_timeline.json"];
                                                   
                                                    
                                                    
                                                    NSDictionary *params = @{@"count" : @"20",
                                                                             
                                                                             @"trim_user" : @"0",
                                                                             
                                                                             @"include_entities" : @"0"};
                                                    
                                                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                          
                                                                                            requestMethod:SLRequestMethodGET
                                                                          
                                                                                                      URL:url
                                                                          
                                                                                               parameters:params];
                                                    
                                                    
                                                    
                                                    //  Attach an account to the request
                                                    
                                                    [request setAccount:[twitterAccounts lastObject]];
                                                    
                                                    
                                                    
                                                    //  Step 3:  Execute the request
                                                    
                                                    [request performRequestWithHandler:^(NSData *responseData,
                                                                                         
                                                                                         NSHTTPURLResponse *urlResponse,
                                                                                         
                                                                                         NSError *error) { // ここからは別スレッド（キュー）
                                                        
                                                        if (responseData) {
                                                            
                                                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                                                
                                                                NSError *jsonError;
                                                                
                                                                self.timelineData =
                                                                
                                                                [NSJSONSerialization JSONObjectWithData:responseData
                                                                 
                                                                                                options:NSJSONReadingAllowFragments
                                                                 
                                                                                                  error:&jsonError];
                                                                
                                                                if (self.timelineData) {
                                                                    
                                                                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                                                                    dispatch_async(dispatch_get_main_queue(), ^{ // UI処理はメインキューで
                                                                        [self.tableView reloadData];
                                                                    });
                                                                }
                                                                else {
                                                                    // Our JSON deserialization went awry
                                                                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                                                }
                                                            }
                                                            else {
                                                                // The server did not respond successfully... were we rate-limited?
                                                                NSLog(@"The response status code is %d", urlResponse.statusCode);
                                                            }
                                                        }
                                                    }];
                                                }
                                                else {
                                                    // Access was not granted, or an error occurred
                                                    NSLog(@"%@", [error localizedDescription]);
                                                }
                                            }];
    self.tableView.dataSource = self;
    
}
-(void)startDownload{
    //[self aaa];
    [self imadake];
    [self.refreshControl endRefreshing];
    _isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
    
    
}
-(void)aaa
{
    
    ACAccountType *twitterType =
    
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
     
                                               options:NULL
     
                                            completion:^(BOOL granted, NSError *error) {
                                                
                                                if (granted) {
                                                    
                                                    //  Step 2:  Create a request
                                                    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    _account = [accountStore accountWithIdentifier:self.identifier];
    

                                                    
                                                   NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"@"/1.1/statuses/home_timeline.json"];


                                                    
                                                    NSDictionary *params = @{@"count" : @"50",
                                                                             
                                                                             @"trim_user" : @"0",
                                                                             
                                                                        //   @"in_reply_to_status_id" :@"0",
                                                                             
                                                                             @"include_entities" : @"0"};
                                                    
                                                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                          
                                                                                            requestMethod:SLRequestMethodGET
                                                                          
                                                                                                      URL:url
                                                                          
                                                                                               parameters:params];
                                                    
                                                    
                                                    
                                                    //  Attach an account to the request
                                                    
                                                    //[request setAccount:[twitterAccounts lastObject]];
                                                    [request setAccount:_account];
    
                                                    
                                                    //  Step 3:  Execute the request
                                                    
                                                    [request performRequestWithHandler:^(NSData *responseData,
                                                                                         
                                                                                         NSHTTPURLResponse *urlResponse,
                                                                                         
                                                                                         NSError *error) { // ここからは別スレッド（キュー）
                                                        
                                                        if (responseData) {
                                                            
                                                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                                                
                                                                NSError *jsonError;
                                                                
                                                                self.timelineData =
                                                                
                                                                [NSJSONSerialization JSONObjectWithData:responseData
                                                                 
                                                                                                options:NSJSONReadingAllowFragments
                                                                 
                                                                                                  error:&jsonError];
                                                                
                                                                if (self.timelineData) {
                                                                    
                                                                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                                                                    dispatch_async(dispatch_get_main_queue(), ^{ // UI処理はメインキューで
                                                                        [self.tableView reloadData];
                                                                    });
                                                                }
                                                                else {
                                                                    // Our JSON deserialization went awry
                                                                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                                                }
                                                            }
                                                            else {
                                                                // The server did not respond successfully... were we rate-limited?
                                                                NSLog(@"The response status code is %d", urlResponse.statusCode);
                                                            }
                                                        }
                                                    }];
                                                }
                                                else {
                                                    // Access was not granted, or an error occurred
                                                    NSLog(@"%@", [error localizedDescription]);
                                                }
                                            }
     ];
    
    self.tableView.dataSource = self;
}
- (IBAction)setAccountAction:(id)sender { // アクションシート表示の定義
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    
    sheet.delegate = self;
    
    sheet.title = @"選択してください。";
    
    for (_account in self.twitterAccounts) {
        
        [sheet addButtonWithTitle:_account.username];
    
    }
    
    [sheet addButtonWithTitle:@"キャンセル"];
    
    sheet.cancelButtonIndex = self.twitterAccounts.count;
    
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet  clickedButtonAtIndex:(NSInteger)buttonIndex { // アクションシート選択時の処理


    if (self.twitterAccounts.count > 0) {
        
        if (buttonIndex != self.twitterAccounts.count) {
            
            
            _account = [self.twitterAccounts objectAtIndex:buttonIndex];
            
            self.identifier = _account.identifier;
             _name2 = _account.username;
            
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.account = _account;
            
            
            
            NSLog(@"Account set! %@", _account.username);
        }
        else {
            NSLog(@"cancel!");
        }
    }
}





- (void)addPullToRefreshHeader {
    _textPull = @"引き下げて更新...";
    _textRelease = @"指を離して更新...";
    _textLoading = @"読み込み中...";

    _refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    
    _refreshLabel.backgroundColor = [UIColor clearColor];
    _refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    _refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    _refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    _refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    _refreshSpinner.hidesWhenStopped = YES;
    
    [_refreshHeaderView addSubview:_refreshLabel];
    [_refreshHeaderView addSubview:_refreshArrow];
    [_refreshHeaderView addSubview:_refreshSpinner];
    [self.tableView addSubview:_refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isLoading) return;
    _isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (_isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                _refreshLabel.text = self.textRelease;
                [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                _refreshLabel.text = self.textPull;
                [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isLoading) return;
    _isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
    
}

- (void)startLoading {
    _isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        _refreshLabel.text = self.textLoading;
        _refreshArrow.hidden = YES;
        [_refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    
    _isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
    
}

- (void)stopLoadingComplete {
    // Reset the header
    _refreshLabel.text = self.textPull;
    _refreshArrow.hidden = NO;
    [_refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    
    [self performSelector:@selector(startDownload) withObject:nil afterDelay:2.0];
}




-(void)imadake
{
    
    self.mainQueue = dispatch_get_main_queue();
    
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    _account = [accountStore accountWithIdentifier:self.identifier];
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                  
                  @"/1.1/statuses/home_timeline.json"];
    
    NSDictionary *params = @{@"count" : @"50",
                             
                             @"trim_user" : @"0",
                             
                             @"include_entities" : @"0"};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                          
                                            requestMethod:SLRequestMethodGET
                          
                                                      URL:url
                          
                                               parameters:params];
    
    
    
    //  Attach an account to the request
    
    [request setAccount:_account];
    
    
    
    //  Execute the request
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         
                                         NSHTTPURLResponse *urlResponse,
                                         
                                         NSError *error) {
        
        if (responseData) {
            
            self.httpErrorMessage = nil;
            
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                
                NSError *jsonError;
                
                self.timelineData =
                
                [NSJSONSerialization JSONObjectWithData:responseData
                 
                                                options:NSJSONReadingAllowFragments
                 
                                                  error:&jsonError];
                
                if (self.timelineData) {
                    
                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableView reloadData];
                        
                    });
                    
                }
                
                else {
                    
                    // Our JSON deserialization went awry
                    
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                    
                }
                
            }
            
            else {
                
                // The server did not respond successfully... were we rate-limited?
                
                self.httpErrorMessage =
                
                [NSString stringWithFormat:@"The response status code is %d", urlResponse.statusCode];
                
                NSLog(@"HTTP Error: %@", self.httpErrorMessage);
                
            }
            
        }
        
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ReplyTableViewController *replyTableViewController;
    replyTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReplyTableViewController"];

    

    if ([segue.identifier isEqualToString:@"tweetSheet"]) {
        
        
        TweetSheetViewController *tweetSheetViewController = [segue destinationViewController];
        
        tweetSheetViewController.identifier = self.identifier;
        
        tweetSheetViewController.selectAccount = _account;

    }
//    else if([segue.identifier isEqualToString:@"ReplyTableViewController"]){
//        
//        replyTableViewController.account2 = self.account;
//        
//        replyTableViewController.identifier = self.identifier;
//        
//        replyTableViewController.selectAccount = _account;
//        
//        replyTableViewController.identifier = _account.identifier;
//
//    }
    
}

@end

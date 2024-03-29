//
//  DetailViewController.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import "DetailViewController.h"
//#import <QuartzCore/QuartzCore.h>
//#import <Social/Social.h>
//#import <Accounts/Accounts.h>
#import "ReplyTweetSheetViewController.h"
#import "WebViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigationController = self.navigationController;
    
    
    self.imageView.image = self.image;
    self.imageView.layer.masksToBounds = YES;                    //imageViewの角丸 //#import <QuartzCore/QuartzCore.h>
    self.imageView.layer.cornerRadius = 7.0;                    //imageViewの角丸 //#import <QuartzCore/QuartzCore.h>
    
    self.nameView.text = self.name;
    self.nameView.font = [UIFont boldSystemFontOfSize:11.0f];
    self.textView.text = self.text;
    
    
    [[_textView layer] setCornerRadius:7.0]; //textViewの角丸
    [_textView setClipsToBounds:YES];         //textViewの角丸
    [[_nameView layer] setCornerRadius:7.0]; //nameViewの角丸
    [_nameView setClipsToBounds:YES];         //nameviewの角丸
    _textView.layer.borderWidth = 1;                                //textViewの枠線太さ
    _textView.layer.borderColor = [[UIColor blackColor] CGColor];   //黒
    _nameView.layer.borderWidth = 1;                                //nameViewの枠の太さ
    _nameView.layer.borderColor = [[UIColor blackColor] CGColor];   //黒
    
    _textView.layer.masksToBounds = NO;   // 領域外をマスクで切り取る設定をしない
    _textView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);  // 影のかかる方向を指定する
    _textView.layer.shadowOpacity = 0.7f; // 影の透明度
    _textView.layer.shadowColor = [UIColor blackColor].CGColor;// 影の色
    _textView.layer.shadowRadius = 10.0f; // ぼかしの量
    
    _nameView.layer.masksToBounds = NO;
    _nameView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    _nameView.layer.shadowOpacity = 0.7f;
    _nameView.layer.shadowColor = [UIColor blackColor].CGColor;
    _nameView.layer.shadowRadius = 10.0f;
    
    
    
    BOOL nakami = [_name isEqualToString:_name2];
    
    if(nakami){
        NSLog(@"IDいっしょ");
        self.retweetActionLabel.hidden = YES;
        self.favoritedActionLabel.hidden = YES;
    }
    
            self.aaa = @1;
            //_favorited = @1;
            if([_favorited isEqualToNumber:_aaa])
            {
                self.favLabel.hidden = NO;
            }
            else{
                self.favLabel.hidden = YES;
            }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)retweetAction:(id)sender {
    
    
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.identifier];//自分

    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", self.idStr];
    NSURL *url = [NSURL URLWithString:urlString];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:nil];
    
    //  Attach an account to the request
    [request setAccount:account];
    
    //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];//前の画面に戻る
    

}
- (IBAction)favorite:(id)sender {
   
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
    
    NSURL *url;
    //白澤氏提供　感謝！
    self.aaa = @1;
    if([_favorited isEqualToNumber:_aaa])
    {
        NSLog(@"ふぁぼってあるからけす");
        url = [NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/destroy.json"];
        UIAlertView *alert =[[UIAlertView alloc]
                             initWithTitle:@"Favorite"
                             message:@"外しました"
                             delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else{
        NSLog(@"ふぁぼってないからふぁぼる");
        url = [NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/create.json"];
        UIAlertView *alert =[[UIAlertView alloc]
                             initWithTitle:@"Favorite"
                             message:@"追加しました"
                             delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil];
        [alert show];
    }
    /*  昔の書き方
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_idStr forKey:@"id"];
    [params setObject:@"true" forKey:@"include_entities"];
        ↓今の書き方*/
    NSDictionary *params = @{@"id" : self.idStr,
                             @"include_entities" : @"true"};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    
    //  Attach an account to the request
    [request setAccount:account];
   //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];//前の画面に戻る
}
- (IBAction)replyAction:(id)sender {
    
      ReplyTweetSheetViewController *replyTweetSheetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReplyTweetSheetViewController"];
    
    
    
    
    
    
    replyTweetSheetViewController.idStr = self.idStr;
    
   
    
        replyTweetSheetViewController.identifier = self.identifier;
    
        replyTweetSheetViewController.selectAccount = _selectAccount;

    replyTweetSheetViewController.name = self.nameView.text;
    
    [self.navigationController pushViewController:replyTweetSheetViewController animated:YES];
    
    
    
}
@end

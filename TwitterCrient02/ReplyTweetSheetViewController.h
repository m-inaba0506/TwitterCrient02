//
//  ReplyTweetSheetViewController.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <QuartzCore/QuartzCore.h>
#import "TweetSheetViewController.h"
#import "TimeLineTableViewController.h"


@interface ReplyTweetSheetViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
- (IBAction)tweetAction:(id)sender;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *in_reply_to_status_id;
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) UIImageView *imageSelect;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *userimage;


@property (nonatomic, strong) NSArray *account;
@property (nonatomic, strong) NSArray *twitterAccounts;
@property (nonatomic, strong)ACAccount *selectAccount;
@end

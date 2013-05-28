//
//  MyTabBarController.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/27.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import "MyTabBarController.h"
#import "ReplyTableViewController.h"
#import "TimeLineTableViewController.h"


@interface MyTabBarController ()

@end

@implementation MyTabBarController

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
     self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // ここに記述された処理がタブの切替時に呼び出される
    
    ////////////
    ReplyTableViewController *replyTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReplyTableViewController"];
//    TimeLineTableViewController *timeLineTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineTableViewController"];

    
    replyTableViewController.account2 = _account;
    
//    replyTableViewController.identifier = timeLineTableViewController.account.identifier;
//    
//    replyTableViewController.selectAccount = timeLineTableViewController.account;
   
    /////////////
    

}
@end

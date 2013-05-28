//
//  MyTabBarController.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/27.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TimeLineTableViewController.h"

@interface MyTabBarController : UITabBarController<UITabBarControllerDelegate>


@property (nonatomic, strong)ACAccount *account;

@end

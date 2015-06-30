//
//  CustomViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "CustomViewController.h"
#import "MyAccoutViewController.h"
#import "HomeViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //投资管理
    UINavigationController *touziNav = [self.storyboard instantiateViewControllerWithIdentifier:@"TouziNav"];
    UITabBarItem *touziItem = [[UITabBarItem alloc] initWithTitle:@"投资" image:[UIImage imageNamed:@"tabbar14"] tag:0];
    touziNav.tabBarItem = touziItem;
    //活动
    UINavigationController *activityNav = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityNav"];
    UITabBarItem *activityItem = [[UITabBarItem alloc] initWithTitle:@"活动" image:[UIImage imageNamed:@"tabbar13"] tag:1];
    activityNav.tabBarItem = activityItem;
    //首页
    HomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabbar12"] tag:2];
    homeItem.image = [[UIImage imageNamed:@"tabbar12"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem = homeItem;
    //我的账户
    MyAccoutViewController *myAccountVC = [[MyAccoutViewController alloc] initWithNibName:@"MyAccoutViewController" bundle:nil];
    UINavigationController *myAccountNav = [[UINavigationController alloc] initWithRootViewController:myAccountVC];
    UITabBarItem *myAccountItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"tabbar16"] tag:3];
    myAccountNav.tabBarItem = myAccountItem;
    //更多
    UINavigationController *moreNav = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreNav"];
    UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"tabbar15"] tag:4];
    moreNav.tabBarItem = moreItem;
    
    self.viewControllers = @[touziNav,activityNav,homeVC,myAccountNav,moreNav];
    self.selectedIndex = 2;
    self.tabBar.tintColor = [UIColor brownColor];
    
    //去除边框上的黑线
    [ self.tabBar setBackgroundImage:[Tool createImageWithColor:[UIColor whiteColor]]];
    [ self.tabBar setShadowImage:[Tool createImageWithColor:[UIColor clearColor]]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

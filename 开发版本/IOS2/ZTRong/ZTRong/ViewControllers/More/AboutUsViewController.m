//
//  AboutUsViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    NSArray *nameArray;
    NSArray *detailArray;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nameArray = @[@"官方网站",@"微信号",@"客服电话"];
    detailArray = @[@"www.ztrong.com",@"ztrong",@"400-922-1111"];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"联系我们"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//
//- (IBAction)shareButton:(id)sender
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享功能暂未实现，敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
//    
//}
@end

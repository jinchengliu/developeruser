//
//  QRDetailViewController.m
//  ZTRong
//
//  Created by yangmine on 15/6/10.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "QRDetailViewController.h"

@interface QRDetailViewController ()

@end

@implementation QRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([UserTool userIsLogin])
    {
        self.titleLabel.text = @"扫一扫，开启财富人生";
        self.QRiamgeView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.QRURL]]];
        self.detailLabel.text = @"说明：\n1、扫描成功后，请您的好友打开链接。\n2、您的好友在中投融页面中根据提示完成注册认证后，即可获取1680元红包。\n3、参与投资后，即可参加各类超级给力的活动。";
    }
    else
    {
        self.titleLabel.text = @"扫一扫，下载APP，一起赚钱";
        self.QRiamgeView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.QRURL]]];
        self.detailLabel.text = @"说明：\n1、扫描成功后，请您下载并根据提示安装APP。\n2、您的好友在APP页面中根据提示完成注册认证后，即可获取1680元红包。\n3、参与投资后，即可参加各类超级给力的活动。";
    }

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

//
//  YLQRcodeViewController.m
//  yilong
//
//  Created by fcl on 15/4/10.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "YLQRcodeViewController.h"
#import "SYQRCodeViewController.h"

@interface YLQRcodeViewController ()

@end

@implementation YLQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.saomiaoBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.saomiaoBtn.layer.borderWidth = 1.5;
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

- (IBAction)saomiaoAction:(id)sender {
    
    //扫描二维码
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        
        
        
        

        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        
        NSRange range = [qrString rangeOfString:@"regCode="];
        NSInteger loc = range.location + range.length;
        NSString *QRcode = [qrString substringFromIndex:loc];
        
        
        // self.saomiaoLabel.text = qrString;
        [self.delegate SetInvitationCode:QRcode];
        [self.navigationController popViewControllerAnimated:YES];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
        self.saomiaoLabel.text = @"fail~";
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        self.saomiaoLabel.text = @"cancle~";
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
}
@end

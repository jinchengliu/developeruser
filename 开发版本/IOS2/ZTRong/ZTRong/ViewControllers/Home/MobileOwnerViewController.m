//
//  MobileOwnerViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "MobileOwnerViewController.h"

@interface MobileOwnerViewController ()
{
    NSArray *_dataList;
    NSString *_total;//一共的数据
    NSString *_totalPage;//页数
    
    __weak IBOutlet UIView *_firstBid;
    __weak IBOutlet UIButton *_grabButton;
}
@end

@implementation MobileOwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstBid.layer.cornerRadius = 4;
    _firstBid.layer.borderColor = [UIColor brownColor].CGColor;
    _firstBid.layer.borderWidth = 0.5;
    _firstBid.layer.masksToBounds = YES;
    
    _grabButton.layer.cornerRadius = 4;
    _grabButton.layer.masksToBounds = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //获取数据
    NSDictionary *md5 = @{@"page":@"1"};
    NSDictionary *params = @{@"channel":@"APP",
                             @"params":md5,
                             @"sign":[StringHelper dicSortAndMD5:md5],
                             @"version":@"1.0"};
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/exclusiveItemList.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if ([dict[@"success"] integerValue] == 1) {
            _dataList = dict[@"map"][@"pageInfo"][@"rows"];
            _total = dict[@"map"][@"pageInfo"][@"total"];
            _totalPage = dict[@"map"][@"pageInfo"][@"totalPage"];
            
        }
        
        
    } failure:^(NSError *NSError) {
        
        
        
//        [HUD hide:YES];
        
        NSString *message= [Tool getErrorMsssage:NSError];
        
        NSLog(@"%@",message);
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UserAction

//秒杀说明
- (IBAction)seckillClick:(UIButton *)sender {
    WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"web"];
    webVC.url = @"www.baidu.com";
    webVC.title = @"秒杀说明";
    [self.navigationController pushViewController:webVC animated:YES];
}
//返回
- (IBAction)backClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

//
//  InvestmentDetailViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/15.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "InvestmentDetailViewController.h"
#import "CircleProcessView.h"
#import "loginViewController.h"
#import "SharePopup.h"

@interface InvestmentDetailViewController ()<UIAlertViewDelegate>
{
    
    __weak IBOutlet UIButton *_topUpBtn;
    __weak IBOutlet UILabel *_rateLbl;
    __weak IBOutlet UILabel *_repayPeriodLbl;
    __weak IBOutlet UILabel *_repayMentChangeLbl;
    __weak IBOutlet UILabel *_currentPriceTotalLbl;
    __weak IBOutlet UILabel *_creditAmountStrLbl;
    __weak IBOutlet UILabel *_interestBearingStrLbl;
    __weak IBOutlet UILabel *_isLoginLbl;
    __weak IBOutlet UIButton *_loginBtn;
    __weak IBOutlet UITextField *_amountTxt;
    __weak IBOutlet UILabel *_isUseIntegralStrLbl;
    __weak IBOutlet UILabel *_returnRateLbl;
    __weak IBOutlet UILabel *_productLbl;
    __weak IBOutlet UILabel *_sendLbl;   //借款企业
    __weak IBOutlet UILabel *_creditLbl;  //信用等级
    __weak IBOutlet UILabel *_isMakeOverLbl;
    __weak IBOutlet NSLayoutConstraint *_loginButtonWidth;
    
    float _btnHeight;
}
@end

@implementation InvestmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _topUpBtn.layer.borderColor = [UIColor brownColor].CGColor;
    _topUpBtn.layer.borderWidth = 0.5;
    
    _returnRateLbl.adjustsFontSizeToFitWidth = YES;
    _loginBtn.enabled = NO;
    
    _btnHeight = _loginButtonWidth.constant;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = @"下拉刷新...";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"正在刷新中...";
    
    
    _amountTxt.keyboardType=UIKeyboardTypeNumberPad;
}
//上拉刷新
-(void)headerRereshing{

    self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
    [self getNetWorkData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    
}
//获取网络数据
- (void)getNetWorkData{
    
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"itemId":_itemID}];
    
    if ([UserTool userIsLogin]) {
        [dic setObject:[UserTool getUserID] forKey:@"userId"];
    }
    NSMutableDictionary *params =[Tool getHttpParams:dic];

    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kInvestItemStatic] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        
        if([dict[@"success"] intValue] == 1){
            [self hideHUD:@""];
            //成功
            //更新页面
            NSDictionary *itemDO = (NSDictionary *)dict[@"map"][@"itemDO"];
            
            _rateLbl.text = itemDO[@"yearRateStr"];
            _repayPeriodLbl.text = [NSString stringWithFormat:@"%@%@",itemDO[@"repayPeriod"],itemDO[@"repayUnitStr"]];
            _repayMentChangeLbl.text = itemDO[@"repayMentChange"];
            _currentPriceTotalLbl.text = itemDO[@"currentPriceTotalStr"];
            _creditAmountStrLbl.text = [NSString stringWithFormat:@"产品规模 : %@",itemDO[@"repayPeriod"]];
            _isUseIntegralStrLbl.text = [NSString stringWithFormat:@"是否积分抵扣 : %@",itemDO[@"isUseIntegralStr"]];
            _interestBearingStrLbl.text = [NSString stringWithFormat:@"计息方式 : %@",itemDO[@"interestBearingStr"]];
            
            //返回比例 *后面换色
            NSString *buyIntegralStr = [NSString stringWithFormat:@"积分返还比例 : %@",itemDO[@"buyIntegralStr"]];
            NSArray *arrs = [itemDO[@"buyIntegralStr"] componentsSeparatedByString:@"×"];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:buyIntegralStr];
            if (arrs.count == 2) {
                NSRange range = [buyIntegralStr rangeOfString:@"×"];
                range.length = 1 + [arrs[1] length];
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
            }
            
            _returnRateLbl.attributedText = attributedString;
            
            
            if ([itemDO[@"isMakeOver"] integerValue] != 1) {
                _isMakeOverLbl.hidden = YES;
            }
            
            if ([UserTool userIsLogin]) {
                //账户余额
                [_loginBtn setTitle:[NSString stringWithFormat:@"%@元",dict[@"map"][@"amount"]] forState:UIControlStateNormal];
                _loginBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                _loginBtn.enabled = NO;
                _loginButtonWidth.constant = _btnHeight + 60;
                
            }else{
                
                [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
                _loginBtn.enabled = YES;
                _loginButtonWidth.constant = _btnHeight;
            }

            
            //起投金额，递增金额
            _amountTxt.placeholder = [NSString stringWithFormat:@"%d起投,%d起增",[itemDO[@"minPrice"] intValue]/100,[itemDO[@"stepPrice"] intValue]/100];
            _amountTxt.adjustsFontSizeToFitWidth = YES;
            
            //项目基本信息
            NSArray *list = (NSArray *)dict[@"map"][@"spuAPPList"];
            for (NSDictionary *tempDict in list) {
                if ([tempDict[@"name"] isEqualToString:@"产品类型"]) {
                    _productLbl.text = tempDict[@"spuValueStr"];
                    _productLbl.adjustsFontSizeToFitWidth = YES;
                    
                }else if ([tempDict[@"name"] isEqualToString:@"借款企业"]){
                    _sendLbl.text =  tempDict[@"spuValueStr"] ;
                    _sendLbl.adjustsFontSizeToFitWidth = YES;
                    
                }else if ([tempDict[@"name"] isEqualToString:@"客户信用等级"]){
                    
                    _creditLbl.text = tempDict[@"spuValueStr"] ;
                    _creditLbl.textColor = [UIColor orangeColor];
                    _creditLbl.adjustsFontSizeToFitWidth = YES;
                }
            }
            
            CGRect rect = CGRectMake((self.view.bounds.size.width*110)/320, 22, 80, 80);
            CircleProcessView *circleView = [[CircleProcessView alloc] initWithFrame:rect];
            circleView.progressWidth = 5;
            circleView.tag = 6;
            circleView.progressColor = [UIColor colorWithRed:227/255.0f green:66/255.0f blue:44/255.0f alpha:0.8];
//            [circleView setProgress:0.5];
            circleView.trackColor = [UIColor colorWithRed:220/255.0f green:222/255.0f blue:224/255.0f alpha:1];
            [self.view addSubview:circleView];
            UILabel *remainAmount = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width*234)/320, 35, 50, 70)];
            remainAmount.textColor = [UIColor blackColor];
            remainAmount.font = [UIFont systemFontOfSize:10];
            remainAmount.tag = 7;
            remainAmount.numberOfLines = 2;
            remainAmount.textAlignment = 1;
            remainAmount.adjustsFontSizeToFitWidth = YES;
            [self.view addSubview:remainAmount];
            NSNumber *status = itemDO[@"status"];
            if ([status integerValue] == 1007) {
                //满标
                [circleView setProgress:1];
                remainAmount.text = @"满";
                
            }else{
                [circleView setProgress:[itemDO[@"currentPreStr"] floatValue] / 100];
                remainAmount.text = [NSString stringWithFormat:@"剩余金额 %@",itemDO[@"currentPriceTotalStr"]];
            }
        }else{
            
            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            [self hideHUD:message];
        }
    } failure:^(NSError *NSError) {
        
        NSString *message= [Tool getErrorMsssage:NSError];
        [self hideHUD:message];
    }];

}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_amountTxt ==nil) {
        NSLog(@"1111111");
    }
    [self getNetWorkData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_amountTxt resignFirstResponder];
}
#pragma mark - 
#pragma mark - UserAction
- (IBAction)backClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
- (IBAction)shareClick:(UIBarButtonItem *)sender {
    
    SharePopup *popup=[[SharePopup  alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    popup.sharecontent=@"中投融分享测试";
    popup.shareImage=[UIImage imageNamed:@"banner_01@2x.jpg"]; //图片2选1
    popup.shareURL= @"https://www.baidu.com";
    popup.rootViewController = self;
    
    [popup showInView:self.tabBarController.view MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
        
    }];

}
- (IBAction)loginClick:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您未登录，是否需要登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 1000;
    [alert show];
}
- (IBAction)_investClick:(UIButton *)sender {
    //投资
    
    //先判断登录
    
    if (![UserTool userIsLogin]) {
        
        [self loginClick:nil];
        
    }else{
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"queryItemType":@"0",
                                                                                   @"userId":[UserTool getUserID],
                                                                                   @"itemId":_itemID}];
        
        if (_amountTxt.text.length) {
            [dic setObject:_amountTxt.text forKey:@"amount"];
        }
        
        NSMutableDictionary *params =[Tool getHttpParams:dic];
        
        [self showHUD];
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kInvestConfirmInvestCheck] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict) {
            
            if([dict[@"success"] intValue] == 1){
                [self hideHUD:@""];
                //校验成功
                //提交订单
                NSDictionary *dic = @{@"itemId":dict[@"map"][@"itemId"],
                                      @"userId":[UserTool getUserID],
                                      @"amount":dict[@"map"][@"amount"]};
                NSDictionary *params = @{@"channel":@"APP",
                                         @"params":dic,
                                         @"sign":[StringHelper dicSortAndMD5:dic],
                                         @"version":@"1.0"};
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/confirmInvest.htm?message=%@",htmlUrl,[StringHelper dictionaryToJson:params]];
                WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"web"];
                webVC.url = urlStr;
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
                
                
            }else{
                
                NSString *message=dict[@"errorMsg"];
                if(message==nil || message.length==0){
                    message=errorMessage;
                }
                [self hideHUD:message];
            }
            
        } failure:^(NSError *NSError) {

            NSString *message= [Tool getErrorMsssage:NSError];
            [self hideHUD:message];
        }];

    }
    
}
- (IBAction)topUpClick:(UIButton *)sender {
        [Tool pushToRecharge:self.navigationController];
}
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"web"];
    webVC.url = [NSString stringWithFormat:@"%@/investment_agreement.htm",htmlUrl];
    webVC.title = @"债权转让服务协议";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        switch (alertView.tag - 1000) {
            case 0:{
                //登录
                loginViewController *lcv=[[loginViewController alloc] init];
                UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:lcv];
                
                nc.navigationBar.barStyle = UIStatusBarStyleDefault;
                [nc.navigationBar setTintColor:[UIColor whiteColor]];
                
                [self presentViewController:nc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  InvestmentListViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "InvestmentListViewController.h"
#import "CircleProcessView.h"
#import "InvestmentDetailViewController.h"
#import "loginViewController.h"
#import "PayPasswordViewController.h"

@interface InvestmentListViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet SegmentSelectView *_segmentScrollView;
    
    NSInteger _pageIndex;//页码
    NSString *_queryLine;//期限
    NSMutableArray *_investList;//投资列表
    NSInteger _totalPage;
}
@end

@implementation InvestmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = @"下拉刷新...";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"正在刷新中...";
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
    //默认请求的是全部数据
    _queryLine = @"0";
    [self getNetworkList:_queryLine];
    
    //segement 选择修改样式
    [_segmentScrollView addSegmentButton:@[@"默认",@"6个月以下",@"6-12个月",@"12个月以上"] withNormalImage:@"touzi_segment" withSelectImage:@"touzi_segment_f"];
    [_segmentScrollView setDidSelect:^(NSInteger index) {
        
        //切换Segment的时候，indexpage重置
        _pageIndex = 1;
        _queryLine = @[@"0",@"1",@"2",@"3"][index];
        [self getNetworkList:_queryLine];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

/**
 *  网络请求数据
 *
 *  @param queryLine 投资期限
 */
- (void)getNetworkList:(NSString *)queryLine{
    
    [self showHUD];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"categoryType":_categoryType,
                                                                               @"page":[NSString stringWithFormat:@"%ld",(long)_pageIndex],
                                                                               @"queryLine":queryLine}];
    
    NSMutableDictionary *params =[Tool getHttpParams:dic];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kInvestItemList]  parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict) {
        
        if([dict[@"success"] intValue] == 1){
            [self hideHUD:@""];
            
            _totalPage = [dict[@"map"][@"pageInfo"][@"totalPage"] intValue];
            
            NSArray *arrs = dict[@"map"][@"pageInfo"][@"rows"];
            if (_pageIndex == 1) {
                _investList = [NSMutableArray arrayWithArray:arrs];
                
                self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
                self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
                self.tableView.footerRefreshingText = @"正在加载中...";
            }else
                [_investList addObjectsFromArray:arrs];
            
            if (_totalPage == _pageIndex || _totalPage == 0) {
                
                self.tableView.footerPullToRefreshText = @"";
                self.tableView.footerReleaseToRefreshText = @"";
                self.tableView.footerRefreshingText = @"没有更多数据了";
                
            }
            
            [self.tableView reloadData];
            
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
//上拉刷新
-(void)headerRereshing{
    _pageIndex = 1;
    self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
    [self getNetworkList:_queryLine];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    
}
//下拉加载更多
-(void)footerRereshing{
    if(_totalPage > _pageIndex){
        
        _pageIndex ++;
        [self getNetworkList:_queryLine];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
        });
        
    }else{
        [self.tableView footerEndRefreshing];
    }
    
    
}

#pragma mark -
#pragma mark - UserAction
- (IBAction)backClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)investClick:(UIButton *)sender {
    UIView *bottomView = (UIView *)sender.superview;
    UITextField * money = (UITextField *)[bottomView viewWithTag:4];

    UITableViewCell *cell = (UITableViewCell *)bottomView.superview.superview;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];

    if (![UserTool userIsLogin]) {
        //登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您未登录，是否需要登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 1000;
        [alert show];
    }else{
        //直接请求
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"queryItemType":@"0",
                                                                                   @"userId":[UserTool getUserID],
                                                                                   @"itemId":_investList[path.row][@"id"]}];
        
        if (money.text.length) {
            [dic setObject:money.text forKey:@"amount"];
        }else
            [dic setObject:[NSString stringWithFormat:@"%d",[_investList[path.row][@"minPrice"] intValue]/100] forKey:@"amount"];

        NSMutableDictionary *params =[Tool getHttpParams:dic];

        [self showHUD];
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kInvestConfirmInvestCheck]  parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict) {
            
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
                
                if ([dict[@"errorMsg"] isEqual:@"未设置支付密码"]) {
                    [self hideHUD:@""];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未设置支付密码,是否需要设置？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    alert.tag = 1001;
                    [alert show];
                }else{
                    [self hideHUD:dict[@"errorMsg"]];
                }
            }
            
        } failure:^(NSError *NSError) {

            NSString *message= [Tool getErrorMsssage:NSError];
            [self hideHUD:message];
        }];
        
    }
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
            case 1:{
                //设置支付密码
                PayPasswordViewController *payPasswordVC = [[PayPasswordViewController alloc] initWithNibName:@"PayPasswordViewController" bundle:nil];
                payPasswordVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:payPasswordVC animated:YES];
            }
                break;
            default:
                break;
        }
        //跳转支付密码设置页面
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _investList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIView *subView = cell.contentView;
    UILabel *title = (UILabel *)[subView viewWithTag:1];
    UILabel *content = (UILabel *)[subView viewWithTag:2];
    UILabel *repayment = (UILabel *)[subView viewWithTag:3];
    UITextField * money = (UITextField *)[subView viewWithTag:4];
    
    UIView *leftView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, money.frame.size.height)];
    
    money.leftView = leftView;
    money.leftViewMode = UITextFieldViewModeAlways;
    money.keyboardType=UIKeyboardTypeNumberPad;
    
    UIButton *investmentBtn = (UIButton *)[subView viewWithTag:5];
    CircleProcessView *circleView = (CircleProcessView *)[subView viewWithTag:6];
    
    UILabel *remainAmount = (UILabel *)[subView viewWithTag:7];
    //进度条
    
    CGRect rect = CGRectMake(112, 10, 80, 80);
    if (DEVICE_IS_IPHONE6) {
        rect = CGRectMake(140, 10, 80, 80);
    }else if (DEVICE_IS_IPHONE6Plus){
        rect = CGRectMake(160, 10, 80, 80);
    }
    if (!circleView) {
        circleView = [[CircleProcessView alloc] initWithFrame:rect];
        circleView.progressWidth = 5;
        circleView.tag = 6;
        circleView.progressColor = [UIColor colorWithRed:227/255.0f green:66/255.0f blue:44/255.0f alpha:0.8];
        circleView.trackColor = [UIColor colorWithRed:220/255.0f green:222/255.0f blue:224/255.0f alpha:1];
        [subView addSubview:circleView];
    }
    
    if (!remainAmount) {
        remainAmount = [[UILabel alloc] initWithFrame:CGRectMake(kAppWidth - 80, 20, 50, 60)];
        remainAmount.textColor = [UIColor blackColor];
        remainAmount.font = [UIFont systemFontOfSize:10];
        remainAmount.tag = 7;
        remainAmount.numberOfLines = 0;
        remainAmount.textAlignment = 1;
        remainAmount.adjustsFontSizeToFitWidth = YES;
        [subView addSubview:remainAmount];
    }

//    remainAmount.text = @"100万\n剩余金额";
    investmentBtn.layer.masksToBounds = YES;
    investmentBtn.layer.borderColor = [UIColor brownColor].CGColor;
    investmentBtn.layer.borderWidth = 0.5;
    
    NSDictionary *tempDict = (NSDictionary *)_investList[indexPath.row];
    NSLog(@"%@",tempDict);
    title.text = tempDict[@"title"];
    
    repayment.text = tempDict[@"repayMentChange"];
    
    //剩余金额
    NSMutableAttributedString *remainStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n剩余金额",tempDict[@"currentPriceTotalStr"]]];
    [remainStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[remainStr.mutableString rangeOfString:@"剩余金额"]];
    
    
    //标的状态
    NSNumber *status = tempDict[@"status"];
    if ([status integerValue] == 1007) {
        //满标
        [circleView setProgress:1];
        remainAmount.text = @"满";

    }else{
        [circleView setProgress:[tempDict[@"currentPreStr"] floatValue] / 100];
        remainAmount.attributedText = remainStr;
    }

    NSNumber *yearRate = tempDict[@"yearRate"];
    NSString *yearStr = [NSString stringWithFormat:@"%@",yearRate];
    //看是否包含.
    NSArray *range = [yearStr componentsSeparatedByString:@"."];
    if (range.count == 1) {
        yearStr = [yearStr stringByAppendingString:@".0"];
    }
    
    NSNumber *repayPeriod = tempDict[@"repayPeriod"];
    NSNumber *minPrice = tempDict[@"minPrice"];

    NSString *period = [NSString stringWithFormat:@"%@   %@%@(3个月可转)   %d元起投",tempDict[@"yearRateStr"],repayPeriod,tempDict[@"repayUnitChange"],[tempDict[@"minPrice"] intValue] / 100];
//
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:period];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[period rangeOfString:[NSString stringWithFormat:@"%@",yearStr]]];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:[period rangeOfString:[NSString stringWithFormat:@"%@",yearStr]]];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[period rangeOfString:[NSString stringWithFormat:@"%@",repayPeriod]]];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:[period rangeOfString:[NSString stringWithFormat:@"%@",repayPeriod]]];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[period rangeOfString:[NSString stringWithFormat:@"%@",minPrice]]];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:[period rangeOfString:[NSString stringWithFormat:@"%@",minPrice]]];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[period rangeOfString:@"(3个月可转)"]];
    content.attributedText = attribute;
    content.adjustsFontSizeToFitWidth = YES;
    
    subView.layer.masksToBounds = YES;
    subView.layer.borderWidth = 0.5;
    subView.layer.borderColor =self.tableView.backgroundColor.CGColor;
    cell.contentView.backgroundColor=self.tableView.backgroundColor;
    //[UIColor grayColor].CGColor;
    subView.backgroundColor=[UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InvestmentDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InvestDetail"];
    detailVC.itemID = _investList[indexPath.row][@"id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark -UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    [textField resignFirstResponder];
    return YES;
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

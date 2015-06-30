//
//  InvestmentHomeViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "InvestmentHomeViewController.h"
#import "InvestmentListViewController.h"
#import "RateTableView.h"
#import "loginViewController.h"
#import "SettingViewController.h"
#import "SelectionPopup.h"

@interface InvestmentHomeViewController ()<UIAlertViewDelegate>
{
    NSDictionary *_investDict;
    NSMutableArray *_flrsList;//富丽人生利率
    NSMutableArray *_jprsList;//精品人生利率
    NSMutableArray *_wjrsList;//稳健人生利率
    
    SelectionPopup *popup;
    RateTableView *_rateView;

    BOOL isRateShow;
}
@end

@implementation InvestmentHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _flrsList = [NSMutableArray array];
    _wjrsList = [NSMutableArray array];
    _jprsList = [NSMutableArray array];

    [self getNetworkHome];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    //    [self.tv setTableHeaderView:self.selectView];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = @"下拉刷新...";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"正在刷新中...";
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
}

-(void)headerRereshing{
    self.hasmoreSC=YES;
    self.page=1;
    self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
    [self getreflectRecords];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    
}

//下拉加载更多
-(void)footerRereshing{
    if(self.hasmoreSC==YES){
        self.page=self.page+1;
        [self getreflectRecords];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
        });
        
    }else{
        [self.tableView footerEndRefreshing];
    }
}

-(void)getreflectRecords{
    
    if(self.isRefush==YES){
        return;
    }
    
    //刷新时请求数据
    [self getNetworkHome];
}
//获取网络数据
- (void)getNetworkHome{
    [self showHUD];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kInvestIndex]  parameters:@{} finishBlock:^(NSDictionary *dict) {
        
        if([dict[@"success"] intValue] == 1){
            [self hideHUD:@""];
            _investDict = dict[@"map"];
            [self getCategoryRateList:dict[@"map"][@"itemYearRateList"]];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    //投资列表
}

- (void)recoverTabbar
{
    self.tabBarController.view.userInteractionEnabled = YES;
}
/**
 *  获取每个类别的利率数组
 *
 *  @param itemYearRateList 打乱的利率数组
 */
- (void)getCategoryRateList:(NSArray *)itemYearRateList{
    
    [_wjrsList removeAllObjects];
    [_jprsList removeAllObjects];
    [_flrsList removeAllObjects];
    
    for (NSDictionary *dic in itemYearRateList) {
        if ([dic[@"categoryType"] isEqual:@"wjrs"]) {
            [_wjrsList addObject:dic];
        }else if ([dic[@"categoryType"] isEqual:@"jprs"]){
            [_jprsList addObject:dic];
        }else
            [_flrsList addObject:dic];
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
//    UIView *contentView = (UIView *)cell.subviews[0];
    UIImageView *topImageView = (UIImageView *)[cell.contentView viewWithTag:1];
    UIView *bottomView = (UIView *)[cell.contentView viewWithTag:2];
    UILabel *countLal = (UILabel *)[cell.contentView viewWithTag:3];
    //UIImageView *txtImageView = (UIImageView *)[bottomView viewWithTag:10];
    UILabel *rateLbl = (UILabel *)[bottomView viewWithTag:15];
    UITextField *amount = (UITextField *)[bottomView viewWithTag:20];
    UIButton *arrowBtn = (UIButton *)[bottomView viewWithTag:100];
    
    amount.keyboardType=UIKeyboardTypeNumberPad;
    
    bottomView.userInteractionEnabled = YES;
    
    rateLbl.adjustsFontSizeToFitWidth = YES;
    
    if (_jprsList.count || _wjrsList.count || _flrsList.count) {
        
        amount.placeholder = @[@"1000元",@"10000元",@"50000元"][indexPath.row];
        
        NSArray *arrs = @[_jprsList,_wjrsList,_flrsList][indexPath.row];
        
        if (arrs.count) {
            //第一个是升序   第二个第三个是降序
            NSDictionary *dic = (NSDictionary *)arrs[0];
            
            if (indexPath.row != 0) {
                dic = (NSDictionary *)arrs[arrs.count - 1];
            }
            
            NSString *content = [NSString stringWithFormat:@"%@月 利率%@",dic[@"repayPeriod"],dic[@"yearRateStr"]];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[content rangeOfString:[NSString stringWithFormat:@"利率%@",dic[@"yearRateStr"]]]];
            
            rateLbl.attributedText = str;
        }
        
    }
    
    if (DEVICE_IS_IPHONE6) {
        countLal.font = [UIFont systemFontOfSize:14];
    }else if (DEVICE_IS_IPHONE6Plus)
        countLal.font = [UIFont systemFontOfSize:15];
    
    topImageView.image = [UIImage imageNamed:@[@"index_bg11",@"index_bg12",@"index_bg13"][indexPath.row]];
    bottomView.backgroundColor = [UIColor colorWithRed:252/255.0 green:236/255.0 blue:208/255.0 alpha:1];
    if (_investDict) {
        countLal.text = [NSString stringWithFormat:@"%@个", @[_investDict[@"jprs"],_investDict[@"wjrs"],_investDict[@"flrs"]][indexPath.row]];
    }
    
    [arrowBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        if(isRateShow == NO)
        {
            isRateShow = YES;
            
            NSArray *arrs = @[_jprsList,_wjrsList,_flrsList][indexPath.row];
            
            float rowHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];

            _rateView = nil;
            
            if (_rateView == nil) {
                _rateView = [[RateTableView alloc] init];
                
            }
            if (indexPath.row != 0) {
                _rateView.isDescendingOrder = YES;
            }
            
            float kHeight = 40 * (arrs.count >= 4 ? 4 : arrs.count);
            
            [_rateView initWithFrame:CGRectMake(rateLbl.frame.origin.x,
                                                50+rowHeight * indexPath.row + topImageView.frame.origin.y + topImageView.frame.size.height+rateLbl.frame.size.height,
                                                (rateLbl.frame.size.width+arrowBtn.frame.size.width),
                                                kHeight) withArrs:arrs];
            
            __weak InvestmentHomeViewController *blockself = self;
            _rateView.didSelect=^(NSString *string){

                [blockself.tableView setTableFooterView:nil];
                [blockself setisRateShow:NO];
                
                if(string !=nil){
                    NSArray *arr=[string componentsSeparatedByString:@" "];
                    if(arr.count==2){
                        
                        NSString *content = [NSString stringWithFormat:@"%@ %@",arr[0],arr[1]];
                        NSLog(@"arr[1]  %@",arr[1]);
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[content rangeOfString:[NSString stringWithFormat:@"%@",arr[1]]]];
                        
                        rateLbl.attributedText = str;
                        
                        
                    }
                    
                }
                
                //rateLbl.text=string;
                
            };
            
            [ self.tableView addSubview:_rateView];
            
            UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 120)];
            
            [self.tableView setTableFooterView:footView];
            
            
        }
        else
        {
            [_rateView removeFromSuperview];
            _rateView = nil;
            [self.tableView setTableFooterView:nil];
            isRateShow = NO;
        }

    }];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (DEVICE_IS_IPHONE4) {
            return kAppWidth * 0.275 + kAppWidth * 0.1125 + 16;
        
    }else
        return (kAppHeight - 46 - 44 - 49)/3;
}

#pragma mark -UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UserAction

-(void)setisRateShow :(BOOL) b{
    isRateShow =b;
}

//- (IBAction)showRateClick:(UIButton *)sender {     //先隐藏按钮 和事件
//    if(isRateShow == NO)
//    {
//        isRateShow = YES;
//        UIView *senderV = (UIView *)sender.superview;
//        UIView *superV = (UIView *)senderV.superview;
//        UITableViewCells
//        UITableViewCell *cell = (UITableViewCell *) sender.superview.superview.superview;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        
////        UIView *contentView = (UIView *)cell.subviews[0];
//        UIImageView *topImageView = (UIImageView *)[cell.contentView viewWithTag:1];
//        UIView *bottomView = (UIView *)[cell.contentView viewWithTag:2];
//      
//        UILabel *rateLbl = (UILabel *)[bottomView viewWithTag:15];
//
//        NSArray *arrs = @[_jprsList,_wjrsList,_flrsList][indexPath.row];
//
//        float rowHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
//        
//        if (_rateView == nil) {
//            _rateView = [[RateTableView alloc] init];
//            
//        }
//        if (indexPath.row != 0) {
//            _rateView.isDescendingOrder = YES;
//        }
//        
//        float kHeight = 40 * (arrs.count >= 4 ? 4 : arrs.count);
//        
//        [_rateView initWithFrame:CGRectMake(rateLbl.frame.origin.x,
//                                            50+rowHeight * indexPath.row + topImageView.frame.origin.y + topImageView.frame.size.height+rateLbl.frame.size.height,
//                                            (rateLbl.frame.size.width+sender.frame.size.width),
//                                            kHeight) withArrs:arrs];
//        
//        NSLog(@"%@",NSStringFromCGRect(_rateView.frame));
//        __weak InvestmentHomeViewController *blockself = self;
//        _rateView.didSelect=^(NSString *string){
//            NSLog(@"%@",string);
//            [blockself.tableView setTableFooterView:nil];
//            [blockself setisRateShow:NO];
//
//            if(string !=nil){
//                NSArray *arr=[string componentsSeparatedByString:@" "];
//                if(arr.count==2){
//                    
//                    NSString *content = [NSString stringWithFormat:@"%@ %@",arr[0],arr[1]];
//                    NSLog(@"arr[1]  %@",arr[1]);
//                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
//                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[content rangeOfString:[NSString stringWithFormat:@"%@",arr[1]]]];
//                    
//                    rateLbl.attributedText = str;
//                    
//                    
//                }
//                
//            }
//            
//            //rateLbl.text=string;
//            
//        };
//         
//        [ self.tableView addSubview:_rateView];
//        
//        UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 120)];
//        
//        [self.tableView setTableFooterView:footView];
//
//
//    }
//    else
//    {
//        [_rateView removeFromSuperview];
//        _rateView = nil;
//        [self.tableView setTableFooterView:nil];
//        isRateShow = NO;
//    }
//    
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [_rateView removeFromSuperview];
    _rateView = nil;
    [self.tableView setTableFooterView:nil];
    isRateShow = NO;
}

- (IBAction)InvestClick:(UIButton *)sender {
    
    UIView *bottomView = (UIView *)sender.superview;
    UITableViewCell *cell = (UITableViewCell *)bottomView.superview.superview;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld",(long)path.row);
    UILabel *rateLbl = (UILabel *)[bottomView viewWithTag:15];
    
    
    NSArray *arrs = @[_jprsList,_wjrsList,_flrsList][path.row];
    if (!arrs.count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该产品不能投资" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        UITextField *amount = (UITextField *)[bottomView viewWithTag:20];
        
        if (![UserTool userIsLogin]) {
            //登录
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您未登录，是否需要登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 1000;
            [alert show];
            
        }else{
            //直接请求
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"queryItemType":@"1",
                                                                                       @"userId":[UserTool getUserID],
                                                                                       @"categoryId":arrs[0][@"categoryId"],
                                                                                       @"repayPeriod":[rateLbl.text componentsSeparatedByString:@"月"][0]}];
            if (amount.text.length) {
                [dic setObject:amount.text forKey:@"amount"];
            }else
                [dic setObject:@[@"1000",@"10000",@"50000"][path.row] forKey:@"amount"];
            
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
                SettingViewController *settingViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
                [self.navigationController pushViewController:settingViewVC animated:YES];
            }
                break;
            default:
                break;
        }
        //跳转支付密码设置页面
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

- (IBAction)tapClick:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld",(long)indexPath.row);
    [self.view endEditing:YES];

//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld",(long)indexPath.row);
    InvestmentListViewController *investList = [self.storyboard instantiateViewControllerWithIdentifier:@"InvestList"];
    investList.categoryType = @[@"jprs",@"wjrs",@"flrs"][indexPath.row];
    NSLog(@"%@",@[@"精品人生",@"稳健人生",@"富丽人生"][indexPath.row]);
    investList.title = @[@"精品人生",@"稳健人生",@"富丽人生"][indexPath.row];
    investList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:investList animated:YES];
}




@end

//
//  MyRedbagTableViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/21.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "MyRedbagTableViewController.h"

@interface MyRedbagTableViewController ()
{
    
    __weak IBOutlet SegmentSelectView *_segementView;
    __weak IBOutlet UIView *_topView;
    
    NSInteger _indexPage;
    NSInteger _cashTotalPage;
    NSInteger _investTotalPage;

    NSMutableArray *_cashReds;
    NSMutableArray *_investReds;
    NSDictionary *cashHeaderDic;
    NSDictionary *investHeaderDic;

//    NSInteger redBag;
//    NSMutableArray *_arrs;//所有列表数据
    
    BOOL _isFirst;
    
    SelectionPopup *popup;
    MBProgressHUD *HUD;
    
    UIImageView *_noDataImageView;
}
@end

@implementation MyRedbagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _indexPage = 1;
    _cashReds = [NSMutableArray array];
    _investReds = [NSMutableArray array];
    
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
    
    //当没有数据的时候显示图片
    
    UIImage *haoImage = [UIImage imageNamed:@"hongbao_bg01"];
    float kOffY = DEVICE_IS_IPHONE4 ? 40 : 0;
    float kWidth = haoImage.size.width/3;
    float kHeight = haoImage.size.height/3;
    
    _noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kAppWidth - kWidth)/2, (kAppHeight - kHeight)/2 + kOffY, kWidth, kHeight)];
    _noDataImageView.image = [UIImage imageNamed:@"hongbao_bg01"];
    _noDataImageView.hidden  = YES;
    [self.view addSubview:_noDataImageView];
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    backItem.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [_segementView addSegmentButton:@[@"投资红包",@"现金红包"] withNormalImage:@"touzi_segment" withSelectImage:@"touzi_segment_f"];
    [_segementView setDidSelect:^(NSInteger index) {
        
        _noDataImageView.image = [UIImage imageNamed:@[@"hongbao_bg01",@"hongbao_bg02"][index]];
        
        if (index == 0) {
            
            _isFirst = NO;
        
        }else
        {
            _isFirst = YES;

        }

        [self getNetworkData];

    }];
    
    _topView.backgroundColor = [UIColor colorWithRed:166/255.0 green:133/255.0 blue:77/255.0 alpha:1];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"my_redbag_right_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(showPopo)];
    settingItem.tintColor = ButtonBG;
    self.navigationItem.rightBarButtonItem = settingItem;
    
    _Selection = @"unused";
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];

}

-(void)showPopo{
    

    if(popup==nil){
        popup=[[SelectionPopup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        popup.showDate =@[@"可用",@"冻结",@"已使用",@"已过期"];
        NSArray *typeArray= [[NSArray alloc] initWithObjects:@"unused",@"freeze",@"used",@"failure", nil];
        __weak MyRedbagTableViewController *blockself = self;
        popup.finishBlock=^(NSInteger i){
            blockself.Selection =[typeArray objectAtIndex:i];
            _indexPage = 1;
            [blockself getNetworkData];
            
        };
    }
    
    [popup showInView:APPDELEGATE.window MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
        
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self getNetworkData];
    
}
//上拉刷新
-(void)headerRereshing{
    _indexPage=1;
    self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
    [self getNetworkData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    
}
//下拉加载更多
-(void)footerRereshing{
    if((!_isFirst && _investTotalPage > _indexPage ) || (_isFirst && _cashTotalPage > _indexPage )){
        
        _indexPage ++;
        [self getNetworkData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
        });
        
    }else{
        [self.tableView footerEndRefreshing];
    }
    
    
}
/**
 *  获取网络数据
 */
- (void)getNetworkData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSString stringWithFormat:@"%zi",_indexPage],
                                                                               @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:userId],
                                                                               @"status":_Selection,
                                                                               @"redType":_isFirst ? @"0":@"1"}];
    
    NSMutableDictionary *params =[Tool getHttpParams:dic];

    [HUD show:YES];
    self.view.userInteractionEnabled = NO;
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kUserRedEnvelope]  parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict) {
        
        [HUD hide:YES];
        self.view.userInteractionEnabled = YES;
        
        if([dict[@"success"] intValue] == 1){
            //成功
            if (_isFirst) {
                _cashTotalPage = [dict[@"map"][@"pageInfo"][@"totalPage"] intValue];
                cashHeaderDic = dict[@"map"];
            }else{
                
                _investTotalPage = [dict[@"map"][@"pageInfo"][@"totalPage"] intValue];
                investHeaderDic = dict[@"map"];
            }

            if (_indexPage == 1) {
                
                if (_isFirst) {
                    _cashReds = [NSMutableArray arrayWithArray:cashHeaderDic[@"pageInfo"][@"rows"]];
                }else
                    _investReds = [NSMutableArray arrayWithArray:investHeaderDic[@"pageInfo"][@"rows"]];

                
                self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
                self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
                self.tableView.footerRefreshingText = @"正在加载中...";
            }else{
                
                if (_isFirst) {
                    [_cashReds addObjectsFromArray:cashHeaderDic[@"pageInfo"][@"rows"]];
                }else
                    [_investReds addObjectsFromArray:cashHeaderDic[@"pageInfo"][@"rows"]];
            }
            
            if ((!_isFirst && (_investTotalPage == _indexPage || _investTotalPage == 0)) || (_isFirst && (_cashTotalPage == _indexPage || _cashTotalPage == 0))) {
                
                self.tableView.footerPullToRefreshText = @"";
                self.tableView.footerReleaseToRefreshText = @"";
                self.tableView.footerRefreshingText = @"没有更多数据了";
                
            }
            
            //判断表头显示那个页面
            if (_isFirst) {
                if(![cashHeaderDic[@"xjAmount"] isEqualToString:@""])
                {
                    self.bagTotal.text = [NSString stringWithFormat:@"%@",cashHeaderDic[@"xjAmount"]];
                }
                else
                {
                    self.bagTotal.text = @"0.00";
                }
                self.nameLabel.text = [NSString stringWithFormat:@"截至当前可用现金红包：%d个", [cashHeaderDic[@"xjCount"] intValue]];
                self.numberLabel.text = @"";
                
                if (_cashReds.count) {
                    self.tableView.scrollEnabled = YES;
                    _noDataImageView.hidden = YES;
                    
                }else{
                    _noDataImageView.hidden = NO;
                    self.tableView.scrollEnabled = NO;
                }
                
                [self.tableView reloadData];
                
            }else{
                if(![investHeaderDic[@"tzAmount"] isEqualToString:@""])
                {
                    self.bagTotal.text = [NSString stringWithFormat:@"%@",investHeaderDic[@"tzAmount"]];
                }
                else
                {
                    self.bagTotal.text = @"0.00";
                }
                self.nameLabel.text = @"投资红包面额：";
                //                self.numberLabel.text = [NSString stringWithFormat:@"%i",[headerDic[@"tzCount"] intValue]];
                NSString *str = @"";
                for (int i = 0; i < [investHeaderDic[@"staticList"] count]; i ++) {
                    
                    NSDictionary *tempDict = (NSDictionary *)investHeaderDic[@"staticList"][i];
                    if([tempDict[@"redType"] intValue] == 1)
                    {
                        str = [str stringByAppendingFormat:@"%@%d元%@个%@",@"",[tempDict[@"amount"] intValue]/100,tempDict[@"count"],@","];
                    }
                }
                
                self.numberLabel.text = str;
                
                if (_investReds.count) {
                    self.tableView.scrollEnabled = YES;
                    _noDataImageView.hidden = YES;
                    
                }else{
                    _noDataImageView.hidden = NO;
                    self.tableView.scrollEnabled = NO;
                }
                
                [self.tableView reloadData];
                
            }
            
        }else{
            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    } failure:^(NSError *NSError) {
        
        [HUD hide:YES];
        self.view.userInteractionEnabled = YES;
        
        NSString *message= [Tool getErrorMsssage:NSError];
        NSLog(@"%@",message);
    }];
  
}

#pragma mark - UserAction
- (void)backClick:(UIBarButtonItem *)sender{
    if (_isFromHome) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self.navigationController popViewControllerAnimated:YES];
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
    if (_isFirst) {
        return _cashReds.count;
    }else
        return _investReds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *redArrs = _isFirst ? _cashReds:_investReds;
    
    if (redArrs.count) {
        
        NSDictionary *dic = (NSDictionary *)redArrs[0];
        NSDictionary *tempDict = (NSDictionary *)redArrs[indexPath.row];
        
        if ([dic[@"status"] isEqual:@"unused"] || [dic[@"status"] isEqual:@"freeze"]) {
//
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NO" forIndexPath:indexPath];

            // Configure the cell...
           // UIView *subView = [(UIView *)cell.subviews[0] subviews][0];
            UIView *subView =[cell.contentView viewWithTag:100];
            UILabel *money = (UILabel *)[subView viewWithTag:1];
            UILabel *status = (UILabel *)[subView viewWithTag:2];
            UILabel *timeStatus = (UILabel *)[subView viewWithTag:3];
            UILabel *code = (UILabel *)[subView viewWithTag:4];
            UILabel *time = (UILabel *)[subView viewWithTag:5];
            UILabel *form = (UILabel *)[subView viewWithTag:6];
            UIImageView *imageCell = (UIImageView *)[subView viewWithTag:7];
            
            money.text = [NSString stringWithFormat:@"￥%@",tempDict[@"amountStr"]];
             status.text = tempDict[@"statusStr"];
            if ([tempDict[@"expDescStr"] length]) {
                imageCell.hidden = NO;
                timeStatus.text = tempDict[@"expDescStr"];
            }else
                imageCell.hidden = YES;
            
            code.text = tempDict[@"redEnvelopeId"];
            time.text = tempDict[@"invalidDate"];
            form.text = tempDict[@"provideFlagStr"];
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YES" forIndexPath:indexPath];
            
            // Configure the cell...
           // UIView *subView = [(UIView *)cell.subviews[0] subviews][0];
            UIView *subView =[cell.contentView viewWithTag:100];
            UILabel *money = (UILabel *)[subView viewWithTag:1];
            UILabel *status = (UILabel *)[subView viewWithTag:2];
            UILabel *orderID = (UILabel *)[subView viewWithTag:6];
            UILabel *code = (UILabel *)[subView viewWithTag:3];
            UILabel *time = (UILabel *)[subView viewWithTag:4];
            UILabel *form = (UILabel *)[subView viewWithTag:5];
            
            money.text = [NSString stringWithFormat:@"￥%@",tempDict[@"amountStr"]];
            status.text = tempDict[@"statusStr"];
            orderID.text = tempDict[@"orderId"];
            code.text = tempDict[@"redEnvelopeId"];
            time.text = tempDict[@"invalidDate"];
            form.text = tempDict[@"provideFlagStr"];
            
            return cell;
        }
    }
    return nil;
 
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

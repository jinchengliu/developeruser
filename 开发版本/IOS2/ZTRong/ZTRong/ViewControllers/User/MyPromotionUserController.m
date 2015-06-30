//
//  MyPromotionUserController.m
//  ZTRong
//
//  Created by 李婷 on 15/6/9.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "MyPromotionUserController.h"
#import "SelectionPopup.h"
#import "RewardCell.h"
#import "MJRefresh.h"

static NSString *identifier = @"RewardCell";

@interface MyPromotionUserController ()
{
    __weak IBOutlet UIView *_headerView;
    __weak IBOutlet UILabel *_firstCount;
    __weak IBOutlet UILabel *_secondCount;

    NSMutableArray *_rows;
    BOOL _hasMore;
}
@property (nonatomic, strong) NSString *selection;
@property (nonatomic, strong) SelectionPopup *popup;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) MBProgressHUD *hub;
@end

@implementation MyPromotionUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _headerView.backgroundColor = ButtonBG;
    
    _selection = @"不限";
    _currentPage = 1;
    
    _hub = [[MBProgressHUD alloc] init];
    [self.view addSubview:_hub];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = @"下拉刷新...";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"正在刷新中...";
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
    //返回
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem;
    
    //条件选择
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"my_redbag_right_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(showPopo)];
    settingItem.tintColor = ButtonBG;
    self.navigationItem.rightBarButtonItem = settingItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self getNetworkData];
}
//网络请求数据
- (void)getNetworkData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[UserTool getUserID]}];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"page"];
    
    if (![_selection isEqual:@"不限"]) {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
        
        [dic setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"endDate"];
        
        if ([_selection isEqual:@"近1个月"]) {
            
            NSDate *start = [NSDate dateWithDaysBeforeNow:30];
            [dic setObject:[dateFormatter stringFromDate:start] forKey:@"startDate"];
            
        }else if ([_selection isEqual:@"近3个月"]){
            
            NSDate *start = [NSDate dateWithDaysBeforeNow:90];
            [dic setObject:[dateFormatter stringFromDate:start] forKey:@"startDate"];
            
        }else if ([_selection isEqual:@"近1周"]){
            
            NSDate *start = [NSDate dateWithDaysBeforeNow:7];
            [dic setObject:[dateFormatter stringFromDate:start] forKey:@"startDate"];
        }
        
    }
    
    self.view.userInteractionEnabled = NO;
    [_hub show:YES];
    
    NSMutableDictionary *params =[Tool getHttpParams:dic];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kUserPromotionUser] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict) {
        
        self.view.userInteractionEnabled = YES;
        [_hub hide:YES];
        
        if([dict[@"success"] intValue] == 1){
            
            _firstCount.text = [NSString stringWithFormat:@"%@人",dict[@"map"][@"firstCount"]];
            _secondCount.text = [NSString stringWithFormat:@"%@人",dict[@"map"][@"secondCount"]];

            NSArray *row = (NSArray *)dict[@"map"][@"pageInfo"][@"rows"];
            
            if (row.count < 10) {
                _hasMore = NO;
            }else
                _hasMore = YES;
            
            
            if (_currentPage == 1) {
                _rows = [NSMutableArray arrayWithArray:row];
                
                self.tableView.footerPullToRefreshText = @"上拉显示更多数据";
                self.tableView.footerReleaseToRefreshText = @"松开显示更多数据";
                self.tableView.footerRefreshingText = @"正在加载中...";
                
            }else
                [_rows addObjectsFromArray:row];
            
            if (!_hasMore) {
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(NSError *NSError) {
        
        self.view.userInteractionEnabled = YES;
        [_hub hide:YES];
        
        NSString *message= [Tool getErrorMsssage:NSError];
        NSLog(@"%@",message);
    }];
}
//上拉刷新
-(void)headerRereshing{
    _currentPage = 1;
    
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
    if(_hasMore){
        
        _currentPage ++;
        
        [self getNetworkData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
        });
        
    }else{
        [self.tableView footerEndRefreshing];
    }
    
}
#pragma mark - UserAction
//返回
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//选择气泡
-(void)showPopo{
    
    
    if(_popup==nil){
        _popup=[[SelectionPopup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        _popup.showDate =@[@"不限",@"近1周",@"近1个月",@"近3个月"];
        
        __weak MyPromotionUserController *blockself = self;
        _popup.finishBlock=^(NSInteger i){
            blockself.selection =[blockself.popup.showDate objectAtIndex:i];
            blockself.currentPage = 1;
            [blockself getNetworkData];
            
        };
    }
    
    [_popup showInView:APPDELEGATE.window MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RewardCell *cell = (RewardCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *tempDict = (NSDictionary *)_rows[indexPath.row];
    
    NSString *userName = [NSString stringWithFormat:@"%@",tempDict[@"regUserName"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:userName];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:RGBColor(94, 71, 34)} range:[userName rangeOfString:tempDict[@"regUserName"]]];
    
    cell.name.attributedText = attributedString;
    cell.investID.text = tempDict[@"createDateStr"];
    cell.orderMoney.text = [NSString stringWithFormat:@"%@",tempDict[@"papersAuditStatusStr"]];
    cell.rate.text = tempDict[@"maxOrderDateStr"];
    cell.reward.text = [NSString stringWithFormat:@"￥%@",tempDict[@"firstDistributionAmountStr"]];
    cell.dateTime.text = [NSString stringWithFormat:@"%@",tempDict[@"firstCount"]];

    if ([tempDict[@"isInvestStr"] isEqual:@"是"]) {
        cell.isInvest = YES;
    }else
        cell.isInvest = NO;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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

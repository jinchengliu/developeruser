//
//  ActivityViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "ActivityViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface ActivityViewController ()
{
    NSMutableArray *titleArray;
    NSMutableArray *picUrlArray;
    NSMutableArray *dateArray;
    NSMutableArray *UrlArray;
    NSMutableArray *offtitleArray;
    NSMutableArray *offpicUrlArray;
    NSMutableArray *offdateArray;
    NSMutableArray *offUrlArray;
    MBProgressHUD *HUD;
    
    NSInteger segIndex;
}

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"活动专区"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    picUrlArray = [NSMutableArray array];
    titleArray = [NSMutableArray array];
    UrlArray = [NSMutableArray array];
    dateArray = [NSMutableArray array];
    offtitleArray = [NSMutableArray array];
    offpicUrlArray = [NSMutableArray array];
    offUrlArray = [NSMutableArray array];
    offdateArray = [NSMutableArray array];
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
//    
    self.tv.dataSource=self;
    self.tv.delegate=self;
//    [self.tv setTableHeaderView:self.selectView];
    [self.tv addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tv.headerPullToRefreshText = @"下拉刷新...";
    self.tv.headerReleaseToRefreshText = @"松开刷新";
    self.tv.headerRefreshingText = @"正在刷新中...";
    [self.tv addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tv.footerPullToRefreshText = @"上拉显示更多数据";
    self.tv.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tv.footerRefreshingText = @"正在加载中...";
    [self.view addSubview:self.tv];
    
    self.tv.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:245.0f/255.0f blue:246.0f/255.0f alpha:1];
    // Do any additional setup after loading the view.
    
    [self.segScrollView addSegmentButton:@[@"线上活动",@"线下活动"] withNormalImage:@"activities_icon02.png" withSelectImage:@"activities_icon01.png"];
    [self.segScrollView setDidSelect:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
        segIndex = index;
        [self.tv reloadData];
    }];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/activity.htm"] parameters:nil  finishBlock:^(NSDictionary *dict) {
        NSLog(@"dict   %@" ,dict.description);
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            if(dict[@"map"][@"activity_online_app"])
            {
                NSArray *array = dict[@"map"][@"activity_online_app"];
                for(NSDictionary *dic in array)
                {
                    if(dic[@"picUrl"] != nil)
                    {
                        [picUrlArray addObject:dic[@"picUrl"]];
                    }
                    else
                    {
                        [picUrlArray addObject:@""];
                    }
                    if(dic[@"title"] != nil)
                    {
                        [titleArray addObject:dic[@"title"]];
                    }
                    else
                    {
                        [titleArray addObject:@""];
                    }
                    if(dic[@"createDateStr"] != nil)
                    {
                        [dateArray addObject:dic[@"createDateStr"]];
                    }
                    else
                    {
                        [dateArray addObject:@""];
                    }
                    if(dic[@"hrefUrl"] != nil)
                    {
                        [UrlArray addObject:dic[@"hrefUrl"]];
                    }
                    else
                    {
                        [UrlArray addObject:@""];
                    }
                }
                [self.tv reloadData];
            }
            if(dict[@"map"][@"activity_offline_app"])
            {
                NSArray *array = dict[@"map"][@"activity_offline_app"];
                for(NSDictionary *dic in array)
                {
                    if(dic[@"picUrl"] != nil)
                    {
                        [offpicUrlArray addObject:dic[@"picUrl"]];
                    }
                    else
                    {
                        [offpicUrlArray addObject:@""];
                    }
                    if(dic[@"title"] != nil)
                    {
                        [offtitleArray addObject:dic[@"title"]];
                    }
                    else
                    {
                        [offtitleArray addObject:@""];
                    }
                    if(dic[@"createDateStr"] != nil)
                    {
                        [offdateArray addObject:dic[@"createDateStr"]];
                    }
                    else
                    {
                        [offdateArray addObject:@""];
                    }
                    if(dic[@"hrefUrl"] != nil)
                    {
                        [offUrlArray addObject:dic[@"hrefUrl"]];
                    }
                    else
                    {
                        [offUrlArray addObject:@""];
                    }
                }
                [HUD hide:YES];
                [self.tv reloadData];
            }
        }
        
        
    } failure:^(NSError *NSError) {
        
        
        
        [HUD hide:YES];
        
        NSString *message= [Tool getErrorMsssage:NSError];
        
        NSLog(@"%@",message);
        
    }];

    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)headerRereshing{
    self.hasmoreSC=YES;
    self.page=1;
    self.tv.footerPullToRefreshText = @"上拉显示更多数据";
    self.tv.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tv.footerRefreshingText = @"正在加载中...";
    
    [self getreflectRecords];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tv headerEndRefreshing];
    });
    
}

//下拉加载更多
-(void)footerRereshing{
    if(self.hasmoreSC==YES){
        self.page=self.page+1;
        [self getreflectRecords];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tv footerEndRefreshing];
        });
        
    }else{
        [self.tv footerEndRefreshing];
    }
}

-(void)getreflectRecords{
    
    if(self.isRefush==YES){
        return;
    }
    [picUrlArray removeAllObjects];
    [titleArray removeAllObjects];
    [UrlArray removeAllObjects];
    [dateArray removeAllObjects];
    [offtitleArray removeAllObjects];
    [offpicUrlArray removeAllObjects];
    [offUrlArray removeAllObjects];
    [offdateArray removeAllObjects];

    
    //刷新时请求数据
    [HUD show:YES];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/activity.htm"] parameters:nil  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            if(dict[@"map"][@"activity_online_app"])
            {
                NSArray *array = dict[@"map"][@"activity_online_app"];
                for(NSDictionary *dic in array)
                {
                    if(dic[@"picUrl"] != nil)
                    {
                        [picUrlArray addObject:dic[@"picUrl"]];
                    }
                    else
                    {
                        [picUrlArray addObject:@""];
                    }
                    if(dic[@"title"] != nil)
                    {
                        [titleArray addObject:dic[@"title"]];
                    }
                    else
                    {
                        [titleArray addObject:@""];
                    }
                    if(dic[@"createDateStr"] != nil)
                    {
                        [dateArray addObject:dic[@"createDateStr"]];
                    }
                    else
                    {
                        [dateArray addObject:@""];
                    }
                    if(dic[@"hrefUrl"] != nil)
                    {
                        [UrlArray addObject:dic[@"hrefUrl"]];
                    }
                    else
                    {
                        [UrlArray addObject:@""];
                    }
                }
                [self.tv reloadData];
            }
            if(dict[@"map"][@"activity_offline_app"])
            {
                NSArray *array = dict[@"map"][@"activity_offline_app"];
                for(NSDictionary *dic in array)
                {
                    if(dic[@"picUrl"] != nil)
                    {
                        [offpicUrlArray addObject:dic[@"picUrl"]];
                    }
                    else
                    {
                        [offpicUrlArray addObject:@""];
                    }
                    if(dic[@"title"] != nil)
                    {
                        [offtitleArray addObject:dic[@"title"]];
                    }
                    else
                    {
                        [offtitleArray addObject:@""];
                    }
                    if(dic[@"createDateStr"] != nil)
                    {
                        [offdateArray addObject:dic[@"createDateStr"]];
                    }
                    else
                    {
                        [offdateArray addObject:@""];
                    }
                    if(dic[@"hrefUrl"] != nil)
                    {
                        [offUrlArray addObject:dic[@"hrefUrl"]];
                    }
                    else
                    {
                        [offUrlArray addObject:@""];
                    }
                }
                [HUD hide:YES];
                [self.tv reloadData];
            }
        }
        
        
    } failure:^(NSError *NSError) {
        
        
        
        [HUD hide:YES];
        
        NSString *message= [Tool getErrorMsssage:NSError];
        
        NSLog(@"%@",message);
        
    }];
}


- (void)recoverTabbar
{
    self.tabBarController.view.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(segIndex == 0)
    {
        if(titleArray.count>1)
        {
            return 2;
        }
        else
        {
            return titleArray.count;
        }
    }
    else
    {
        if(offtitleArray.count>1)
        {
            return 2;
        }
        else
        {
            return offtitleArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorColor:[UIColor colorWithRed:243.0f/255.0f green:245.0f/255.0f blue:246.0f/255.0f alpha:1]];
    
    static NSString *CellWithIdentifier = @"Cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:245.0f/255.0f blue:246.0f/255.0f alpha:1];
    
    for(UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height*200)/568)];
    bgView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    bgView.layer.borderWidth = 1;
    bgView.layer.cornerRadius = 6;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height*200)/568)];
//    cellImage.image = [UIImage imageNamed:@"bg"];
    
    [bgView addSubview:cellImage];

    [cell.contentView addSubview:bgView];
    
    if(segIndex == 0)
    {
        
        NSURL *url = [NSURL URLWithString:picUrlArray[indexPath.row]];

        [cellImage sd_setImageWithURL:url  placeholderImage:nil];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:offpicUrlArray[indexPath.row]];

        [cellImage sd_setImageWithURL:url  placeholderImage:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str;
    [HUD show:YES];
    if(segIndex == 0)
    {
        str = UrlArray[indexPath.row];
    }
    else
    {
        str = offUrlArray[indexPath.row];
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if(![str isEqualToString:@""])
    {
        if([str containsString:@"activity/seckillActivities.htm"])
        {
            NSDictionary *dic;
            if([UserTool userIsLogin])
            {
                dic = @{@"userId":[UserTool getUserID]};
            }
            else
            {
                dic = @{@"userId":@""};
            }
            NSString *str = [StringHelper dicSortAndMD5:dic];
            NSDictionary *param = @{@"channel":@"APP",@"params":dic,@"sign":str,@"version":@"1.0"};
            WebViewController *web = [sb instantiateViewControllerWithIdentifier:@"web"];
            web.url = [NSString stringWithFormat:@"%@/activity/seckillActivities.htm?message=%@",htmlUrl,param];
            web.title = @"详情";
            web.isFromHome = YES;
            web.hidesBottomBarWhenPushed = YES;
            UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:web];
            
            nc.navigationBar.barStyle = UIStatusBarStyleDefault;
            [nc.navigationBar setTintColor:[UIColor whiteColor]];
            [HUD hide:YES];
            [self presentViewController:nc animated:YES completion:nil];
        }
        else
        {
            WebViewController *web = [sb instantiateViewControllerWithIdentifier:@"web"];
            web.url = str;
            web.title = @"详情";
            web.hidesBottomBarWhenPushed = YES;
            [HUD hide:YES];
            [self.navigationController pushViewController:web animated:YES];
        }
    }
    else
    {
        [HUD hide:YES];
        WebViewController *web = [sb instantiateViewControllerWithIdentifier:@"web"];
        web.url = [NSString stringWithFormat:@"%@/partners.htm",htmlUrl];
        web.title = @"详情";
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.bounds.size.height*200)/568;
}

@end

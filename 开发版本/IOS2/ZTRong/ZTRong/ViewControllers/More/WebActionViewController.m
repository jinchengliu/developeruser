//
//  WebActionViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "WebActionViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"

@interface WebActionViewController ()
{
    NSMutableArray *webActionArray;
    MBProgressHUD *HUD;
}

@end

@implementation WebActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tv.delegate = self;
    self.tv.dataSource = self;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    webActionArray = [NSMutableArray array];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"网站公告"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
//    [self.tv setSeparatorColor:[UIColor clearColor]];
    self.tv.dataSource=self;
    self.tv.delegate=self;
    [self.tv setTableHeaderView:self.selectView];
    [self.tv addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tv.headerPullToRefreshText = @"下拉刷新...";
    self.tv.headerReleaseToRefreshText = @"松开刷新";
    self.tv.headerRefreshingText = @"正在刷新中...";
    [self.tv addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tv.footerPullToRefreshText = @"上拉显示更多数据";
    self.tv.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tv.footerRefreshingText = @"正在加载中...";
    [self.view addSubview:self.tv];
    
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
    
    //localhost/user/reflectRecords.htm?message={"channel":"APP","params":{"page":"1","userId":"21734be0-7056-4ef6-9a57-b36b63813575"},"sign":"fc80848a2a154cc2d69dea6b972a03b0","version":"1.0"}
    if(self.isRefush==YES){
        return;
    }
    
    //刷新时请求数据
    [HUD show:YES];
    NSDictionary *param = @{@"categoryId":@"f8164f8c-e12e-44a1-8be5-d13fab1a68ba",@"page":[NSString stringWithFormat:@"%zi",self.page]};
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/newsList.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            NSArray *arr = [NSMutableArray arrayWithArray:dict[@"map"][@"pageInfo"][@"rows"]];
            NSInteger allPage=[[dict[@"map"] objectForKey:@"totalPage"] integerValue];
            if(self.page!=1){
                [webActionArray addObjectsFromArray:arr];
            }else{
                webActionArray =[[NSMutableArray alloc] initWithArray:arr];
                self.hasmoreSC=YES;
                self.tv.footerPullToRefreshText = @"上拉显示更多数据";
                self.tv.footerReleaseToRefreshText = @"松开显示更多数据";
                self.tv.footerRefreshingText = @"正在加载中...";
                
            }
            if(allPage == self.page || allPage ==0){
                self.hasmoreSC=NO;
                self.tv.footerPullToRefreshText = @"";
                self.tv.footerReleaseToRefreshText = @"";
                self.tv.footerRefreshingText = @"没有更多数据了";
            }
            [self.tv reloadData];
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }

        
        
    } failure:^(NSError *NSError) {
        
        
        
        [HUD hide:YES];
        
        NSString *message= [Tool getErrorMsssage:NSError];
        
        NSLog(@"%@",message);
        
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [webActionArray removeAllObjects];
    
    [HUD show:YES];
    
    NSDictionary * params = @{@"channel":@"APP",@"params":@{@"categoryId":@"f8164f8c-e12e-44a1-8be5-d13fab1a68ba",@"page":@"1"},@"sign":@"d8484f86c8a75d7b1bba284fe4588334",@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/newsList.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            NSLog(@"%@",dict);
            webActionArray = [NSMutableArray arrayWithArray:dict[@"map"][@"pageInfo"][@"rows"]];
            [self.tv reloadData];
        }
        else{
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    } failure:^(NSError *NSError) {
        
        
        
        [HUD hide:YES];
        
        NSString *message= [Tool getErrorMsssage:NSError];
        
        NSLog(@"%@",message);
        
    }];
}

- (void)backAction{
    if (_isFromHome) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self.navigationController popViewControllerAnimated:YES];
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
//    return [dic[@"map"][@"pageInfo"][@"rows"] count];
    return webActionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
    }
    
    for(UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.bounds.size.width-130, 20)];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 5, 80, 20)];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.view.bounds.size.width-60, 45)];
    
//    NSDictionary *dt = dic[@"map"][@"pageInfo"][@"rows"][indexPath.row];
    NSDictionary *dt = webActionArray[indexPath.row];
    titleLabel.text = dt[@"title"];
    titleLabel.font = [UIFont fontWithName:nil size:15];
    timeLabel.text = dt[@"createDateStr"];
    timeLabel.font = [UIFont fontWithName:nil size:14];
    timeLabel.textColor = [UIColor grayColor];
    
    detailLabel.text = dt[@"description"];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont fontWithName:nil size:14];
    detailLabel.textColor = [UIColor grayColor];
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:timeLabel];
    [cell.contentView addSubview:detailLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [HUD show:YES];
    NSDictionary *dt = webActionArray[indexPath.row];
    if(dt[@"newDetailUrl"] != nil)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        WebViewController *web = [storyBoard instantiateViewControllerWithIdentifier:@"web"];
        web.title = @"公告详情";
        web.url = [NSString stringWithFormat:@"%@",dt[@"newDetailUrl"]];
        [HUD hide:YES];
        [self.navigationController pushViewController:web animated:YES];
    }
    else
    {
        [HUD hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有详细介绍" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end

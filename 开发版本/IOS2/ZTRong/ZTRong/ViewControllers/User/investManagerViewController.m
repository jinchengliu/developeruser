//
//  investManagerViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/22.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "investManagerViewController.h"
#import "investDetailViewController.h"
#import "MBProgressHUD.h"

@interface investManagerViewController ()
{
    NSInteger segIndex;
    NSMutableArray *allArray;
    NSMutableArray *realArray;
    MBProgressHUD *HUD;
    SelectionPopup *popup;
}

@end

@implementation investManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tv.dataSource = self;
    self.tv.delegate = self;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"投资管理"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    allArray = [NSMutableArray array];
    realArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    [self.sc addSegmentButton:@[@"不限",@"近一个月",@"近三个月",@"近半年"] withNormalImage:@"activities_icon02" withSelectImage:@"activities_icon01"];
    [self.sc setDidSelect:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
        segIndex = index;

        [HUD show:YES];
        NSDictionary *dict = @{@"dateTerm":[NSString stringWithFormat:@"%zi",segIndex],@"page":@"1",@"status":@"",@"userId":[UserTool getUserID]};
        NSString *str = [StringHelper dicSortAndMD5:dict];
        NSDictionary * params = @{@"channel":@"APP",@"params":dict,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/investMgr.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                allArray = [NSMutableArray arrayWithArray:dict[@"map"][@"pageInfo"][@"rows"]];
                realArray = [NSMutableArray arrayWithArray:dict[@"map"][@"pageInfo"][@"rows"]];
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
        
    }];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"my_redbag_right_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(showPopo)];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem;
    
    self.tv.dataSource=self;
    self.tv.delegate=self;
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
    self.page ++;
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
    
    //刷新时请求数据
    [HUD show:YES];
    NSDictionary *dict = @{@"dateTerm":[NSString stringWithFormat:@"%zi",segIndex],@"page":[NSString stringWithFormat:@"%zi",self.page],@"status":@"",@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:dict];
    NSDictionary * params = @{@"channel":@"APP",@"params":dict,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/investMgr.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            NSArray *arr = [NSMutableArray arrayWithArray:dict[@"map"][@"pageInfo"][@"rows"]];
            NSInteger allPage=[[dict[@"map"] objectForKey:@"totalPage"] integerValue];
            if(self.page!=1){
                [realArray addObjectsFromArray:arr];
            }else{
                realArray =[[NSMutableArray alloc] initWithArray:arr];
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
            if (self.page == allPage) {
                self.page = allPage-1;
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

- (void)backAction{
    if (_isFromHome) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(_isFromWebView){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)showPopo{
  
  //
    
    
    
    if(popup==nil){
        popup=[[SelectionPopup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        popup.showDate =[[NSArray alloc] initWithObjects:@"不限",@"未成标",@"成标",@"计息中",@"已赎回", nil];
        NSArray *typeArray= [[NSArray alloc] initWithObjects:@"",@"未成标",@"成标",@"计息中",@"已赎回", nil];

      //
        __weak investManagerViewController *blockself = self;
        popup.finishBlock=^(NSInteger i){
            blockself.Selection =[typeArray objectAtIndex:i];
            blockself.page=1;
            [blockself doSelectionPopup];
            [blockself.tv reloadData];
        };

    }


    
    [popup showInView:APPDELEGATE.window MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
    }];
    
}

-(void)doSelectionPopup{
    
    [realArray removeAllObjects];
    for(NSDictionary *dict in allArray)
    {
        if(![self.Selection isEqualToString:@""])
        {
            if([dict[@"orderStatus"] isEqualToString:self.Selection])
            {
                [realArray addObject:dict];
            }
        }
        else
        {
            realArray = [NSMutableArray arrayWithArray:allArray];
        }
    }

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HUD show:YES];
    self.page = 1;
    
    NSDictionary *dict = @{@"dateTerm":@"0",@"page":@"1",@"status":@"",@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:dict];
    NSDictionary * params = @{@"channel":@"APP",@"params":dict,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/investMgr.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            allArray = [NSMutableArray arrayWithArray:dict[@"map"][@"pageInfo"][@"rows"]];
            realArray = [NSMutableArray arrayWithArray:dict[@"map"][@"pageInfo"][@"rows"]];
            if(allArray.count == 0)
            {
                UIImageView *image;
                if(DEVICE_IS_IPHONE6Plus)
                {
                    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, self.view.bounds.size.height)];
                }
                else
                {
                    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -40, self.view.bounds.size.width, self.view.bounds.size.height)];
                }
                image.image = [UIImage imageNamed:@"充值记录.jpg"];
                [self.view addSubview:image];
            }
            else
            {
                [self.tv reloadData];
            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return realArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorColor:[UIColor colorWithRed:243.0f/255.0f green:245.0f/255.0f blue:246.0f/255.0f alpha:1]];
    
    static NSString *CellWithIdentifier = @"managerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
    }
    for(id subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
     cell.contentView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:245.0f/255.0f blue:246.0f/255.0f alpha:1];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.view.bounds.size.width-10, 140)];
    bgView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    bgView.layer.borderWidth = 1;
    bgView.layer.cornerRadius = 6;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, (self.view.bounds.size.width*180)/320, 30)];
    idLabel.font = [UIFont fontWithName:nil size:13];
    NSDictionary *dict = realArray[indexPath.row];
    idLabel.text = [NSString stringWithFormat:@"ID：%@",dict[@"orderId"]];
    [bgView addSubview:idLabel];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(idLabel.frame.size.width+20, 5, (self.view.bounds.size.width*40)/320, 30)];
    monthLabel.font = [UIFont fontWithName:nil size:14];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.textColor = [UIColor redColor];
    if([dict[@"repayUnit"] intValue] == 1001)
    {
        monthLabel.text = [NSString stringWithFormat:@"%@天",dict[@"repayPeriod"]];
    }
    else if ([dict[@"repayUnit"] intValue] == 1002)
    {
        monthLabel.text = [NSString stringWithFormat:@"%@个月",dict[@"repayPeriod"]];
    }
    else if ([dict[@"repayUnit"] intValue] == 1003)
    {
        monthLabel.text = [NSString stringWithFormat:@"%@季",dict[@"repayPeriod"]];
    }
    else if ([dict[@"repayUnit"] intValue] == 1004)
    {
        monthLabel.text = [NSString stringWithFormat:@"%@年",dict[@"repayPeriod"]];
    }
    [bgView addSubview:monthLabel];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-70, 15, 90, 25)];
    
    stateLabel.text = @"     计息中";
    stateLabel.text = [NSString stringWithFormat:@"     %@",dict[@"orderStatus"]];
    if([dict[@"orderStatus"] isEqualToString:@"计息中"])
    {
        stateLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image10"]];
    }
    else
    {
        stateLabel.backgroundColor = [UIColor colorWithRed:188.0f/255.0f green:189.0f/255.0f blue:190.0f/255.0f alpha:1];
    }
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.font = [UIFont systemFontOfSize:14];
    stateLabel.layer.cornerRadius = 13;
    stateLabel.layer.masksToBounds = YES;
    [cell.contentView addSubview:stateLabel];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 35, self.view.bounds.size.width-120, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:203.0f/255.0f blue:184.0f/255.0f alpha:1];
    [bgView addSubview:lineview];
    
    UILabel *benLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 50, (self.view.bounds.size.width*100)/320, 30)];
    benLabel.font = [UIFont fontWithName:nil size:14];
    benLabel.text = [NSString stringWithFormat:@"￥ %@",dict[@"priceAmountStr"]];
    [bgView addSubview:benLabel];
    
    UILabel *ben = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 20, 20)];
    ben.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:143.0f/255.0f blue:81.0f/255.0f alpha:1].CGColor;
    ben.layer.borderWidth = 1;
    ben.layer.cornerRadius = 6;
    ben.layer.masksToBounds = YES;
    ben.textColor = [UIColor colorWithRed:178.0f/255.0f green:143.0f/255.0f blue:81.0f/255.0f alpha:1];
    ben.text = @"本";
    ben.font = [UIFont systemFontOfSize:12];
    ben.layer.cornerRadius = 10;
    ben.layer.masksToBounds = YES;
    ben.textAlignment = 1;
    [bgView addSubview:ben];
    
    UILabel *yinLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2+30, 50, (self.view.bounds.size.width*100)/320, 30)];
    yinLabel.textColor = [UIColor redColor];
    yinLabel.font = [UIFont fontWithName:nil size:14];
    yinLabel.text = [NSString stringWithFormat:@"￥ %@",dict[@"predictInterestsStr"]];
    [bgView addSubview:yinLabel];
    
    UILabel *yin = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2+5, 55, 20, 20)];
    yin.layer.borderColor = [UIColor redColor].CGColor;
    yin.layer.borderWidth = 1;
    yin.layer.cornerRadius = 6;
    yin.layer.masksToBounds = YES;
    yin.textColor = [UIColor redColor];
    yin.text = @"盈";
    yin.font = [UIFont systemFontOfSize:12];
    yin.layer.cornerRadius = 10;
    yin.layer.masksToBounds = YES;
    yin.textAlignment = 1;
    [bgView addSubview:yin];
    
    UILabel *bfsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    bfsLabel.font = [UIFont fontWithName:nil size:14];
    bfsLabel.text = dict[@"yearRateStr"];
    bfsLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:bfsLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 100, self.view.bounds.size.width/2-10, 30)];
    dateLabel.font = [UIFont fontWithName:nil size:14];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.text = [NSString stringWithFormat:@"投资日期:%@",dict[@"createDateStr"]];
    [bgView addSubview:dateLabel];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    investDetailViewController *investDetail = [[investDetailViewController alloc] init];
    NSDictionary *tempDic = allArray[indexPath.row];
    investDetail.ordId = tempDic[@"orderId"];
    [self.navigationController pushViewController:investDetail animated:YES];
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

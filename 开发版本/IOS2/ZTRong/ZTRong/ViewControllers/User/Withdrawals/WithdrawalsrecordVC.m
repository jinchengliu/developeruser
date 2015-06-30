//  提现记录
//  WithdrawalsrecordVC.m
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "WithdrawalsrecordVC.h"
#import "WithdrawalsCell.h"
@interface WithdrawalsrecordVC (){
    ZTRNoDateView *noData;
}
@property(nonatomic,strong)SelectionPopup *popup;
@property(nonatomic,strong)NSMutableArray *arrs;
@property(nonatomic)NSInteger page;
@property(nonatomic,strong)NSString *Selection;
@property(nonatomic,strong)NSString *dateTerm;
@property(nonatomic)BOOL hasmoreSC;
@property(nonatomic)BOOL isRefush;

@end

@implementation WithdrawalsrecordVC


//添加没有数据的界面
-(void)addnoData{
    
    if(noData==nil){
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recharge_bg02"]];
    
        noData =[[ ZTRNoDateView alloc ] initWithFrame:CGRectMake(0, 40, self.tv.frame.size.width, self.tv.frame.size.height-40) view:image];
    }
    
    [self.tv addSubview:noData];
}

//上拉刷新
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



- (void)selectClick:(UIButton *)sender{
    
    //选中其中一个  其他都不选
    for (UIButton *btn in self.selectView.subviews) {
        if (btn.tag > 0) {
            if (btn.tag == sender.tag) {
                btn.selected = YES;
               // btn.enabled=NO;
            }else{
                btn.selected = NO;
               // btn.enabled=YES;
            }
            
        }
    }
    
    if(sender.tag ==1){
        self.dateTerm=@"";
    }else if(sender.tag ==2){
        self.dateTerm =@"7";
    }else if(sender.tag ==3){
        self.dateTerm =@"1";
    }else if(sender.tag ==4){
        self.dateTerm =@"3";
    }
    
    self.page=1;
    [self getreflectRecords];
    

}



//选择筛选分类
-(void)showPopo{
    
//    未审核    weishenhe
//    审核通过   shenhetongguo
//    审核未通过 shenheweitongguo
//    已完成    yiwancheng
    if(self.popup==nil){
        self.popup=[[SelectionPopup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        self.popup.showDate =[[NSArray alloc] initWithObjects:@"不限",@"未审核",@"审核通过",@"审核未通过",@"已完成", nil];
        
        NSArray *typeArray= [[NSArray alloc] initWithObjects:@"",@"weishenhe",@"shenhetongguo",@"shenheweitongguo",@"yiwancheng", nil];
        __weak WithdrawalsrecordVC *blockself = self;
        self.popup.finishBlock=^(NSInteger i){
            blockself.Selection =[typeArray objectAtIndex:i];
            blockself.page=1;
            [blockself getreflectRecords];
            
        };

    }
    
    
    
    
    [self.popup showInView:APPDELEGATE.window MaskColor:[[UIColor clearColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
        
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"提现记录";
    NSArray *arrs=[[NSArray alloc] initWithObjects:@"不限",@"近一周",@"近一月", @"近三月" ,nil];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.selectView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 40)];
   // [self.view addSubview:self.selectView];
    
    self.arrs =[[NSMutableArray alloc] init];
    self.page=1;
    self.Selection=@"";
    self.dateTerm=@"";
    self.isRefush=NO;
    float kWidth = kAppWidth/arrs.count;
    for (int i = 0; i < arrs.count; i ++) {
        UIButton *segment = [[UIButton alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 40)];
        [segment setBackgroundImage:[UIImage imageNamed:@"touzi_segment"] forState:UIControlStateNormal];
        [segment setBackgroundImage:[UIImage imageNamed:@"touzi_segment_f"] forState:UIControlStateSelected];
        //[segment setBackgroundColor:[UIColor greenColor]];
        [segment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [segment setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
        segment.tag = 1 + i;
        if (i == 0) {
            segment.selected = YES;
        }
        [segment setTitle:arrs[i] forState:UIControlStateNormal];
        segment.titleLabel.font = [UIFont systemFontOfSize:12];
        [segment addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:segment];
    }
    
    float h=0;
    if(self.navigationController.tabBarController!=nil  && self.navigationController.tabBarController.tabBar.hidden==NO){
        h=kAppTabBarHeight;
    }else{
        h=0;
    }
    
    self.tv =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kAppWidth, kAppHeight-64)];
    [self.tv setSeparatorColor:[UIColor clearColor]];
    self.tv.dataSource=self;
    self.tv.delegate=self;
    [self.tv setTableHeaderView:self.selectView ];
    [self.tv addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tv.headerPullToRefreshText = @"下拉刷新...";
    self.tv.headerReleaseToRefreshText = @"松开刷新";
    self.tv.headerRefreshingText = @"正在刷新中...";
    [self.tv addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tv.footerPullToRefreshText = @"上拉显示更多数据";
    self.tv.footerReleaseToRefreshText = @"松开显示更多数据";
    self.tv.footerRefreshingText = @"正在加载中...";
    [self.view addSubview:self.tv];
    
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"recharge_iconright"] style:UIBarButtonItemStyleBordered target:self action:@selector(showPopo)];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
    [self getreflectRecords];
   
}


-(void)viewWillAppear:(BOOL)animated{
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



#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrs.count;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic= [self.arrs objectAtIndex:indexPath.row];
    
    if([dic objectForKey:@"memo"] ==nil){
        return 125;
    }
    
    return 150;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier=[NSString stringWithFormat:@"tariff_cell"];
    WithdrawalsCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        // cell=[[SinceMediaCell alloc] init];
        cell=[[[NSBundle mainBundle] loadNibNamed:@"WithdrawalsCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"WithdrawalsCell" bundle:nil] forCellReuseIdentifier:identifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
    [cell resetCell:[self.arrs objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

//获取数据
-(void)getreflectRecords{
    
    if(self.isRefush==YES){
        return;
    }
    
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    [map setObject:[NSString stringWithFormat:@"%zi",self.page] forKey:@"page"];
    if(self.Selection !=nil && self.Selection.length>0){
        [map setObject:self.Selection forKey:@"status"];
    }
    
    //这参数有问题
    if(self.dateTerm !=nil && self.dateTerm.length>0){
        NSString *date=[NSString stringWithFormat:@"%@",self.dateTerm];
        [map setObject:date forKey:@"dateTerm"];
    }
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    
    NSLog(@"%@",params.description);
    self.isRefush=YES;
    //[self.HUD show:YES];
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kCmdreflectRecords] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
        [self.HUD hide:YES];
         self.isRefush=NO;
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            // [self pushToRechargeVC];
            //pageInfo
            self.dateMap=[[dict objectForKey:@"map"] objectForKey:@"pageInfo"];
            NSArray *arr=[self.dateMap objectForKey:@"rows"];
            if(self.page!=1){
                [self.arrs addObjectsFromArray:arr];
            }else{
                self.arrs=[[NSMutableArray alloc] initWithArray:arr];
                self.hasmoreSC=YES;
                self.tv.footerPullToRefreshText = @"上拉显示更多数据";
                self.tv.footerReleaseToRefreshText = @"松开显示更多数据";
                self.tv.footerRefreshingText = @"正在加载中...";
                
            }
            NSInteger allPage=[[self.dateMap objectForKey:@"totalPage"] integerValue];
            if(allPage == self.page || allPage ==0){
                self.hasmoreSC=NO;
                self.tv.footerPullToRefreshText = @"";
                self.tv.footerReleaseToRefreshText = @"";
                self.tv.footerRefreshingText = @"没有更多数据了";
            }
            
            if(self.arrs.count==0){
                [self addnoData];
            }else {
                [noData removeFromSuperview];
            }
            
            [self.tv reloadData];
            
        }else{
            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }
        

        
        
    } failure:^(NSError *error){
        [self hideHUD:[Tool getErrorMsssage:error]];
        self.isRefush=NO;
        NSString *message= [Tool getErrorMsssage:error];
        NSLog(@"%@",message);
    
    
    }];
    
}


@end

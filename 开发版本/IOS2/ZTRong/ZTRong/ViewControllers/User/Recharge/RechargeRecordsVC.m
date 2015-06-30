//
//  RechargeRecordsVC.m
//  ZTRong
//
//  Created by fcl on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "RechargeRecordsVC.h"
#import "RechargeRecordsCellTableViewCell.h"

@interface RechargeRecordsVC ()
{
    ZTRNoDateView *noData;
}

@property(nonatomic,strong)SelectionPopup *popup;
@property(nonatomic,strong)NSMutableArray *arrs; //保存数据的列表
@property(nonatomic)NSInteger page;   //页数
@property(nonatomic)NSInteger selectPage;   //选中的页数
@property(nonatomic,strong)NSString *Selection; //类型筛选
@property(nonatomic,strong)NSString *dateTerm;  //时间区间筛选
@property(nonatomic)BOOL hasmoreSC;  //是否还有更多
@property(nonatomic)BOOL isRefush;   //是不是在请求中

@end

@implementation RechargeRecordsVC


//添加没有数据的界面
-(void)addnoData{
    
    if(noData==nil){
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recharge_bg01"]];
    
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
    
    [self getrechargeRecords];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tv headerEndRefreshing];
    });
    
}

//下拉加载更多
-(void)footerRereshing{
    if(self.hasmoreSC==YES){
        self.page=self.page+1;
        [self getrechargeRecords];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tv footerEndRefreshing];
        });
        
    }else{
        [self.tv footerEndRefreshing];
    }
    
    
}




//按钮切换
- (void)selectClick:(UIButton *)sender{
    
    //选中其中一个  其他都不选
    for (UIButton *btn in self.selectView.subviews) {
        if (btn.tag > 0) {
            if (btn.tag == sender.tag) {
                btn.selected = YES;
                //btn.enabled=NO;
            }else{
                btn.selected = NO;
                //btn.enabled=YES;
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
    [self getrechargeRecords];
    
}



//选择筛选分类
-(void)showPopo{
    if(self.popup==nil){
        self.popup=[[SelectionPopup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        self.popup.showDate =[[NSArray alloc] initWithObjects:@"不限",@"未完成",@"已完成",@"失败", nil];
        NSArray *typeArray= [[NSArray alloc] initWithObjects:@"",@"weiwancheng",@"yiwancheng",@"shibai", nil];
        
         __weak RechargeRecordsVC *blockself = self;
        self.popup.finishBlock=^(NSInteger i){
           blockself.Selection =[typeArray objectAtIndex:i];
           blockself.page=1;
           [blockself getrechargeRecords];
        
        };
    }
    [self.popup showInView:APPDELEGATE.window MaskColor:[[UIColor clearColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
        
        
    }];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"充值记录";
     self.page=1;
    self.selectPage=0;
    self.isRefush=NO;
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    NSArray *arrs=[[NSArray alloc] initWithObjects:@"不限",@"近一周",@"近一月", @"近三月" ,nil];
    self.selectView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 40)];
    [self.view addSubview:self.selectView];
    
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
    if(self.navigationController.tabBarController!=nil  &&      self.navigationController.tabBarController.tabBar.hidden==NO){
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
    
    
   // [self initXLScroll];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"recharge_iconright"] style:UIBarButtonItemStyleBordered target:self action:@selector(showPopo)];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
    
    [self getrechargeRecords];
    
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
    //memo   备注
    NSDictionary *dic= [self.arrs objectAtIndex:indexPath.row];
    
    if([dic objectForKey:@"memo"]==nil){
        return 100;
    }
    
    return 120;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier=[NSString stringWithFormat:@"Cell"];
    RechargeRecordsCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        // cell=[[SinceMediaCell alloc] init];
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RechargeRecordsCellTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"RechargeRecordsCellTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        
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




-(void)getrechargeRecords{
    
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
        [map setObject:self.dateTerm forKey:@"dateTerm"];
    }
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    NSLog(@"%@",params);
    self.isRefush=YES;
   
    [self showHUD];
    
    
    [Tool ZTRPostRequest: [NSString stringWithFormat:@"%@%@",htmlUrl,KCmdrechargeRecords] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
    
        self.isRefush=NO;
        [self.HUD hide:YES];
        
        if([dict[@"success"] intValue] == 1){
            // [self pushToRechargeVC];
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
            
            if(allPage == self.page || allPage ==0 ){
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
        self.isRefush=NO;
        NSString *message= [Tool getErrorMsssage:error];
        NSLog(@"%@",message);
        
        [self hideHUD:message];
    
    
    }];
    
}

-(void)initXLScroll {
    
    
    CGRect frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -64);//如果没有导航栏，则去掉64
    
    //对应填写两个数组
    self.viewArrays=[[NSMutableArray alloc] init];
    for(int i=0; i<4;i++){
        
        UITableView *tv=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, self.view.frame.size.height -104)];
        
        
        [self.viewArrays addObject:tv];
       
    }
    
    NSArray *names =[[NSArray alloc] initWithObjects:@" 不限 ",@" 近一周 ",@" 近一月 ", @" 近三月 " ,nil];; //按钮名字数组
    //创建使用
    self.xlScroll =[XLScrollViewer scrollWithFrame:frame withViews:self.viewArrays withButtonNames:names withThreeAnimation:111];//三中动画都选择
    
    //自定义各种属性。。打开查看
    
    self.xlScroll.xl_topBackColor =[UIColor whiteColor];              //头部背景色
    self.xlScroll.xl_buttonColorNormal =[UIColor blackColor];          //按钮文字默认颜色
    self.xlScroll.xl_buttonColorSelected =[UIColor brownColor];        //按钮选中颜色
    self.xlScroll.xl_buttonFont =14;                                   //按钮字体
    self.xlScroll.xl_topHeight =40;                                //头部宽
    self.xlScroll.xl_isMoveButton = NO;                            //滚动切换时候滚动按钮动画
    //self.scroll.xl_topBackImage =[UIImage imageNamed:@"10.jpg"];  //头部背景图片
    //    self.scroll.xl_buttonToSlider =20;
    //    self.scroll.xl_sliderHeight =40;
    //self.scroll.xl_sliderColor =[UIColor orangeColor];
    // self.scroll.xl_isSliderCorner =YES;
    
    
   // 加入控制器视图
    [self.view addSubview: self.xlScroll];

    
    
    
    
}


- (void)XLScrollViewerScroll:(NSInteger )index{
    
}


@end

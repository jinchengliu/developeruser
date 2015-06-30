//
//  myshareViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/24.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "myshareViewController.h"
#import "MyPromotionUserController.h"
#import "SharePopup.h"

@interface myshareViewController ()
{
    NSInteger segIndex;
    NSMutableArray *sevendayArray;
    NSMutableArray *todayArray;
}

@end

@implementation myshareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sevendayArray = [NSMutableArray array];
    todayArray = [NSMutableArray array];
    segIndex = 0;
    // Do any additional setup after loading the view from its nib.
    [self.sc addSegmentButton:@[@"当天",@"近7天",@"当天",@"近7天"] withNormalImage:@"activities_icon02" withSelectImage:@"activities_icon01"];
    [self.sc setDidSelect:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
        segIndex = index;
        
        [self.tv reloadData];
    }];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"我的分享"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem;
    
    self.tv.dataSource = self;
    self.tv.delegate = self;
    
    [self.headerView setBackgroundColor:[UIColor colorWithRed:166.0f/255.0f green:133.0f/255.0f blue:77.0f/255.0f alpha:1]];
    
    [self.detailView setBackgroundColor:[UIColor colorWithRed:227.0f/255.0f green:194.0f/255.0f blue:134.0f/255.0f alpha:1]];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:246.0f/255.0f blue:247.0f/255.0f alpha:1];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[UserTool getUserID]}];
    NSMutableDictionary *params =[Tool getHttpParams:dict];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/myPromotion.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            if([dict[@"map"][@"hasFenxiaoUser"] intValue] == 0)
            {
                if([dict[@"map"] valueForKey:@"userVOList7Day"] != nil)
                {
                    sevendayArray = [NSMutableArray arrayWithArray:dict[@"map"][@"userVOList7Day"]];
                }
                if([dict[@"map"] valueForKey:@"userVOListToday"] != nil)
                {
                    todayArray = [NSMutableArray arrayWithArray:dict[@"map"][@"userVOListToday"]];
                }
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width, self.headerView.frame.size.height)];
//                if(dict[@"map"][@"billboard"] != nil)
//                {
//                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"map"][@"billboard"][@"picUrl"]]];
                    image.image = [UIImage imageNamed:@"my_share_no"];
                    [self.headerView addSubview:image];
//                }
                
                UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.sharefriendBtn.frame.origin.x-30, self.sharefriendBtn.frame.origin.y+self.sharefriendBtn.frame.size.height/2-10, 25, 20)];
                image2.image = [UIImage imageNamed:@"t_myshare_no_friend"];
                [self.view addSubview:image2];
                [self.sharefriendBtn setTitle:@"我的小伙伴" forState:UIControlStateNormal];
                [self.sharefriendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [self.sharefriendBtn setEnabled:NO];
                [self.tv reloadData];
            }
            else
            {
                self.shareTotalMoney.text = dict[@"map"][@"sumMoney"];
                self.todayMoney.text = [NSString stringWithFormat:@"￥ %@",dict[@"map"][@"userTodayGet"]];
                self.weekMoney.text = [NSString stringWithFormat:@"￥ %@",dict[@"map"][@"user7DayGet"]];
                self.monthMoney.text = [NSString stringWithFormat:@"￥ %@",dict[@"map"][@"user30DayGet"]];
                
                if([dict[@"map"] valueForKey:@"userVOList7Day"] != nil)
                {
                    sevendayArray = [NSMutableArray arrayWithArray:dict[@"map"][@"userVOList7Day"]];
                }
                if([dict[@"map"] valueForKey:@"userVOListToday"] != nil)
                {
                    todayArray = [NSMutableArray arrayWithArray:dict[@"map"][@"userVOListToday"]];
                }
                UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.sharefriendBtn.frame.origin.x-30, self.sharefriendBtn.frame.origin.y+self.sharefriendBtn.frame.size.height/2-10, 25, 20)];
                image2.image = [UIImage imageNamed:@"t_myshare_my_friend"];
                [self.view addSubview:image2];
                [self.sharefriendBtn setTitle:@"我的小伙伴" forState:UIControlStateNormal];
                [self.sharefriendBtn setTitleColor:[UIColor colorWithRed:228.0f/255.0f green:84.0f/255.0f blue:45.0f/255.0f alpha:1] forState:UIControlStateNormal];
                [self.sharefriendBtn setEnabled:YES];
                
                [self.tv reloadData];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(NSError *NSError) {
        
        self.view.userInteractionEnabled = YES;
        
        NSString *message= [Tool getErrorMsssage:NSError];
        NSLog(@"%@",message);
        
        if(NSError.code == -1004)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];

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
        return todayArray.count;
    }
    else
    {
        return sevendayArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    for(id subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, cell.frame.size.height/2-10, 80, 20)];
    userNameLabel.font = [UIFont fontWithName:nil size:14];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:userNameLabel];
    cell.detailTextLabel.text = @"";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, cell.frame.size.height/2-8, 16, 16)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:nil size:14];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.text = [NSString stringWithFormat:@"%zi",indexPath.row+1];
    [cell.contentView addSubview:label];
    
    if(segIndex == 0)
    {
        NSDictionary *dic = [todayArray objectAtIndex:indexPath.row];
        userNameLabel.text = dic[@"vagueUserName"];
        
        cell.detailTextLabel.font = [UIFont fontWithName:nil size:14];
        NSString *str = [NSString stringWithFormat:@"分享奖励 ￥%@",dic[@"totalDistributionAmountStr"]];
        if(indexPath.row < 3)
        {
            label.textColor = [UIColor whiteColor];
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange redRange = NSMakeRange(5, 1+[dic[@"totalDistributionAmountStr"] length]);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
            [cell.detailTextLabel setAttributedText:noteStr];
            if(indexPath.row == 0)
            {
                label.backgroundColor = [UIColor colorWithRed:160.0f/255.0f green:120.0f/255.0f blue:70.0f/255.0f alpha:1];
            }
            if(indexPath.row == 1)
            {
                label.backgroundColor = [UIColor lightGrayColor];
            }
            if(indexPath.row == 2)
            {
                label.backgroundColor = [UIColor colorWithRed:108.0f/255.0f green:65.0f/255.0f blue:24.0f/255.0f alpha:1];
            }
        }
        else
        {
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange redRange = NSMakeRange(5, 1+[dic[@"totalDistributionAmountStr"] length]);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
            [cell.detailTextLabel setAttributedText:noteStr] ;
            
            label.textColor = [UIColor colorWithRed:158.0f/255.0f green:118.0f/255.0f blue:61.0f/255.0f alpha:1];
        }
    }
    else
    {
        NSDictionary *dic = [sevendayArray objectAtIndex:indexPath.row];
        userNameLabel.text = dic[@"vagueUserName"];
        
        cell.detailTextLabel.font = [UIFont fontWithName:nil size:14];
        NSString *str = [NSString stringWithFormat:@"分享奖励 ￥%@",dic[@"totalDistributionAmountStr"]];
        if(indexPath.row < 3)
        {
            label.textColor = [UIColor whiteColor];
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange redRange = NSMakeRange(5, 1+[dic[@"totalDistributionAmountStr"] length]);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
            [cell.detailTextLabel setAttributedText:noteStr] ;
            if(indexPath.row == 0)
            {
                label.backgroundColor = [UIColor colorWithRed:160.0f/255.0f green:120.0f/255.0f blue:70.0f/255.0f alpha:1];
            }
            if(indexPath.row == 1)
            {
                label.backgroundColor = [UIColor lightGrayColor];
            }
            if(indexPath.row == 2)
            {
                label.backgroundColor = [UIColor colorWithRed:108.0f/255.0f green:65.0f/255.0f blue:24.0f/255.0f alpha:1];
            }
        }
        else
        {
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange redRange = NSMakeRange(5, 1+[dic[@"totalDistributionAmountStr"] length]);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
            [cell.detailTextLabel setAttributedText:noteStr] ;
            
            label.textColor = [UIColor colorWithRed:158.0f/255.0f green:118.0f/255.0f blue:61.0f/255.0f alpha:1];
        }
    }
    return cell;
}

- (IBAction)shareBtnPressed:(id)sender {
    
    SharePopup *popup=[[SharePopup  alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    popup.sharecontent=@"中投融分享测试";
    popup.shareImage=[UIImage imageNamed:@"banner_01@2x.jpg"]; //图片2选1
    popup.shareURL= @"https://www.baidu.com";
    popup.rootViewController = self;
    
    [popup showInView:self.tabBarController.view MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
        
    }];
}

- (IBAction)sharefriendBtnPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyPromotionUserController *myPromotionUserController = [storyboard instantiateViewControllerWithIdentifier:@"MyPromotionUserController"];
    myPromotionUserController.title = @"我的分享用户";
    [self.navigationController pushViewController:myPromotionUserController animated:YES];
}
@end

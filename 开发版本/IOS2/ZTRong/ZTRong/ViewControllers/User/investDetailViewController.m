//
//  investDetailViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/24.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "investDetailViewController.h"
#import "MBProgressHUD.h"

@interface investDetailViewController ()
{
    NSDictionary *orderDic;
    MBProgressHUD *HUD;
    NSTimer *leftTimerLabel;
    NSString *totalDateStr;
}
@end

@implementation investDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    self.sc.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:246.0f/255.0f blue:247.0f/255.0f alpha:1];
    self.sc.contentSize = CGSizeMake(self.view.bounds.size.width, 630);
    
    self.backImage.backgroundColor = [UIColor colorWithRed:176.0f/255.0f green:141.0f/255.0f blue:79.0f/255.0f alpha:1];
    
    //self.htBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.htBtn.layer.borderWidth = 1;
    
   
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"投资详情"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
}

- (void)backAction{
    if (_isFromHome) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)setOrderDetail:(NSDictionary *)dict
{
    self.titleLabel.text = dict[@"categoryName"];
    self.detaiNameLabel.text = dict[@"itemTitle"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateFormt = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateFormt);
    
    NSDate *totalDate = [dateFormatter dateFromString:dict[@"expdateStr"]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSSecondCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:totalDate options:0];
    
    long day = ([comps second]/3600)/24;
    long hour = (([comps second]-day*24*3600)/60)/60;
    long minute = ([comps second]-day*24*3600-hour*3600)/60;
    long second = ([comps second]-day*24*3600-hour*3600-minute*60)%60;
    totalDateStr = dict[@"expdateStr"];
    self.lefttimeLabel.text = [NSString stringWithFormat:@"%li天%li小时%li分%li秒",day,hour,minute,second];
    NSArray *array = [dict[@"expdateStr"] componentsSeparatedByString:@" "];
    self.dateLabel.text = array[0];
    self.profileLabel.text = [NSString stringWithFormat:@"￥ %.2f",[dict[@"predictInterestsStr"] floatValue]];
    self.payBackLabel.text = [NSString stringWithFormat:@"%@",dict[@"returnIntegralStr"]];
    self.totalPrice.text = dict[@"priceAmountStr"];
    self.redBagLabel.text = dict[@"redAmountStr"];
    self.beginLabel.text = dict[@"gainInterestsStartTimeStr"];
    self.realPayLabel.text = dict[@"realPayStr"];
    self.countLabel.text = dict[@"integralStr"];
    self.gmLabel.text = [NSString stringWithFormat:@"%i万元",[dict[@"creditAmountStr"] intValue]];
    if([dict[@"returnIntegral"] intValue] == 0)
    {
        self.boolPayLabel.text = @"否";
    }
    else
    {
        self.boolPayLabel.text = @"是";
    }
    self.wayLabel.text = dict[@"interestBearing"];
    if([dict[@"markeOver"] intValue] == 0)
    {
        self.jyLabel.text = @"否";
    }
    else
    {
        self.jyLabel.text = @"三个月可转";
    }
    self.fhblLabel.text = dict[@"buyIntegralStr"];
    self.jxfsLabel.text = dict[@"repayMent"];
    self.idLabel.text = dict[@"orderId"];
    self.dwLabel.text = dict[@"repayPeriodStr"];
    self.benLabel.text = dict[@"priceAmountStr"];
    self.yinLabel.text = dict[@"predictInterestsStr"];
    self.bfbLabel.text = dict[@"yearRateStr"];
    self.startDateLabel.text = [NSString stringWithFormat:@"投资日期：%@",dict[@"createDateStr"]];
    
    self.jxLabel1.layer.cornerRadius = 10;
    self.jxLabel1.layer.masksToBounds = YES;
    
    self.jxLabel.text = [NSString stringWithFormat:@"   %@",dict[@"orderStatus"]];
    if(![dict[@"orderStatus"] isEqualToString:@"计息中"])
    {
        self.jxLabel.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        self.jxLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image10"]];
    }
    self.jxLabel.layer.cornerRadius = 10;
    self.jxLabel.layer.masksToBounds = YES;
    
    UILabel *ben = [[UILabel alloc] initWithFrame:CGRectMake(self.benLabel.frame.origin.x-25, self.benLabel.frame.origin.y, 20, 20)];
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
    [self.underView addSubview:ben];
    
    UILabel *yin = [[UILabel alloc] initWithFrame:CGRectMake(self.yinLabel.frame.origin.x-25, self.yinLabel.frame.origin.y, 20, 20)];
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
    [self.underView addSubview:yin];
}

- (void)countLeftNumber
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateFormt = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateFormt);
    
    NSDate *totalDate = [dateFormatter dateFromString:totalDateStr];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSSecondCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:totalDate options:0];
    
    long day = ([comps second]/3600)/24;
    long hour = (([comps second]-day*24*3600)/60)/60;
    long minute = ([comps second]-day*24*3600-hour*3600)/60;
    long second = ([comps second]-day*24*3600-hour*3600-minute*60)%60;
    self.lefttimeLabel.text = [NSString stringWithFormat:@"%li天%li小时%li分%li秒",day,hour,minute,second];
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)htBtnPressed:(id)sender
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    NSDictionary *dict = @{@"orderId":self.ordId,@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:dict];
    NSDictionary * params = @{@"channel":@"APP",@"params":dict,@"sign":str,@"version":@"1.0"};
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/donwPdf.htm?message=%@",htmlUrl,[StringHelper dictionaryToJson:params]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *web = [sb instantiateViewControllerWithIdentifier:@"web"];
    web.url = urlString;
    web.title = @"合同";
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HUD show:YES];
    NSDictionary *dict = @{@"orderId":self.ordId,@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:dict];
    NSDictionary * params = @{@"channel":@"APP",@"params":dict,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/investMgrDetail.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            orderDic = dict[@"map"][@"userOrderInfo"];
            [self setOrderDetail:orderDic];
            leftTimerLabel = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countLeftNumber) userInfo:nil repeats:YES];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [leftTimerLabel invalidate];
    leftTimerLabel = nil;
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

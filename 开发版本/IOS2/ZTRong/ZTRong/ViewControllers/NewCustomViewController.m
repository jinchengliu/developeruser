//
//  NewCustomViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "NewCustomViewController.h"
#import "loginViewController.h"
#import "PhoneViewController.h"
#import "PayPasswordViewController.h"
#import "registerViewController.h"
#import "AppDelegate.h"
#import "IdentityAuthenticationVC.h"
#import "CircleProcessView.h"
#import "MBProgressHUD.h"
#import "WebViewController.h"
#import "InvestmentDetailViewController.h"

@interface NewCustomViewController ()
{
    MBProgressHUD *HUD;
    NSString *itemID;
    NSString *amount;
    UITextField *textField;
    NSInteger isNew;
    NSMutableArray *itemIdArray;
    NSDictionary *dictionary;
    NSMutableArray *minPriceArray;
}
@end

@implementation NewCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    itemIdArray = [NSMutableArray array];
    minPriceArray = [NSMutableArray array];
    
    self.headerImageview.image = [UIImage imageNamed:@"banner_01.jpg"];
    
    self.backView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:246.0f/255.0f blue:247.0f/255.0f alpha:1];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"新客专区"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;

}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for(id sunbview in self.backView.subviews)
    {
        [sunbview removeFromSuperview];
    }
    [HUD show:YES];

    NSDictionary *param;
    if([UserTool userIsLogin])
    {
        param = @{@"page":@"1",@"userId":[UserTool getUserID]};
    }
    else
    {
        param = @{@"page":@"1"};
    }
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/newUserArea.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            dictionary = dict;
            amount = [NSString stringWithFormat:@"%@",dict[@"map"][@"accountAmount"]];
            if([dict[@"map"][@"isLogin"] intValue] == 1&&[dict[@"map"][@"phoneSet"] intValue] == 1&&[dict[@"map"][@"payPwdSet"] intValue] == 1)
            {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
                image.image = [UIImage imageNamed:@"novice_icon01"];
                [self.backView addSubview:image];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 70, 30)];
                label.font = [UIFont fontWithName:nil size:14];
                label.text = @"亲爱的";
                [self.backView addSubview:label];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 30)];
                nameLabel.font = [UIFont fontWithName:nil size:12];
                nameLabel.textColor = [UIColor colorWithRed:181.0f/255.0f green:148.0f/255.0f blue:95.0f/255.0f alpha:1];
                nameLabel.text = [UserTool getTel];
                [self.backView addSubview:nameLabel];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 55, self.view.bounds.size.width-40, 1)];
                imageView.backgroundColor = [UIColor lightGrayColor];
                [self.backView addSubview:imageView];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, self.view.bounds.size.width-40, 30)];
                label2.font = [UIFont fontWithName:nil size:14];
                label2.text = @"恭喜您，中投融投资之路正式起航！";
                [self.backView addSubview:label2];
                
                UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, (self.view.bounds.size.width*200)/320, 30)];
                label3.font = [UIFont fontWithName:nil size:14];
                //float amountF = [dict[@"map"][@"accountAmount"] floatValue];
                label3.text = [NSString stringWithFormat:@"您账户余额为：%@ 元。",dict[@"map"][@"accountAmount"]];
                [self.backView addSubview:label3];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(220, 95, 80, 30)];
                [button setTitle:@"去充值" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont fontWithName:nil size:14];
                [button setBackgroundImage:[UIImage imageNamed:@"image10"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(pushToMoney) forControlEvents:UIControlEventTouchUpInside];
                [self.backView addSubview:button];
                
                [self setScrollerView:dict];
            }

            else if([dict[@"map"][@"isLogin"] intValue] == 0)
            {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.backView.frame.size.height/2-20, 40, 40)];
                image.image = [UIImage imageNamed:@"novice_icon02"];
                [self.backView addSubview:image];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(70, self.backView.frame.size.height/2-35, 140, 30)];
                label1.font = [UIFont fontWithName:nil size:13];
                label1.text = @"首先，您需要先登录";
                [self.backView addSubview:label1];
                
                UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(220, self.backView.frame.size.height/2-35, 80, 30)];
                button1.titleLabel.font = [UIFont fontWithName:nil size:14];
                [button1 setTitle:@"登录" forState:UIControlStateNormal];
                [button1 setBackgroundImage:[UIImage imageNamed:@"image10"] forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(pushToLogin) forControlEvents:UIControlEventTouchUpInside];
                [self.backView addSubview:button1];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(70, self.backView.frame.size.height/2+5, 140, 30)];
                label2.font = [UIFont fontWithName:nil size:14];
                label2.text = @"若还未注册账号，请花";
                [self.backView addSubview:label2];
                
                UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(220, self.backView.frame.size.height/2+5, 90, 30)];
                button2.titleLabel.font = [UIFont fontWithName:nil size:14];
                [button2 setTitle:@"30秒快速注册" forState:UIControlStateNormal];
                [button2 setBackgroundImage:[UIImage imageNamed:@"image10"] forState:UIControlStateNormal];
                [button2 addTarget:self action:@selector(pushToRegisterView) forControlEvents:UIControlEventTouchUpInside];
                [self.backView addSubview:button2];
                
                [self setScrollerView:dict];
            }
            else if([dict[@"map"][@"phoneSet"] intValue] == 0)
            {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
                image.image = [UIImage imageNamed:@"novice_icon01"];
                [self.backView addSubview:image];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 70, 30)];
                label.font = [UIFont fontWithName:nil size:14];
                label.text = @"亲爱的";
                [self.backView addSubview:label];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 30)];
                nameLabel.font = [UIFont fontWithName:nil size:12];
                nameLabel.textColor = [UIColor colorWithRed:181.0f/255.0f green:148.0f/255.0f blue:95.0f/255.0f alpha:1];
                nameLabel.text = [UserTool getTel];
                [self.backView addSubview:nameLabel];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 55, self.view.bounds.size.width-40, 1)];
                imageView.backgroundColor = [UIColor lightGrayColor];
                [self.backView addSubview:imageView];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, self.view.bounds.size.width-40, 30)];
                label1.font = [UIFont fontWithName:nil size:14];
                label1.text = @"欢迎登入新客专区！";
                [self.backView addSubview:label1];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 180, 30)];
                label2.font = [UIFont fontWithName:nil size:14];
                label2.text = @"为保证您的资金安全，请先";
                [self.backView addSubview:label2];
                
                UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(210, 100, 80, 30)];
                button1.titleLabel.font = [UIFont fontWithName:nil size:14];
                [button1 setTitle:@"手机认证" forState:UIControlStateNormal];
                [button1 setBackgroundImage:[UIImage imageNamed:@"image10"] forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(pushToPhoneRecord) forControlEvents:UIControlEventTouchUpInside];
                [self.backView addSubview:button1];
                
                [self setScrollerView:dict];
            }
            else if([dict[@"map"][@"payPwdSet"] intValue] == 0)
            {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
                image.image = [UIImage imageNamed:@"novice_icon01"];
                [self.backView addSubview:image];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 70, 30)];
                label.font = [UIFont fontWithName:nil size:14];
                label.text = @"亲爱的";
                [self.backView addSubview:label];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 30)];
                nameLabel.font = [UIFont fontWithName:nil size:12];
                nameLabel.textColor = [UIColor colorWithRed:181.0f/255.0f green:148.0f/255.0f blue:95.0f/255.0f alpha:1];
                nameLabel.text = [UserTool getTel];
                [self.backView addSubview:nameLabel];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 55, self.view.bounds.size.width-40, 1)];
                imageView.backgroundColor = [UIColor lightGrayColor];
                [self.backView addSubview:imageView];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, self.view.bounds.size.width-40, 20)];
                label1.font = [UIFont fontWithName:nil size:14];
                label1.text = @"欢迎登入新客专区！";
                [self.backView addSubview:label1];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, (self.view.bounds.size.width*200)/320, 25)];
                label2.font = [UIFont fontWithName:nil size:14];
                float amountF = [dict[@"map"][@"accountAmount"] floatValue]/100;
                label2.text = [NSString stringWithFormat:@"您账户余额为：%.2f 元。",amountF];
                [self.backView addSubview:label2];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(230, 85, 70, 25)];
                [button setTitle:@"去充值" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont fontWithName:nil size:14];
                [button setBackgroundImage:[UIImage imageNamed:@"image10"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(pushToMoney) forControlEvents:UIControlEventTouchUpInside];
                [self.backView addSubview:button];
                
                
                UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 190, 25)];
                label3.font = [UIFont fontWithName:nil size:14];
                label3.text = @"为保证资金不被他人操作，请";
                [self.backView addSubview:label3];
                
                UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(220, 115, 90, 25)];
                button1.titleLabel.font = [UIFont fontWithName:nil size:14];
                [button1 setTitle:@"设置支付密码" forState:UIControlStateNormal];
                [button1 setBackgroundImage:[UIImage imageNamed:@"image10"] forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(pushToSetPayPassword) forControlEvents:UIControlEventTouchUpInside];
                [self.backView addSubview:button1];
                
                [self setScrollerView:dict];
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

- (void)pushToLogin
{
    
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:nil afterDelay:0.6f];
    
    loginViewController *loginView = [[loginViewController alloc] init];
    loginView.isFromIndex3 = YES;
    UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:loginView];
    
    nc.navigationBar.barStyle = UIStatusBarStyleDefault;
    [nc.navigationBar setTintColor:[UIColor whiteColor]];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)pushToRegisterView
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:nil afterDelay:0.6f];

    registerViewController *registerView = [[registerViewController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}

- (void)pushToPhoneRecord
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:nil afterDelay:0.6f];

    PhoneViewController *phoneView = [[PhoneViewController alloc] init];
    [self.navigationController pushViewController:phoneView animated:YES];
}

- (void)pushToSetPayPassword
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:nil afterDelay:0.6f];

    PayPasswordViewController *payPasswordView = [[PayPasswordViewController alloc] init];
    [self.navigationController pushViewController:payPasswordView animated:YES];
}

//去充值
- (void)pushToMoney
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:nil afterDelay:0.6f];

    [Tool pushToRecharge:self.navigationController];
}

- (void)pushToinvestView:(UIButton *)btn
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:nil afterDelay:0.6f];
    if([UserTool userIsLogin])
    {
        if([dictionary[@"map"][@"isNewUser"] intValue] == 1)
        {
            if([dictionary[@"map"][@"payPwdSet"] intValue] == 1)
            {
                NSInteger tag = 10+btn.tag;
                UITextField *text = (UITextField *)[self.underScroller viewWithTag:tag];
                if([text.text intValue] < [minPriceArray[btn.tag] intValue]/100&&text.text.length > 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"投资金额不能低于起投金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    text.text = @"";
                }
                else
                {
                    if(text.text.length == 0)
                    {
                        text.text = [NSString stringWithFormat:@"%i",[minPriceArray[btn.tag] intValue]/100];
                    }
                    NSDictionary *dic = @{@"itemId":itemIdArray[btn.tag],
                                          @"userId":[UserTool getUserID],
                                          @"amount":text.text};
                    NSDictionary *params = @{@"channel":@"APP",
                                             @"params":dic,
                                             @"sign":[StringHelper dicSortAndMD5:dic],
                                             @"version":@"1.0"};

                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    NSString *urlStr = [NSString stringWithFormat:@"%@/confirmInvest.htm?message=%@",htmlUrl,[StringHelper dictionaryToJson:params]];
                    WebViewController *WebViewController = [storyBoard instantiateViewControllerWithIdentifier:@"web"];
                    WebViewController.url = urlStr;
                    WebViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:WebViewController animated:YES];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置支付密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"非新手用户不能使用该功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还未登录，请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];

    }
}

- (void)setScrollerView:(NSDictionary *)dict
{
    for(id subview in self.underScroller.subviews)
    {
        [subview removeFromSuperview];
    }
    [itemIdArray removeAllObjects];
    if(dict[@"map"][@"pageInfo"][@"rows"] != nil)
    {
        NSArray *array = dict[@"map"][@"pageInfo"][@"rows"];
        self.underScroller.contentSize = CGSizeMake(self.view.bounds.size.width, 170*array.count);
        for(int i=0;i<array.count;i++)
        {
            
            NSDictionary *dic = array[i];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10+(155*i), 23, 25)];
            imageView.image = [UIImage imageNamed:@"novice_icon03"];
            [self.underScroller addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10+(155*i), 60, 25)];
            label.font = [UIFont fontWithName:nil size:14];
            label.text = @"新手专享";
            [self.underScroller addSubview:label];
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 10+(155*i), self.view.bounds.size.width-140, 25)];
            label1.font = [UIFont fontWithName:nil size:12];
            label1.textColor = [UIColor lightGrayColor];
            label1.text = dic[@"title"];
            [self.underScroller addSubview:label1];
            
            UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10+(155*i), kAppWidth - 40, 25)];
            clickBtn.tag = i;
            clickBtn.backgroundColor = [UIColor clearColor];
            [clickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.underScroller addSubview:clickBtn];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40+(155*i), self.view.bounds.size.width-40, 1)];
            image.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:209.0f/255.0f blue:187.0f/255.0f alpha:1];
            [self.underScroller addSubview:image];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50+(155*i), (self.view.bounds.size.width*50)/320, 20)];
            label2.font = [UIFont fontWithName:nil size:12];
            label2.text = @"年化利率";
            label2.textAlignment = NSTextAlignmentCenter;
            [self.underScroller addSubview:label2];
            
            UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75+(155*i), (self.view.bounds.size.width*50)/320, 20)];
            rateLabel.font = [UIFont fontWithName:nil size:12];
//                rateLabel.text = dic[@"yearRate"];
            rateLabel.textColor = [UIColor colorWithRed:229.0f/255.0f green:92.0f/255.0f blue:46.0f/255.0f alpha:1];
            rateLabel.text = [NSString stringWithFormat:@"%@",dic[@"yearRateStr"]];
            rateLabel.textAlignment = NSTextAlignmentCenter;
            [self.underScroller addSubview:rateLabel];
            
            UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width+5, 55+(155*i), 1, 40)];
            image1.backgroundColor = [UIColor lightGrayColor];
            [self.underScroller addSubview:image1];
            
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width+10, 50+(155*i), (self.view.bounds.size.width*50)/320, 20)];
            label3.font = [UIFont fontWithName:nil size:12];
            label3.text = @"产品期限";
            label3.textAlignment = NSTextAlignmentCenter;
            [self.underScroller addSubview:label3];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width+10, 75+(155*i), (self.view.bounds.size.width*50)/320, 20)];
            timeLabel.font = [UIFont fontWithName:nil size:12];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.textColor = [UIColor colorWithRed:229.0f/255.0f green:92.0f/255.0f blue:46.0f/255.0f alpha:1];
            timeLabel.text = [NSString stringWithFormat:@"%@%@",dic[@"repayPeriod"],dic[@"repayUnitChange"]];
            [self.underScroller addSubview:timeLabel];
            
            UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(label3.frame.origin.x+label3.frame.size.width+5, 55+(155*i), 1, 40)];
            image2.backgroundColor = [UIColor lightGrayColor];
            [self.underScroller addSubview:image2];
            
            UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.frame.origin.x+label3.frame.size.width+10, 50+(155*i), (self.view.bounds.size.width*90)/320, 20)];
            label4.font = [UIFont fontWithName:nil size:12];
            label4.textAlignment = NSTextAlignmentCenter;
            label4.text = @"还本付息方式";
            [self.underScroller addSubview:label4];
            
            UILabel *wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(label3.frame.origin.x+label3.frame.size.width+10, 75+(155*i), (self.view.bounds.size.width*90)/320, 20)];
            wayLabel.font = [UIFont fontWithName:nil size:12];
            wayLabel.textColor = [UIColor colorWithRed:229.0f/255.0f green:92.0f/255.0f blue:46.0f/255.0f alpha:1];
            wayLabel.textAlignment = NSTextAlignmentCenter;
            wayLabel.text = [NSString stringWithFormat:@"%@",dic[@"repayMentChange"]];
            [self.underScroller addSubview:wayLabel];
           
            CGRect rect = CGRectMake((self.view.bounds.size.width*120)/320, 25+(155/2*i), 80, 80);
            CircleProcessView *circleView = [[CircleProcessView alloc] initWithFrame:rect];
            circleView.progressWidth = 5;
            circleView.tag = 6;
            circleView.progressColor = [UIColor colorWithRed:227/255.0f green:66/255.0f blue:44/255.0f alpha:0.8];
            [circleView setProgress:0.5];
            circleView.trackColor = [UIColor colorWithRed:220/255.0f green:222/255.0f blue:224/255.0f alpha:1];
            [self.underScroller addSubview:circleView];
             UILabel *remainAmount = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width*252)/320, 42+(155*i), 50, 70)];
            remainAmount.textColor = [UIColor blackColor];
            remainAmount.font = [UIFont systemFontOfSize:10];
            remainAmount.tag = 7;
            remainAmount.numberOfLines = 2;
            remainAmount.textAlignment = 1;
            remainAmount.adjustsFontSizeToFitWidth = YES;
            [self.underScroller addSubview:remainAmount];
            NSNumber *status = dic[@"status"];
            if ([status integerValue] == 1007) {
                //满标
                [circleView setProgress:1];
                remainAmount.text = @"满";
                
            }else{
                [circleView setProgress:[dic[@"currentPreStr"] floatValue]/100];
                remainAmount.text = [NSString stringWithFormat:@"剩余金额 %@",dic[@"currentPriceTotalStr"]];
            }
            
            UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(label4.frame.origin.x+label4.frame.size.width+5, 55+(155*i), 1, 40)];
            image3.backgroundColor = [UIColor lightGrayColor];
            [self.underScroller addSubview:image3];
            
            UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 105+(155*i), self.view.bounds.size.width-40, 1)];
            image4.backgroundColor = [UIColor lightGrayColor];
            [self.underScroller addSubview:image4];
            
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 115+(155*i), (self.view.bounds.size.width*200)/320, 30)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.tag = 10+i;
            textField.placeholder = [NSString stringWithFormat:@"%i元起投，100元递增",[dic[@"minPrice"] intValue]/100];
            [minPriceArray addObject:dic[@"minPrice"]];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.font = [UIFont fontWithName:nil size:14];
            textField.background = [UIImage imageNamed:@"label"];
            textField.delegate=self;
            [self.underScroller addSubview:textField];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(textField.frame.size.width+30, 115+(155*i), self.view.bounds.size.width-textField.frame.size.width-50, 30)];
            [button setBackgroundImage:[UIImage imageNamed:@"image10"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:nil size:14];
            button.tag = i;
            [button setTitle:@"立即投资" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pushToinvestView:) forControlEvents:UIControlEventTouchUpInside];
            [self.underScroller addSubview:button];
            
            [itemIdArray addObject:dic[@"id"]];
        }
    }
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)backgroundTap:(id)sender
{
    for(UITextField *text in self.underScroller.subviews)
    {
        [text resignFirstResponder];
    }
}

- (IBAction)backviewTap:(id)sender
{
    for(UITextField *text in self.underScroller.subviews)
    {
        [text resignFirstResponder];
    }
}

- (void)buttonClick:(UIButton *)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InvestmentDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"InvestDetail"];
    detailVC.itemID = itemIdArray[sender.tag];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextFiredDelgate
//textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField {
        CGPoint pt;
        CGRect rc = self.view.frame;
        pt = rc.origin;
        pt.x = 0;
        pt.y = pt.y- 210;
        self.view.frame=CGRectMake(self.view.frame.origin.x, pt.y, self.view.frame.size.width, self.view.frame.size.height);
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    CGPoint pt;
    CGRect rc = self.view.frame;
    pt = rc.origin;
    pt.x = 0;
    pt.y = pt.y+ 210;
    self.view.frame=CGRectMake(self.view.frame.origin.x, pt.y, self.view.frame.size.width, self.view.frame.size.height);
}




@end

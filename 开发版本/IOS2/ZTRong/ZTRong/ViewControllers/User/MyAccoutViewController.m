//
//  MyAccoutViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "MyAccoutViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "loginViewController.h"
#import "IdentityAuthenticationVC.h"
#import "BankCardAuthenticationVC.h"
#import "MyRedbagTableViewController.h"
#import "MessageViewController.h"
#import "investManagerViewController.h"
#import "myshareViewController.h"
#import "NewCustomViewController.h"

@interface MyAccoutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbluserName;
@property (weak, nonatomic) IBOutlet UILabel *lblinterestStr;
@property (weak, nonatomic) IBOutlet UILabel *lblassetsStr;

@property (weak, nonatomic) IBOutlet UILabel *lblamount;
@property (weak, nonatomic) IBOutlet UILabel *lblreceiveInterestStr;
@property (weak, nonatomic) IBOutlet UILabel *lblIntegral;
@property (weak, nonatomic) IBOutlet UILabel *lblLVOne;
@property (weak, nonatomic) IBOutlet UILabel *lblLVTwo;
@property (weak, nonatomic) IBOutlet UIImageView *_userLogo;
@property (nonatomic,strong)  NSDictionary *dicMod;
@end

@implementation MyAccoutViewController
{
    AppDelegate *appdelegate;
    __weak IBOutlet NSLayoutConstraint *_topRatio;//头像View
    __weak IBOutlet NSLayoutConstraint *_allMoneyRatio;//账户总资产
    __weak IBOutlet NSLayoutConstraint *_moneyRatio;
    __weak IBOutlet NSLayoutConstraint *_lvOrignY;//lv等级的Y
    
    __weak IBOutlet NSLayoutConstraint *topY;
    __weak IBOutlet NSLayoutConstraint *allMoneyY;
    __weak IBOutlet NSLayoutConstraint *moneyY;
    __weak IBOutlet NSLayoutConstraint *underBtn;
    __weak IBOutlet NSLayoutConstraint *leiY;
    __weak IBOutlet NSLayoutConstraint *keY;
    __weak IBOutlet NSLayoutConstraint *benY;
    __weak IBOutlet NSLayoutConstraint *jiY;
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"我的账户";
    _lbluserName.adjustsFontSizeToFitWidth = YES;
    
    if (!DEVICE_IS_IPHONE4) {
//        topY.constant = 40;
//        allMoneyY.constant = - 30;
//        moneyY.constant = - 80;
//        underBtn.constant = - 60;
//        _lvOrignY.constant += 2;
        if(DEVICE_IS_IPHONE5)
        {
            leiY.constant = 25;
            keY.constant = 25;
            jiY.constant = 25;
            benY.constant = 25;
            allMoneyY.constant = 170;
        }
        if (DEVICE_IS_IPHONE6) {
            leiY.constant = 50;
            keY.constant = 50;
            jiY.constant = 50;
            benY.constant = 50;
            allMoneyY.constant = 240;
            underBtn.constant = 100;
        }
        if (DEVICE_IS_IPHONE6Plus){
            leiY.constant = 55;
            keY.constant = 55;
            jiY.constant = 55;
            benY.constant = 55;
            allMoneyY.constant = 260;
            underBtn.constant = 120;
        }
    }
    
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_icon09"] style:UIBarButtonItemStyleBordered target:self action:@selector(pushToSetting)];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor brownColor];
    
    appdelegate = [[UIApplication sharedApplication] delegate];
    
    __userLogo.layer.masksToBounds = YES;
    __userLogo.layer.borderColor = [UIColor brownColor].CGColor;
    __userLogo.layer.borderWidth = 0.5;
    __userLogo.layer.cornerRadius = __userLogo.frame.size.width/2;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    if (![UserTool userIsLogin]) {
        self.tabBarController.selectedIndex = 2;
    }
}

- (void)recoverTabbar
{
    self.tabBarController.view.userInteractionEnabled = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([UserTool userIsLogin])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[UserTool getUserID]}];
        NSMutableDictionary *params =[Tool getHttpParams:dict];
        
        [HUD show:YES];
        self.view.userInteractionEnabled = NO;
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kUserIndex] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict) {
            
            [HUD hide:YES];
            self.view.userInteractionEnabled = YES;
            
            if([dict[@"success"] intValue] == 1){
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"map"][@"userName"] forKey:UserName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                self.lbluserName.text=[UserTool getUserName];
                self.phoneNumberLabel.text = [UserTool getTel];
                
                
                self.lblamount.text= [NSString stringWithFormat:@"¥ %@",dict[@"map"][@"amount"]];
                self.lblassetsStr.text=dict[@"map"][@"assetsStr"];
                self.lblIntegral.text=[NSString stringWithFormat:@"%@",dict[@"map"][@"integral"]];
                self.lblinterestStr.text=[NSString stringWithFormat:@"¥ %@",dict[@"map"][@"interestStr"]];
                self.lblreceiveInterestStr.text=[NSString stringWithFormat:@"¥ %@",dict[@"map"][@"receiveInterestStr"]];
                _lblLVOne.text = dict[@"map"][@"distributionLevel"];
                _lblLVTwo.text = dict[@"map"][@"investLevel"];
                
                [HUD hide:YES];
                self.view.userInteractionEnabled = YES;
                
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
            
            if(NSError.code == -1004)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }];
        
    }
    else
    {
        loginViewController *loginView = [[loginViewController alloc] init];
        loginView.isFromIndex3 = YES;
        UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:loginView];
        
        nc.navigationBar.barStyle = UIStatusBarStyleDefault;
        [nc.navigationBar setTintColor:[UIColor whiteColor]];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)pushToSetting
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    SettingViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    view.hidesBottomBarWhenPushed = YES;
    view.type = kNavigation;
    [self.navigationController pushViewController:view animated:YES];

}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - UserAction
- (IBAction)btnClick:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    switch (sender.tag) {
        case 1:{
            //充值
            [Tool pushToRecharge:self.navigationController];
          
            
        }
            break;
        case 2:{
            //提现
            [Tool pushToWithdrawals:self.navigationController];
        }
            break;
        case 3:{
            //投资管理
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            investManagerViewController *view = [sb instantiateViewControllerWithIdentifier:@"investManagerViewController"];
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 4:{
            //我的分享
            myshareViewController *myshare = [[myshareViewController alloc] init];
            myshare.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myshare animated:YES];

        }
            break;
        case 5:{
            //我的红包
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyRedbagTableViewController *redBagVC = [sb instantiateViewControllerWithIdentifier:@"redbag"];
            redBagVC.title = @"我的红包";
            redBagVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:redBagVC animated:YES];
        }
            break;
        case 6:{
            //消息管理
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *view = [sb instantiateViewControllerWithIdentifier:@"MessageViewController"];
            view.hidesBottomBarWhenPushed = YES;
            view.type = kNavigation;
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        default:
            break;
    }
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

@end

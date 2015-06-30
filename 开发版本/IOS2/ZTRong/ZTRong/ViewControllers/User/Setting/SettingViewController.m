//
//  SettingViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "SettingViewController.h"
#import "IdentityViewController.h"
#import "PhoneViewController.h"
#import "loginPasswordViewController.h"
#import "PayPasswordViewController.h"
#import "PayChangeViewController.h"
#import "phoneChangeViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface SettingViewController ()
{
    NSArray *image1Array;
    NSArray *image2Array;
    NSArray *list1Array;
    NSArray *list2Array;
    
    BOOL isPhoneRecord;
    BOOL isIdentityRecord;
    BOOL isPayRecord;
    
    NSString *identityCard;
    AppDelegate *appdelegate;
    NSString *identifyStr;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tv.delegate = self;
    self.tv.dataSource = self;
    
    [self.tv setScrollEnabled:NO];
    appdelegate = [[UIApplication sharedApplication] delegate];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"设置"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    image1Array = @[@"image3",@"user_icon08"];
    image2Array = @[@"user_icon07",@"image2"];
    list1Array = @[@"手机认证",@"身份认证"];
    list2Array = @[@"登录密码",@"支付密码"];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showHUD];

    NSDictionary *param = @{@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/querySafety.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        if([dict[@"success"] intValue] == 1)
        {
            [self hideHUD:@""];
            if([dict[@"map"][@"payPwd"] intValue] == 0)
            {
                isPayRecord = NO;
            }
            else
            {
                isPayRecord = YES;
            }
            if([dict[@"map"][@"tel"] intValue] == 0)
            {
                isPhoneRecord = NO;
            }
            else
            {
                isPhoneRecord = YES;
            }
            if([dict[@"map"][@"identityCard"] intValue] == 0)
            {
                isIdentityRecord = NO;
                identifyStr = @"未认证";
            }
            else
            {
                if([dict[@"map"][@"identityAuditstatus"] isEqualToString:@"不通过"])
                {
                    isIdentityRecord = NO;
                    identifyStr = dict[@"map"][@"identityAuditstatus"];
                }
                else if ([dict[@"map"][@"identityAuditstatus"] isEqualToString:@"待审核"])
                {
                    isIdentityRecord = NO;
                    identifyStr = dict[@"map"][@"identityAuditstatus"];
                }
                else
                {
                    isIdentityRecord = YES;
                    identityCard = dict[@"map"][@"identityInfo"];
                }
            }
            [self.tv reloadData];
        }
        else
        {
            [self hideHUD:dict[@"errorMsg"]];
        }
        
        
    } failure:^(NSError *NSError) {
    
        NSString *message= [Tool getErrorMsssage:NSError];
        
        [self hideHUD:message];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell5";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 0)
    {
        cell.imageView.image = [UIImage imageNamed:image1Array[indexPath.row]];
        cell.textLabel.text = list1Array[indexPath.row];
        if(indexPath.row == 0)
        {
            if(isPhoneRecord == NO)
            {
                cell.detailTextLabel.text = @"未认证";
            }
            else
            {
                cell.detailTextLabel.text = @"修改";
            }
        }
        else
        {
            if(isIdentityRecord == NO)
            {
                cell.detailTextLabel.text = identifyStr;
            }
            else
            {
                cell.detailTextLabel.text = identityCard;
                 cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:image2Array[indexPath.row]];
        cell.textLabel.text = list2Array[indexPath.row];
        if(indexPath.row == 0)
        {
            cell.detailTextLabel.text = @"修改";
        }
        else
        {
            if(isPayRecord == NO)
            {
                cell.detailTextLabel.text = @"未设置";
            }
            else
            {
                cell.detailTextLabel.text = @"修改";
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)confirmButton:(id)sender
{
    NSLog(@"被点击了");
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    [UserTool logOffLogin];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            if(isPayRecord == YES&&isPhoneRecord == YES)
            {
                phoneChangeViewController *phoneChange = [[phoneChangeViewController alloc] init];
                [self.navigationController pushViewController:phoneChange animated:YES];
            }
            else
            {
                if(isPhoneRecord == NO)
                {
                    PhoneViewController *phone = [[PhoneViewController alloc] init];
                    [self.navigationController pushViewController:phone animated:YES];
                }
                if(isPayRecord == NO&&isPhoneRecord == YES)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message:@"请先设置支付密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }

        }
        else if (indexPath.row == 1)
        {
            if(isIdentityRecord == NO)
            {
                IdentityViewController *identity = [[IdentityViewController alloc] init];
                [self.navigationController pushViewController:identity animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经认证过身份，无需重新认证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            loginPasswordViewController *loginView = [[loginPasswordViewController alloc] init];
            [self.navigationController pushViewController:loginView animated:YES];
        }
        else if (indexPath.row == 1)
        {
            if(isPayRecord == NO&&isPhoneRecord == YES)
            {
                PayPasswordViewController *payView = [[PayPasswordViewController alloc] init];
                [self.navigationController pushViewController:payView animated:YES];
            }
            else if(isPayRecord == YES&&isPhoneRecord == YES)
            {
                PayChangeViewController *payChangeView = [[PayChangeViewController alloc] init];
                [self.navigationController pushViewController:payChangeView animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先进行手机认证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}
@end

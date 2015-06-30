//
//  IdentityViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "IdentityViewController.h"
#import "MBProgressHUD.h"

@interface IdentityViewController ()
{
    MBProgressHUD *HUD;
}
@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    // Do any additional setup after loading the view from its nib.
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"身份认证"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *nameIcon = [[UIImageView alloc] init];
    nameIcon.image = [UIImage imageNamed:@"user_icon08"];
    nameIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    nameIcon.contentMode = UIViewContentModeCenter;
    self.nameText.leftView = nameIcon;
    self.nameText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *identity = [[UIImageView alloc] init];
    identity.image = [UIImage imageNamed:@"user_icon10"];
    identity.bounds=CGRectMake(5, 2, 40, 20);
    
    identity.contentMode = UIViewContentModeCenter;
    self.identityText.leftView = identity;
    self.identityText.leftViewMode = UITextFieldViewModeAlways;
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.nameText.text.length > 0)
    {
        for(int i=0;i<10;i++)
        {
            if([self.nameText.text rangeOfString:[NSString stringWithFormat:@"%i",i]].location != NSNotFound)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的名字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                self.nameText.text = @"";
            }
        }
    }
    if(self.identityText.text.length > 0)
    {
        if(self.identityText.text.length != 18)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的身份证号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            self.identityText.text = @"";
        }
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [self.nameText resignFirstResponder];
    [self.identityText resignFirstResponder];
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)confirmBtn:(id)sender
{
    //上传身份认证信息
    
    if(self.nameText.text.length > 0&&self.identityText.text.length > 0)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
        
        [HUD show:YES];
        NSDictionary *param = @{@"papersNum":self.identityText.text,@"realName":self.nameText.text,@"userId":[UserTool getUserID]};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/identityAuthForm.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
@end

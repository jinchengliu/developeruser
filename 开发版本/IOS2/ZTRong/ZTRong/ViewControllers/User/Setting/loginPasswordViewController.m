//
//  loginPasswordViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "loginPasswordViewController.h"
#import "loginViewController.h"
#import "MBProgressHUD.h"

@interface loginPasswordViewController ()
{
    AppDelegate *appdelegate;
    MBProgressHUD *HUD;
}

@end

@implementation loginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"登录密码修改"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.navigationController.view addSubview:HUD];
    
    self.loginText.secureTextEntry = YES;
    self.newloginText.secureTextEntry = YES;
    self.newagainText.secureTextEntry = YES;
    appdelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.passLabel.hidden = YES;
    self.newagainLabel.hidden = YES;
    
    self.confirmBtn.enabled = NO;
    
    UIImageView *passIcon = [[UIImageView alloc] init];
    passIcon.image = [UIImage imageNamed:@"user_icon07"];
    passIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    passIcon.contentMode = UIViewContentModeCenter;
    self.loginText.leftView = passIcon;
    self.loginText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *newPassIcon = [[UIImageView alloc] init];
    newPassIcon.image = [UIImage imageNamed:@"user_icon07"];
    newPassIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    newPassIcon.contentMode = UIViewContentModeCenter;
    self.newloginText.leftView = newPassIcon;
    self.newloginText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *newPassagainIcon = [[UIImageView alloc] init];
    newPassagainIcon.image = [UIImage imageNamed:@"user_icon07"];
    newPassagainIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    newPassagainIcon.contentMode = UIViewContentModeCenter;
    self.newagainText.leftView = newPassagainIcon;
    self.newagainText.leftViewMode = UITextFieldViewModeAlways;

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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self isPureInt:string] == NO&&[self isCharater:string] == NO&&![string isEqualToString:@""]&&![string isEqualToString:@"\n"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码只能为数字或者字母" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    else
    {
        if(self.newloginText.text)
        {
            if([self.newloginText.text stringByAppendingString:string].length > 7)
            {
                if([self isPassWord:[self.newloginText.text stringByAppendingString:string]])
                {
                    if([self.newloginText.text stringByAppendingString:string].length > 12)
                    {
                        self.label1.backgroundColor = [UIColor redColor];
                        self.label2.backgroundColor = [UIColor redColor];
                        self.label3.backgroundColor = [UIColor redColor];
                    }
                    else
                    {
                        self.label1.backgroundColor = [UIColor redColor];
                        self.label2.backgroundColor = [UIColor redColor];
                        self.label3.backgroundColor = [UIColor lightGrayColor];
                    }
                }
                else
                {
                    if([self.newloginText.text stringByAppendingString:string].length > 12)
                    {
                        self.label1.backgroundColor = [UIColor redColor];
                        self.label2.backgroundColor = [UIColor redColor];
                        self.label3.backgroundColor = [UIColor lightGrayColor];
                    }
                    else
                    {
                        self.label1.backgroundColor = [UIColor redColor];
                        self.label2.backgroundColor = [UIColor lightGrayColor];
                        self.label3.backgroundColor = [UIColor lightGrayColor];
                        
                    }
                }
            }
            else
            {
                self.label1.backgroundColor = [UIColor lightGrayColor];
                self.label2.backgroundColor = [UIColor lightGrayColor];
                self.label3.backgroundColor = [UIColor lightGrayColor];
            }
        }
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(![self.newloginText.text isEqualToString:self.newagainText.text]&&self.newagainText.text.length > 0&&self.newloginText.text.length > 0)
    {
        self.newagainLabel.hidden = NO;
        self.newagainText.text = @"";
        self.confirmBtn.enabled = NO;
    }
    else
    {
        self.newagainLabel.hidden = YES;
        self.confirmBtn.enabled = YES;
    }
}

- (BOOL)isPassWord:(NSString *)str
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([pred evaluateWithObject:str])
    {
        return YES ;
    }else{
        return NO;
    }
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}


- (IBAction)backgroundTap:(id)sender
{
    [self.newagainText resignFirstResponder];
    [self.loginText resignFirstResponder];
    [self.newloginText resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.newloginText)
    {
        self.newloginText.text = @"";
        
        self.label1.backgroundColor = [UIColor lightGrayColor];
        self.label2.backgroundColor = [UIColor lightGrayColor];
        self.label3.backgroundColor = [UIColor lightGrayColor];
    }
}

- (IBAction)changePasswordBtn:(id)sender
{
    if(self.loginText.text.length > 0&&self.newloginText.text.length > 0&&self.newagainText.text.length > 0)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
        
        [HUD show:YES];
        NSDictionary *param = @{@"comfirmPassword":self.newagainText.text,@"newPassword":self.newloginText.text,@"oldPassword":self.loginText.text,@"userId":[UserTool getUserID]};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/modifyLoginPwd.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                // loginViewController *loginView = [[loginViewController alloc] init];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [UserTool logOffLogin];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isCharater:(NSString *)string
{
    NSString *regex = @"^[A-Za-z]$";;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([pred evaluateWithObject:string])
    {
        return YES ;
    }else{
        return NO;
    }
}
@end

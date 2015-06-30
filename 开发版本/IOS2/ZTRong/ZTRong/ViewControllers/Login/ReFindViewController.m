//
//  ReFindViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "ReFindViewController.h"
#import "MBProgressHUD.h"

@interface ReFindViewController ()
{
    MBProgressHUD *HUD;
}
@end

@implementation ReFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.errorLabel1.hidden = YES;
    self.errorLabel2.hidden = YES;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    UIImageView *payIcon = [[UIImageView alloc] init];
    payIcon.image = [UIImage imageNamed:@"user_icon11"];
    payIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    payIcon.contentMode = UIViewContentModeCenter;
    self.payPassText.leftView = payIcon;
    self.payPassText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *newPassIcon = [[UIImageView alloc] init];
    newPassIcon.image = [UIImage imageNamed:@"user_icon07"];
    newPassIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    newPassIcon.contentMode = UIViewContentModeCenter;
    self.passText.leftView = newPassIcon;
    self.passText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *newPassagainIcon = [[UIImageView alloc] init];
    newPassagainIcon.image = [UIImage imageNamed:@"user_icon07"];
    newPassagainIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    newPassagainIcon.contentMode = UIViewContentModeCenter;
    self.passAgainText.leftView = newPassagainIcon;
    self.passAgainText.leftViewMode = UITextFieldViewModeAlways;
    
    self.payPassText.secureTextEntry = YES;
    self.passText.secureTextEntry = YES;
    self.passAgainText.secureTextEntry = YES;
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"密码找回"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)confirmBtnPressed:(id)sender
{
    if(self.payPassText.text.length > 0&&self.passText.text.length > 0&&self.passAgainText.text.length > 0)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
        
        [HUD show:YES];
        NSDictionary *param = @{@"comfirmPassword":self.passAgainText.text,@"mobile":self.phoneNumber,@"password":self.passText.text,@"payPwd":self.payPassText.text};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/findLoginPwdSecondForm.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)backgroundTap:(id)sender
{
    [self.payPassText resignFirstResponder];
    [self.passText resignFirstResponder];
    [self.passAgainText resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self.passText.text stringByAppendingString:string].length > 7)
    {
        if([self isPassWord:[self.passText.text stringByAppendingString:string]])
        {
            if([self.passText.text stringByAppendingString:string].length > 12)
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
            if([self.passText.text stringByAppendingString:string].length > 12)
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
    return YES;
}

- (BOOL)isPassWord:(NSString *)str
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([pred evaluateWithObject:str])
    {
        return YES ;
    }else{
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(![self.passText.text isEqualToString:self.passAgainText.text]&&self.passAgainText.text.length > 0&&self.passAgainText.text.length > 0)
    {
        self.passAgainText.text = @"";
        self.errorLabel2.hidden = NO;
    }
    else
    {
        self.errorLabel2.hidden = YES;
        self.errorLabel1.hidden = YES;
    }
}
@end

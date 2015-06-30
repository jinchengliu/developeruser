//
//  PayPasswordViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "PayPasswordViewController.h"
#import "MBProgressHUD.h"

@interface PayPasswordViewController ()
{
    NSString *phoneNumber;
    int secondsCountDown;
    MBProgressHUD *HUD;
}

@end

@implementation PayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    // Do any additional setup after loading the view from its nib.
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"支付密码设置"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    self.payPassLabel.hidden = YES;
    self.payPassText.secureTextEntry = YES;
    self.payagainText.secureTextEntry = YES;
    
    secondsCountDown = 60;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *payIcon = [[UIImageView alloc] init];
    payIcon.image = [UIImage imageNamed:@"user_icon11"];
    payIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    payIcon.contentMode = UIViewContentModeCenter;
    self.payPassText.leftView = payIcon;
    self.payPassText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *payagainIcon = [[UIImageView alloc] init];
    payagainIcon.image = [UIImage imageNamed:@"user_icon11"];
    payagainIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    payagainIcon.contentMode = UIViewContentModeCenter;
    self.payagainText.leftView = payagainIcon;
    self.payagainText.leftViewMode = UITextFieldViewModeAlways;

    UIImageView *telIcon2 = [[UIImageView alloc] init];
    telIcon2.image = [UIImage imageNamed:@"image2"];
    telIcon2.bounds=CGRectMake(5, 2, 40, 20);
    
    telIcon2.contentMode = UIViewContentModeCenter;
    self.telVercodeText.leftView = telIcon2;
    self.telVercodeText.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HUD show:YES];

    NSDictionary *param = @{@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/payPwdSet.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            if(dict[@"map"][@"tel"] != nil)
            {
                phoneNumber = dict[@"map"][@"tel"];
                NSMutableString *str = [NSMutableString stringWithString:phoneNumber];
                [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                self.phoneLabel.text = [NSString stringWithFormat:@"认证手机：%@",str];
            }
            else
            {
                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先认证手机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
                //                    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self.payPassText.text stringByAppendingString:string].length > 7)
    {
        if([self isPassWord:[self.payPassText.text stringByAppendingString:string]])
        {
            if([self.payPassText.text stringByAppendingString:string].length > 12)
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
            if([self.payPassText.text stringByAppendingString:string].length > 12)
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
    if(self.payagainText.text.length > 0&&self.payPassText.text.length > 0&&![self.payPassText.text isEqualToString:self.payagainText.text])
    {
        self.payPassLabel.hidden = NO;
        self.payagainText.text = @"";
    }
    else
    {
        self.payPassLabel.hidden = YES;
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [self.payPassText resignFirstResponder];
    [self.payagainText resignFirstResponder];
    [self.telVercodeText resignFirstResponder];
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)telVerCodeBtnPressed:(id)sender
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    [HUD show:YES];
    NSDictionary *param = @{@"mobile":phoneNumber,@"modelID":@"10004",@"userId":[UserTool getUserID],@"voice":@"0"};
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/findSendMessage.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            [HUD hide:YES];
            NSTimer *countDownTimer;
            countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDown:) userInfo:nil repeats:YES];
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

-(void)CountDown:(NSTimer *)timer
{
    secondsCountDown--;
    self.telVerCodeBtn.enabled = NO;
    [self.telVerCodeBtn setTitle:[NSString stringWithFormat:@"%d",secondsCountDown] forState:UIControlStateNormal];
    if (secondsCountDown==0) {
        
        [timer invalidate];
        [self.telVerCodeBtn setTitle:@"点击获取" forState:UIControlStateNormal];
        self.telVerCodeBtn.enabled=YES;
        secondsCountDown=60;
    }
    
}

- (IBAction)confirmBtnPressed:(id)sender
{

    if(self.payPassText.text.length > 7&&self.payPassText.text.length<17&&[self.payPassText.text isEqualToString:self.payagainText.text])
    {
        if(self.telVercodeText.text.length == 6)
        {
            self.view.userInteractionEnabled = NO;
            [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
            
            [HUD show:YES];
        NSDictionary *param = @{@"comfirmPayPassword":self.payagainText.text,@"mobile":phoneNumber,@"modelID":@"10004",@"newPayPassword":self.payPassText.text,@"telVerCode":self.telVercodeText.text,@"userId":[UserTool getUserID]};
            
            NSString *str = [StringHelper dicSortAndMD5:param];
            NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
            
            [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/payPwdSetForm.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确格式的验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的支付密码格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
@end

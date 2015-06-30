//
//  PhoneViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "PhoneViewController.h"
#import "MBProgressHUD.h"

@interface PhoneViewController ()
{
    MBProgressHUD *HUD;
}
@end

@implementation PhoneViewController
{
    int secondsCountDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"手机认证"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    secondsCountDown = 60;
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    UIImageView *PhoneIcon = [[UIImageView alloc] init];
    PhoneIcon.image = [UIImage imageNamed:@"image3"];
    PhoneIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    PhoneIcon.contentMode = UIViewContentModeCenter;
    self.phoneText.leftView = PhoneIcon;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *telIcon = [[UIImageView alloc] init];
    telIcon.image = [UIImage imageNamed:@"image2"];
    telIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    telIcon.contentMode = UIViewContentModeCenter;
    self.telVerCodeText.leftView = telIcon;
    self.telVerCodeText.leftViewMode = UITextFieldViewModeAlways;
    
    self.telVerCodeLabel.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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

- (IBAction)backgroundTap:(id)sender
{
    [self.phoneText resignFirstResponder];
    [self.telVerCodeBtn resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.phoneText.text.length != 11)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        self.phoneText.text = @"";
    }
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)telVerCodeBtnPressed:(id)sender
{
    if(self.phoneText.text.length == 11)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
        
        [HUD show:YES];
        NSDictionary *param = @{@"mobile":self.phoneText.text,@"modelID":@"10001",@"userId":[UserTool getUserID],@"voice":@"0"};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/sendMessage.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)CountDown:(NSTimer *)timer
{
    secondsCountDown--;
    [self.telVerCodeBtn setEnabled:NO];
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
    if(self.phoneText.text.length == 11&&self.telVerCodeText.text.length == 6)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
        
        [HUD show:YES];
        NSDictionary *param = @{@"mobile":self.phoneText.text,@"modelID":@"10001",@"telVerCode":self.telVerCodeText.text,@"userId":[UserTool getUserID]};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/mobileAuthForm.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneText.text forKey:Telphone];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
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
        if(self.phoneText.text.length != 11)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else if (self.telVerCodeText.text.length != 6)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    secondsCountDown = 0;
}
@end

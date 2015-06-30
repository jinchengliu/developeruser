//
//  PayChangeViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "PayChangeViewController.h"
#import "MBProgressHUD.h"

@interface PayChangeViewController ()
{
    NSString *phoneNumber;
    int secondsCountDown;
    MBProgressHUD *HUD;
}
@end

@implementation PayChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    // Do any additional setup after loading the view from its nib.
    self.payPassText.secureTextEntry = YES;
    self.payNewPassText.secureTextEntry = YES;
    self.payNewagainText.secureTextEntry = YES;
    
    self.wrongPayPassLabel.hidden = YES;
    self.wrongPayagainPassLabel.hidden = YES;
    
    secondsCountDown = 60;
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"支付密码修改"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    UIImageView *payIcon = [[UIImageView alloc] init];
    payIcon.image = [UIImage imageNamed:@"user_icon11"];
    payIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    payIcon.contentMode = UIViewContentModeCenter;
    self.payPassText.leftView = payIcon;
    self.payPassText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *payNewPassIcon = [[UIImageView alloc] init];
    payNewPassIcon.image = [UIImage imageNamed:@"user_icon11"];
    payNewPassIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    payNewPassIcon.contentMode = UIViewContentModeCenter;
    self.payNewPassText.leftView = payNewPassIcon;
    self.payNewPassText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *payNewPassagainIcon = [[UIImageView alloc] init];
    payNewPassagainIcon.image = [UIImage imageNamed:@"user_icon11"];
    payNewPassagainIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    payNewPassagainIcon.contentMode = UIViewContentModeCenter;
    self.payNewagainText.leftView = payNewPassagainIcon;
    self.payNewagainText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *telIcon2 = [[UIImageView alloc] init];
    telIcon2.image = [UIImage imageNamed:@"image2"];
    telIcon2.bounds=CGRectMake(5, 2, 40, 20);
    
    telIcon2.contentMode = UIViewContentModeCenter;
    self.telVerCodeText.leftView = telIcon2;
    self.telVerCodeText.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HUD show:YES];

    NSDictionary *param = @{@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/modifyPayPwd.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self.payNewPassText.text stringByAppendingString:string].length > 7)
    {
        if([self isPassWord:[self.payNewPassText.text stringByAppendingString:string]])
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
    if(self.payNewPassText.text.length > 0&&self.payNewagainText.text.length > 0&&![self.payNewPassText.text isEqualToString:self.payNewagainText.text])
    {
        self.wrongPayagainPassLabel.hidden = NO;
        self.payNewagainText.text = @"";
    }
    else
    {
        self.wrongPayagainPassLabel.hidden = YES;
    }
    if(textField == self.telVerCodeText)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        CGRect rect = self.view.frame;
        rect.origin.y += 150;
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.telVerCodeText)
    {
        [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
        [UIView setAnimationDuration:0.30];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- 150, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)backgroundTap:(id)sender
{
    [self.payPassText resignFirstResponder];
    [self.payNewPassText resignFirstResponder];
    [self.payNewagainText resignFirstResponder];
    [self.telVerCodeText resignFirstResponder];
}

- (IBAction)telVerCodeBtnPressed:(id)sender
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    [HUD show:YES];
    NSDictionary *param = @{@"mobile":phoneNumber,@"modelID":@"10005",@"userId":[UserTool getUserID],@"voice":@"0"};
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
    if((self.payNewPassText.text.length > 7&&self.payNewPassText.text.length<17)&&[self.payNewPassText.text isEqualToString:self.payNewagainText.text])
    {
        if(self.telVerCodeText.text.length == 6)
        {
            self.view.userInteractionEnabled = NO;
            [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
            
            [HUD show:YES];
        NSDictionary *param = @{@"comfirmPayPassword":self.payNewagainText.text,@"modelID":@"10005",@"newPayPassword":self.payNewPassText.text,@"oldPayPwd":self.payPassText.text,@"telVerCode":self.telVerCodeText.text,@"userId":[UserTool getUserID]};
        //    NSDictionary *param = @{@"comfirmPayPassword":@"23456789",@"modelID":@"10005",@"newPayPassword":@"23456789",@"oldPayPwd":@"12345678",@"telVerCode":@"183454",@"userId":@"d09df125-aabf-44e1-b660-b4a62cbb4bc0"};
            NSString *str = [StringHelper dicSortAndMD5:param];
            NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
            
            [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/modifyPayPwdForm.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
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

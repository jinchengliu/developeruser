//
//  phoneChangeViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "phoneChangeViewController.h"
#import "MBProgressHUD.h"

@interface phoneChangeViewController ()

@end

@implementation phoneChangeViewController
{
    int secondsCountDown1;
    int secondsCountDown2;
    NSString *phoneNumber;
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.payPassText.secureTextEntry = YES;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"手机认证修改"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    secondsCountDown1 = 60;
    secondsCountDown2 = 60;
    
    self.label1.hidden = YES;
    self.label2.hidden = YES;
    
    UIImageView *telIcon = [[UIImageView alloc] init];
    telIcon.image = [UIImage imageNamed:@"image2"];
    telIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    telIcon.contentMode = UIViewContentModeCenter;
    self.telVerCodeText.leftView = telIcon;
    self.telVerCodeText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *PhoneIcon = [[UIImageView alloc] init];
    PhoneIcon.image = [UIImage imageNamed:@"image3"];
    PhoneIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    PhoneIcon.contentMode = UIViewContentModeCenter;
    self.phoneNewText.leftView = PhoneIcon;
    self.phoneNewText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *payIcon = [[UIImageView alloc] init];
    payIcon.image = [UIImage imageNamed:@"user_icon11"];
    payIcon.bounds=CGRectMake(5, 2, 40, 20);
    
    payIcon.contentMode = UIViewContentModeCenter;
    self.payPassText.leftView = payIcon;
    self.payPassText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *telIcon2 = [[UIImageView alloc] init];
    telIcon2.image = [UIImage imageNamed:@"image2"];
    telIcon2.bounds=CGRectMake(5, 2, 40, 20);
    
    telIcon2.contentMode = UIViewContentModeCenter;
    self.telVerCode2.leftView = telIcon2;
    self.telVerCode2.leftViewMode = UITextFieldViewModeAlways;
    
    self.telVerCode2.delegate = self;
    self.phoneNewText.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HUD show:YES];

    NSDictionary *param = @{@"userId":[UserTool getUserID]};
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/modifyMobile.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 0)
        {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置支付密码，才能修改手机认证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }
        else
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
    [self.phoneNewText resignFirstResponder];
    [self.payPassText resignFirstResponder];
    [self.telVerCodeText resignFirstResponder];
    [self.telVerCode2 resignFirstResponder];
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
    NSDictionary *param = @{@"mobile":phoneNumber,@"modelID":@"10001",@"userId":[UserTool getUserID],@"voice":@"0"};
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
    secondsCountDown1--;
    [self.telVerCodeBtn setEnabled:NO];
    [self.telVerCodeBtn setTitle:[NSString stringWithFormat:@"%d",secondsCountDown1] forState:UIControlStateNormal];
    if (secondsCountDown1==0) {
        [timer invalidate];
        [self.telVerCodeBtn setTitle:@"点击获取" forState:UIControlStateNormal];
        self.telVerCodeBtn.enabled=YES;
        secondsCountDown1=60;
    }
    
}

-(void)CountDown2:(NSTimer *)timer
{
    secondsCountDown2--;
    [self.telVerCodeBtn2 setEnabled:NO];
    [self.telVerCodeBtn2 setTitle:[NSString stringWithFormat:@"%d",secondsCountDown2] forState:UIControlStateNormal];
    if (secondsCountDown2==0) {
        [timer invalidate];
        [self.telVerCodeBtn2 setTitle:@"点击获取" forState:UIControlStateNormal];
        self.telVerCodeBtn2.enabled=YES;
        secondsCountDown2=60;
    }
    
}

- (IBAction)telVerCodeBtn2Pressed:(id)sender
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    [HUD show:YES];

    if (self.phoneNewText.text.length == 11) {
        NSDictionary *param = @{@"mobile":self.phoneNewText.text,@"modelID":@"10001",@"userId":[UserTool getUserID],@"voice":@"0"};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/sendMessage.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                NSTimer *countDownTimer;
                countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDown2:) userInfo:nil repeats:YES];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
- (IBAction)confirmBtnPressed:(id)sender
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];

   
    if(self.phoneNewText.text.length == 11&&self.telVerCode2.text.length == 6&&self.telVerCodeText.text.length == 6)
    {
        NSDictionary *param = @{@"modelID":@"10001",@"newMobileNum":self.phoneNewText.text,@"oldCode":self.telVerCodeText.text,@"payPwd":self.payPassText.text,@"userId":[UserTool getUserID],@"verifyCode":self.telVerCode2.text};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
         [HUD show:YES];
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/modifyUserMobileForm.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneNewText.text forKey:Telphone];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
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
        if(self.phoneNewText.text.length != 11)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else if (self.telVerCodeText.text.length != 6||self.telVerCode2.text.length != 6)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.telVerCode2||textField == self.phoneNewText)
    {
        [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
        [UIView setAnimationDuration:0.30];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- 150, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.telVerCode2||textField == self.phoneNewText)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        CGRect rect = self.view.frame;
        rect.origin.y += 150;
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}
@end

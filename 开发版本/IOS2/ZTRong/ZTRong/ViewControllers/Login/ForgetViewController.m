//
//  ForgetViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "ForgetViewController.h"
#import "ReFindViewController.h"
#import "MBProgressHUD.h"

@interface ForgetViewController ()<UITextViewDelegate>
{
    int secondsCountDown;
    MBProgressHUD *HUD;
}

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.label1.hidden = YES;
    
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
    self.telVcodeText.leftView = telIcon;
    self.telVcodeText.leftViewMode = UITextFieldViewModeAlways;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"如果您的账号未认证手机号码，请联系客服热线400-922-1111"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"tel:400-922-1111"
                             range:[[attributedString string] rangeOfString:@"400-922-1111"]];
    
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                     NSUnderlineColorAttributeName: [UIColor redColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
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
    
    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    self.textview.linkTextAttributes = linkAttributes; // customizes the appearance of links
    self.textview.attributedText = attributedString;
    self.textview.delegate = self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"tel"]) {
        NSLog(@"开始打电话");
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:400-922-1111"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        // do something with this username
        // ...
        return NO;
    }
    return YES; // let the system open this URL
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
    if(self.phoneText.text.length == 11&&self.telVcodeText.text.length > 0)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
        
        [HUD show:YES];
        NSDictionary *param = @{@"mobile":self.phoneText.text,@"modelID":@"10006",@"telVerCode":self.telVcodeText.text};
        NSString *str = [StringHelper dicSortAndMD5:param];
        NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/findLoginPwdFirstForm.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
            
            if([dict[@"success"] intValue] == 1)
            {
                [HUD hide:YES];
                ReFindViewController *refindView = [[ReFindViewController alloc] init];
                refindView.phoneNumber = dict[@"map"][@"mobile"];
                [self.navigationController pushViewController:refindView animated:YES];
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
        if(self.telVcodeText.text.length == 6)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确格式的验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [self.phoneText resignFirstResponder];
    [self.telVcodeText resignFirstResponder];
}

- (IBAction)telVcodeBtn:(id)sender
{
    if(self.phoneText.text.length == 11)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
        
        [HUD show:YES];
        NSDictionary *param = @{@"mobile":self.phoneText.text,@"modelID":@"10006",@"userId":[[UserTool getUserID] length] ? [UserTool getUserID] : @"",@"voice":@"0"};
        
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)CountDown:(NSTimer *)timer
{
    secondsCountDown--;
    [self.telVcodeBt setEnabled:NO];
    [self.telVcodeBt setTitle:[NSString stringWithFormat:@"%d",secondsCountDown] forState:UIControlStateNormal];
    if (secondsCountDown == 0) {
        [timer invalidate];
        [self.telVcodeBt setTitle:@"点击获取" forState:UIControlStateNormal];
        self.telVcodeBt.enabled=YES;
        secondsCountDown=60;
    }
    
}
@end

//
//  registerViewController.m
//  yilong
//
//  Created by fcl on 15/3/26.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "registerViewController.h"
#import "loginViewController.h"
#import "YLQRcodeViewController.h"
#import "SYQRCodeViewController.h"

@interface registerViewController ()<UIWebViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *uvVerifyCode;
- (IBAction)btnVerfyCode:(id)sender;
- (IBAction)btnRegister:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *jumpWebView;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtComfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (weak, nonatomic) IBOutlet UITextField *txtInvitationCode;
- (IBAction)btnShaoYiShao:(id)sender;
- (IBAction)btnLogin:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UIButton *checkboxAgreement;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageview;

- (IBAction)btnXieYi:(id)sender;

- (IBAction)btnInvitationCode:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *InvitationCode;
@property (nonatomic,assign) BOOL isRegister;




@end

@implementation registerViewController


int secondsCountDown=60;//点击获取



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.btnCheckbox setImage:[UIImage imageNamed:@"image9"] forState:UIControlStateNormal];
    [self.btnCheckbox setImage:[UIImage imageNamed:@"image8"] forState:UIControlStateSelected];
    self.btnCheckbox.selected=YES;
    
    [self.btnCheckbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    self.jumpWebView.delegate=self;
    
    NSString *str=[htmlUrl stringByAppendingString:@"/jump.jsp"];

    [self loadWebPageWithString:str loadwebview:self.jumpWebView];

    self.navigationItem.title=@"注册";
    
    NSString *strRegisterVerifyCode=[htmlUrl stringByAppendingString:@"/register_validate.jsp"];
    
    UIImageView *PhoneIcon = [[UIImageView alloc] init];
    PhoneIcon.image = [UIImage imageNamed:@"image3"];
    
    
    PhoneIcon.bounds=CGRectMake(0, 0, 30, 30);
    
    PhoneIcon.contentMode = UIViewContentModeCenter;
    
    self.txtUserName.leftView = PhoneIcon;
    self.txtUserName.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    
    UIImageView *hintIcon = [[UIImageView alloc] init];
    hintIcon.image = [UIImage imageNamed:@"image2"];
    
    
    hintIcon.bounds=CGRectMake(0, 0, 30, 30);
    
    hintIcon.contentMode = UIViewContentModeCenter;
    
    self.txtVerifyCode.leftView = hintIcon;
    self.txtVerifyCode.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    UIImageView *hintIcon1 = [[UIImageView alloc] init];
    hintIcon1.image = [UIImage imageNamed:@"user_icon07"];
    
    
    hintIcon1.bounds=CGRectMake(0, 0, 30, 30);
    
    hintIcon1.contentMode = UIViewContentModeCenter;
    
    self.txtPassword.leftView = hintIcon1;
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [rightBtn setTitle:@"返回" forState:UIControlStateNormal];
    //[rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    [self  loadVerifyCode:self.uvVerifyCode webviewUrl:strRegisterVerifyCode];
    
    self.txtUserName.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.isRegister)
    {
        if(textField == self.txtUserName)
        {
            if(self.txtUserName.text.length != 11)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的11位手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                self.txtUserName.text = @"";
            }
        }
        if(textField == self.txtPassword)
        {
            if(self.txtPassword.text.length < 8||self.txtPassword.text.length > 16)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的密码格式，长度为8-16字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                self.txtPassword.text = @"";
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadVerifyCode:(UIWebView *)webview webviewUrl:(NSString *)webviewUrl
{
    //NSString *strloginVerifyCode=[htmlUrl stringByAppendingString:@"/login_validate.jsp"];
    [self loadWebPageWithString:webviewUrl loadwebview:webview];
    
}


- (void)loadWebPageWithString:(NSString*)urlString loadwebview:(UIWebView *)wview
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [wview loadRequest:request];
}

- (IBAction)btnVerfyCode:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    NSString *strRegisterVerifyCode=[htmlUrl stringByAppendingString:@"/register_validate.jsp"];
    [self  loadVerifyCode:self.uvVerifyCode webviewUrl:strRegisterVerifyCode];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    
   // NSString *homeDir = NSHomeDirectory();
    
    NSString *urlStr = request.URL.absoluteString;
    
    // 2.查找code=在urlStr中的范围
    

    NSRange rangeRegister= [urlStr rangeOfString:@"ios=register:"];//注册接口
    
    NSRange rangeSendMessage= [urlStr rangeOfString:@"ios=sendMessage:"];//验证码接口
    //NSRange range = [urlStr rangeOfString:@"login:"];
    
    if (rangeRegister.length) {
        // 4.截取code=后面的请求标记
        NSInteger loc = rangeRegister.location + rangeRegister.length;
        NSString *code = [urlStr substringFromIndex:loc];
        NSString *jsoncode=[self decodeString:code];
        NSLog(@"%@",jsoncode);
        
        
        NSData *jsonData = [jsoncode dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString *strStatus=[NSString stringWithFormat:@"%@",dic[@"status"]];
        NSString *strMessage=[NSString stringWithFormat:@"%@",dic[@"message"]];
        
        NSLog(@"strStatus%@",strStatus);
        if ([strStatus isEqualToString:@"0"]) {//注册失败
            
//            //显示验证码
//            
//            if ([strMessage  isEqualToString:t_codekeyword]||[strMessage  isEqualToString:t_codekeyword1]) {
//                //刷新加载验证码
//                
//                
//                [self insertUsername:self.txtusername];
//                
//                
//                [self.uvVerfyCode  setHidden:NO];
//                NSString *strloginVerifyCode=[htmlUrl stringByAppendingString:@"/login_validate.jsp"];
//                [self loadVerifyCode:self.verifyCodeView webviewUrl:strloginVerifyCode];
//            }
            
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息提示" message:strMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else//注册成功
        {
         //            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息提示" message:strMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
         //            [alert show];
            
            
            //[self.navigationController pushViewController:logcontroller animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
             //[self performSelector: @selector(pushLoginController) withObject: nil afterDelay:1.0f];
            [self.delegate LoginDelegate:self.txtUserName.text password:self.txtPassword.text];
        }
        
        return NO;
    }
    else if (rangeSendMessage.length) {
        // 4.截取code=后面的请求标记
        NSInteger loc = rangeSendMessage.location + rangeSendMessage.length;
        NSString *code = [urlStr substringFromIndex:loc];
        NSString *jsoncode=[self decodeString:code];
        NSLog(@"%@",jsoncode);
        
        
        NSData *jsonData = [jsoncode dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString *strSuccess=[NSString stringWithFormat:@"%@",dic[@"success"]];
        NSString *strErrorMsg=[NSString stringWithFormat:@"%@",dic[@"errorMsg"]];
        
       
        if ([strSuccess isEqualToString:@"0"]) {//获取验证码失败
             UIAlertView *alerview=[[UIAlertView alloc] initWithTitle:@"消息提示" message:strErrorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alerview  show];
        }
        else//获取验证码成功
        {
            
            self.InvitationCode.enabled=false;
            NSTimer  *countDownTimer;
            countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDown:) userInfo:nil repeats:YES];
            
            
            
        }
        
        
    }
    
    return YES;

    
}



-(void)pushLoginController
{
    
    [self.delegate LoginDelegate:self.txtUserName.text password:self.txtPassword.text];
    
}




-(void)CountDown:(NSTimer *)timer
{
    secondsCountDown--;
    [self.InvitationCode setTitle:[NSString stringWithFormat:@"%d秒",secondsCountDown] forState:UIControlStateNormal];
    if (secondsCountDown==0) {
        
        [timer invalidate];
        [self.InvitationCode setTitle:@"点击获取" forState:UIControlStateNormal];
        self.InvitationCode.enabled=YES;
        secondsCountDown=60;
    }

}




-(void)viewWillAppear:(BOOL)animated
{
  // self.bgImageview.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    
//    
//    
//    
//    UIImageView *PhoneIcon = [[UIImageView alloc] init];
//    PhoneIcon.image = [UIImage imageNamed:@"image3"];
//    
//    
//    PhoneIcon.bounds=CGRectMake(0, 0, 30, 30);
//    
//    PhoneIcon.contentMode = UIViewContentModeCenter;
//    
//    self.txtUserName.leftView = PhoneIcon;
//    self.txtUserName.leftViewMode = UITextFieldViewModeAlways;
//    
//    
//    
//    
//    UIImageView *hintIcon = [[UIImageView alloc] init];
//    hintIcon.image = [UIImage imageNamed:@"image2"];
//    
//    
//    hintIcon.bounds=CGRectMake(0, 0, 30, 30);
//    
//    hintIcon.contentMode = UIViewContentModeCenter;
//    
//    self.txtVerifyCode.leftView = hintIcon;
//    self.txtVerifyCode.leftViewMode = UITextFieldViewModeAlways;
//    
//    
//    
//    UIImageView *hintIcon1 = [[UIImageView alloc] init];
//    hintIcon1.image = [UIImage imageNamed:@"image2"];
//    
//    
//    hintIcon1.bounds=CGRectMake(0, 0, 30, 30);
//    
//    hintIcon1.contentMode = UIViewContentModeCenter;
//    
//    self.txtPassword.leftView = hintIcon1;
//    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//
//    
//    
////    //设置返回按钮
////    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]
////                                     initWithTitle:@""
////                                     style:UIBarButtonItemStylePlain
////                                     target:self
////                                     action:nil];
////    
////    
////    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:174.0/255.0 green:138/255.0 blue:82/255.0 alpha:1.0];
////    
////    self.navigationItem.backBarButtonItem = barButtonItem;
////    
//    
//    
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    // [rightBtn setTitle:@"返回" forState:UIControlStateNormal];
//    //[rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
    self.isRegister = YES;
}

-(void)back
{
    
       //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//URLDEcode
-(NSString *)decodeString:(NSString*)encodedString

{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}




-(void)checkboxClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}



//register(userName, password, comfirmPassword, invitationCode, verifyCode, agreement){
//    用户名，密码，重复密码，推荐码，验证码，是否同意协议("true"|"false")


- (IBAction)btnRegister:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    NSString *strcheckbox;
    if (self.checkboxAgreement.selected) {
        strcheckbox=@"true";
    }
    else
        if (!self.checkboxAgreement.selected) {
            strcheckbox=@"false";
        }
    ;
    
    if(self.txtUserName.text.length == 11&&self.txtPassword.text.length > 7&&self.txtPassword.text.length < 17)
    {
        if ([strcheckbox isEqualToString:@"true"]) {
            
        
//        NSString *strJS=[NSString stringWithFormat:@"register('%@','%@','%@','%@','%@');",self.txtUserName.text,self.txtPassword.text,self.txtInvitationCode.text,self.txtVerifyCode.text,strcheckbox];
//        
//        NSString *strLogin= [self.jumpWebView stringByEvaluatingJavaScriptFromString:strJS];
//        
//        NSLog(@"strlogin:%@",strLogin);
//            http://10.18.10.37:8091/registerForm.htm?message={"channel":"APP","params":{"code":"149793","comfirmPassword":"jianggeai","invitationCode":"abdces","modelID":"10001","password":"jianggeai","userName":"18651623528"},"sign":"55dc3ca110dffe7c813fe6d30b31e99e","version":"1.0"}
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"code":self.self.txtVerifyCode.text,
                                                                                            @"comfirmPassword":self.txtPassword.text,
                                                                                            @"modelID":@"10001",
                                                                                            @"password":self.txtPassword.text,
                                                                                            @"userName":self.txtUserName.text}];
        
            if (self.txtInvitationCode.text.length) {
                [params setObject:self.txtInvitationCode.text forKey:@"invitationCode"];
            }
            [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",@"http://10.18.10.37:8091",kUserRegisterForm] parameters:@{@"message":[StringHelper dictionaryToJson:[Tool getHttpParams:params]]} finishBlock:^(NSDictionary *dic) {
            
                if ([dic[@"success"] integerValue] == 1) {
                    [self hideHUD:@"注册成功"];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [UserTool saveLoginStatus:dic[@"map"][@"userDO"][@"id"] userName:dic[@"map"][@"userDO"][@"userName"] withTel:self.txtUserName.text];
                    
                }else
                    [self hideHUD:dic[@"errorMsg"]];


            } failure:^(NSError *NSError) {
                
                NSString *message= [Tool getErrorMsssage:NSError];
                [self hideHUD:message];
            }];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"必须遵守协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert  show];
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"请根据提示输入正确的内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert  show];
    }
   
}
- (IBAction)btnShaoYiShao:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    
        //扫描二维码
        SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
        qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        
        NSRange range = [qrString rangeOfString:@"regCode="];
        NSInteger loc = range.location + range.length;
        NSString *QRcode;
        if([qrString containsString:@"regCode="])
        {
            QRcode = [qrString substringFromIndex:loc];
            self.txtInvitationCode.text=QRcode;
        }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该二维码格式不正确，请扫描正确的二维码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        
        
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
      //  self.saomiaoLabel.text = @"fail~";
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
      //  self.saomiaoLabel.text = @"cancle~";
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
    
    
}

- (IBAction)btnLogin:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    loginViewController *logcontroller=[[loginViewController alloc]  init];
    [self.navigationController pushViewController:logcontroller animated:YES];
    
    
}

//代理传过来的邀请码
-(void)SetInvitationCode:(NSString *)InvitationCode
{
    self.txtInvitationCode.text=InvitationCode;
}

- (IBAction)btnXieYi:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ztrong.com/register_contract.htm"]];
    
}

- (IBAction)btnInvitationCode:(id)sender {
    if(self.txtUserName.text.length == 11)
    {
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];

        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"mobile":self.txtUserName.text,
                                                                                        @"modelID":@"10001",
                                                                                        @"voice":@"0"}];
        
        [self showHUD];
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kUserRegSendMessage] parameters:@{@"message":[StringHelper dictionaryToJson:[Tool getHttpParams:params]]} finishBlock:^(NSDictionary *dic) {
            
            if ([dic[@"success"] integerValue] == 1) {
                [self hideHUD:@"发送成功"];
                
                self.InvitationCode.enabled=false;
                NSTimer  *countDownTimer;
                countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDown:) userInfo:nil repeats:YES];

            }else
                [self hideHUD:dic[@"errorMsg"]];

        } failure:^(NSError *NSError) {
            
            NSString *message= [Tool getErrorMsssage:NSError];
            [self hideHUD:message];
        }];
//        NSString *strJS=[NSString stringWithFormat:@"sendMessage('%@');",self.txtUserName.text];
//        
//        NSString *strLogin= [self.jumpWebView stringByEvaluatingJavaScriptFromString:strJS];
//        NSLog(@"%@",strLogin);
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写确定的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.isRegister = NO;
}
@end

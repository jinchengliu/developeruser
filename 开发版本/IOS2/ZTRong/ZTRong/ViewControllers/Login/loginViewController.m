//
//  loginViewController.m
//  yilong
//
//  Created by fcl on 15/3/20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "loginViewController.h"
#import "FMDB.h"
#import "registerViewController.h"
#import "AppDelegate.h"
#import "ForgetViewController.h"
#import "MBProgressHUD.h"

//#import "ForgetPasswordViewController.h"

@interface loginViewController ()<UIWebViewDelegate>

- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *wv;

@property (weak, nonatomic) IBOutlet UIWebView *verifyCodeView;
@property (weak, nonatomic) IBOutlet UIView *uvVerfyCode;

@property(weak,nonatomic)  UIButton *btnRightIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageview;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic,copy)  NSString *imgVerifyUrl;

@property (nonatomic,copy)  NSString *isRegisterReturn;//是否是注册成功返回的
- (IBAction)refreshVerifyCode:(id)sender;

- (IBAction)UserNameChange:(id)sender;

- (IBAction)btnRegister:(id)sender;

- (IBAction)btnForgetPassWord:(id)sender;




@end

@implementation loginViewController
{
    AppDelegate *appdelegate;
    MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed=YES;
    // Do any additional setup after loading the view from its nib.
    appdelegate = [[UIApplication sharedApplication] delegate];
      
   self.navigationItem.title=@"登录";
    self.wv.delegate=self;
    [self OpenFMDB];
    
    self.txtpassword.delegate = self;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//如果webview没有网络加载失败的话
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HUD hide:YES];
    NSLog(@"错误");
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}






-(void)OpenFMDB
{
    // 0.获得沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Users.sqlite"];
    
    // 1.创建数据库实例对象
    self.db = [FMDatabase databaseWithPath:filename];
    
    // 2.打开数据库
    if ( [self.db open] ) {
        NSLog(@"数据库打开成功");
        
        // 创表                                                           t_users (username)
        BOOL result = [self.db executeUpdate:@"create table if not exists t_users (id integer primary key autoincrement, username text);"];
        
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    } else {
        NSLog(@"数据库打开失败");
    }


}




- (void)insertUsername:(NSString *)username
{
    
  //  NSString *sql=[NSString stringWithFormat:@"insert into t_users (username) values (%@);",username];
    // BOOL  b= [self.db executeUpdate:sql];
    
    BOOL b= [self.db executeUpdate:@"insert into t_users (username) values (?);", username];
    if(b){
        
    }
    
}


- (void)deleteUsername:(NSString *)username
{
   
    BOOL b= [self.db executeUpdate:@"delete from t_users where username=?;",username];
    if(b){
        
    }

}


- (NSMutableArray *)query
{
    NSMutableArray  *array=[NSMutableArray arrayWithCapacity:20];
    // 1.查询数据
    FMResultSet *rs = [self.db executeQuery:@"select * from t_users;"];
    
    // 2.遍历结果集
    while (rs.next) {
        //int ID = [rs intForColumn:@"id"];
        NSString *username = [rs stringForColumn:@"username"];
        //int age = [rs intForColumn:@"age"];
        [array  addObject:username];
        NSLog(@"%@",array);
    }
    return array;
}

- (void)loadWebPageWithString:(NSString*)urlString loadwebview:(UIWebView *)wview
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [wview loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
   // NSString *homeDir = NSHomeDirectory();
    [HUD hide:YES];
     NSString *urlStr = request.URL.absoluteString;
    
     // 2.查找code=在urlStr中的范围
     NSRange range = [urlStr rangeOfString:@"ios=login:"];
    //NSRange range = [urlStr rangeOfString:@"login:"];
    
     if (range.length) {
     // 4.截取code=后面的请求标记
     NSInteger loc = range.location + range.length;
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
         if ([strStatus isEqualToString:@"0"]) {//登陆失败
             
             //显示验证码
             
             if ([strMessage  isEqualToString:t_codekeyword]||[strMessage  isEqualToString:t_codekeyword1]) {
                 //刷新加载验证码
                
                 
                 [self insertUsername:self.txtusername.text];
                 
                
                 [self.uvVerfyCode  setHidden:NO];
                 NSString *strloginVerifyCode=[htmlUrl stringByAppendingString:@"/login_validate.jsp"];
                 [self loadVerifyCode:self.verifyCodeView webviewUrl:strloginVerifyCode];
                 
                 [self.confirmBtn setHidden:YES];
                 [self.RefindBtn setHidden:YES];
                 [self.resigerBtn setHidden:YES];
                 
                 [self.confirmBtn2 setHidden:NO];
                 [self.refindBtn2 setHidden:NO];
                 [self.resigerBtn2 setHidden:NO];
             }

             
             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息提示" message:strMessage delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
             [alert show];
             
             
         }
         else//登陆成功
         {
             if([dic[@"success"] intValue] == 0)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [alert show];
             }
             else
             {
                 [self.uvVerfyCode  setHidden:YES];
                 [self.confirmBtn setHidden:NO];
                 [self.RefindBtn setHidden:NO];
                 [self.resigerBtn setHidden:NO];
                 
                 [self.confirmBtn2 setHidden:YES];
                 [self.refindBtn2 setHidden:YES];
                 [self.resigerBtn2 setHidden:YES];
                 
                 NSLog(@"%d",self.btnRightIcon.selected);
                 if (self.btnRightIcon.selected) {
                     [self guidangwithUserName:self.txtusername.text];//记住用户名
                     [UserTool saveLoginStatus:dic[@"map"][@"userId"] userName:dic[@"map"][@"userName"] withTel:self.txtusername.text];
                 }
                 else
                 {
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString *docPath = [paths objectAtIndex:0];

//                     NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES)objectAtIndex:0];
                     
                     NSString *path = [docPath stringByAppendingPathComponent:@"saveUsername"];//
                     NSFileManager *fileManager = [NSFileManager defaultManager];
                     
                     [fileManager removeItemAtPath:path error:nil];//删除用户名和密码
                 
                 }
                 
                 if([self.isRegisterReturn isEqualToString:@"true"])//是注册成功返回来自动登录
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                     [self.delegate  GetIsRegiserRetun:@"true"];
                      BOOL saveSuccess=[self guidangwithUserName:self.txtusername.text password:self.txtpassword.text];
                     if(saveSuccess){
                         
                     }

                     [UserTool saveLoginStatus:dic[@"map"][@"userId"] userName:dic[@"map"][@"userName"] withTel:self.txtusername.text];
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
                 else  if([self.isLetter isEqualToString:@"true"])//是站内消息过来的
                 {
                 
                     [self.navigationController popViewControllerAnimated:YES];
                     [self.delegate GetIsLetter:@"true"];
                     self.isLetter=nil;
                    BOOL saveSuccess=[self guidangwithUserName:self.txtusername.text password:self.txtpassword.text];
                     if(saveSuccess){
                         
                     }
                     [UserTool saveLoginStatus:dic[@"map"][@"userId"] userName:dic[@"map"][@"userName"] withTel:self.txtusername.text];
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
                 else
                 {
                     [self deleteUsername:self.txtusername.text];
                     
                     [UserTool saveLoginStatus:dic[@"map"][@"userId"] userName:dic[@"map"][@"userName"] withTel:self.txtusername.text];
                     
                     if (_isFromIndex3) {
                         self.tabBarController.selectedIndex = 2;
                     }
                     if (_isFromWeb) {
                         [self.navigationController popViewControllerAnimated:YES];
                     }else
                         [self dismissViewControllerAnimated:YES completion:nil];
                     //解档用户名和密码，用于判断用户是否处于登陆状态而选择”我的“页面是否显示原生页面
                     BOOL saveSuccess=[self guidangwithUserName:self.txtusername.text password:self.txtpassword.text];
                     if(saveSuccess){
                         
                     }
                     //[self jiedang];
                 }
             }
             
         }
         
        return NO;
    }

    return YES;


}



-(void)loadVerifyCode:(UIWebView *)webview webviewUrl:(NSString *)webviewUrl
{
//    NSString *strloginVerifyCode=[htmlUrl stringByAppendingString:@"/login_validate.jsp"];
    [self loadWebPageWithString:webviewUrl loadwebview:webview];
}



-(void)viewWillAppear:(BOOL)animated
{

   // self.bgImageview.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.uvVerfyCode setHidden:YES];
    [self.confirmBtn2 setHidden:YES];
    [self.refindBtn2 setHidden:YES];
    [self.resigerBtn2 setHidden:YES];

    [self.confirmBtn setHidden:NO];
    [self.RefindBtn setHidden:NO];
    [self.resigerBtn setHidden:NO];
    
    UIImageView *PhoneIcon = [[UIImageView alloc] init];
    PhoneIcon.image = [UIImage imageNamed:@"image3"];

    
    PhoneIcon.bounds=CGRectMake(0, 0, 30, 30);
    
    PhoneIcon.contentMode = UIViewContentModeCenter;
    
    
    UIButton *rightIcon = [[UIButton alloc] init];
    [rightIcon setImage:[UIImage imageNamed:@"image7"] forState:UIControlStateNormal];
    [rightIcon setImage:[UIImage imageNamed:@"image6"] forState:UIControlStateSelected];
    [rightIcon addTarget:self action:@selector(rightIconH:) forControlEvents:UIControlEventTouchUpInside];

    rightIcon.bounds=CGRectMake(0, 0, 30, 30);
    
    rightIcon.contentMode = UIViewContentModeCenter;
    self.btnRightIcon=rightIcon;
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];

    
   // NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES)objectAtIndex:0];
    
    NSString *path = [docPath stringByAppendingPathComponent:@"saveUsername"];//
    
    NSMutableData *dataR = [[NSMutableData alloc]initWithContentsOfFile:path];//解档记住的用户名
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:dataR];
    
    NSString *Saveusername = [unarchiver decodeObjectForKey:@"Username"];
    
    
    if (Saveusername!=nil) {
        self.txtusername.text=Saveusername;
        [self.btnRightIcon setSelected:YES];
        
    }

    
    
    self.txtusername.leftView = PhoneIcon;
    self.txtusername.leftViewMode = UITextFieldViewModeAlways;
    rightIcon.selected=YES;
    
    self.txtusername.rightView=rightIcon;
    self.txtusername.rightViewMode=UITextFieldViewModeAlways;
    
    
    
    UIImageView *hintIcon = [[UIImageView alloc] init];
    hintIcon.image = [UIImage imageNamed:@"image2"];
    
    
    hintIcon.bounds=CGRectMake(0, 0, 30, 30);
    
    hintIcon.contentMode = UIViewContentModeCenter;
    
    self.txtpassword.leftView = hintIcon;
    self.txtpassword.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [rightBtn setTitle:@"返回" forState:UIControlStateNormal];
    //[rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
    //如果加载成功，传递参数
    NSString *strJS=[NSString stringWithFormat:@"login('%@','%@','%@');",self.txtusername.text,self.txtpassword.text,self.txtVerifyCode.text];
        //NSString *strJS=[NSString stringWithFormat:@"login('%@','%@','%@');",self.txtusername.text,self.txtpassword.text,@"2134"];
    NSString *strLogin= [self.wv stringByEvaluatingJavaScriptFromString:strJS];
    NSLog(@"%@",strLogin);
}


-(void)back
{
    if (_isFromWeb) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)rightIconH:(UIButton *)btn
{
    btn.selected=!btn.selected;
    NSLog(@"btn.selected:%d",btn.selected);
}


-(BOOL)guidangwithUserName:(NSString *)username password:(NSString *)password
{
    
    

    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    //对多个对象进行归档
    
    [archvier encodeObject:username forKey:@"Username"];
    [archvier encodeObject:password forKey:@"Password"];
    
    [archvier finishEncoding];
     return    [data writeToFile:[self filePath] atomically:YES];
    
}


-(BOOL)guidangwithUserName:(NSString *)username
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];

//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES)objectAtIndex:0];
    
    NSString *path = [docPath stringByAppendingPathComponent:@"saveUsername"];//记住用户名
    
    
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    //对多个对象进行归档
    
    [archvier encodeObject:username forKey:@"Username"];
    
    [archvier finishEncoding];
    return    [data writeToFile:path atomically:YES];
    
}








-(void)jiedang
{
    
    
    NSMutableData *dataR = [[NSMutableData alloc]initWithContentsOfFile:[self filePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:dataR];
    
    NSString *username = [unarchiver decodeObjectForKey:@"Username"];
    NSString *password = [unarchiver decodeObjectForKey:@"Password"];
    
    [unarchiver finishDecoding];
    NSLog(@"%@,%@",username,password);
    
}



-(NSString *)filePath

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    
    NSString *path = [docPath stringByAppendingPathComponent:@"UserInfo"];
        return path;
    
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

- (void)recoverBtn

{
    self.view.userInteractionEnabled = YES;
}




- (IBAction)login:(id)sender {
    
    [HUD show:YES];
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    //点击确认的时候加载webview，来判断是否可以加载成功
    NSString *str=[htmlUrl stringByAppendingString:@"/jump.jsp"];
    // NSURLRequest  *urlrequest=[NSURLRequest requestWithURL:[NSURL  URLWithString:str]];
    //self.requesturl=urlrequest;
    [self loadWebPageWithString:str loadwebview:self.wv];
}

- (IBAction)refreshVerifyCode:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    NSString *strloginVerifyCode=[htmlUrl stringByAppendingString:@"/login_validate.jsp"];
    [self loadVerifyCode:self.verifyCodeView webviewUrl:strloginVerifyCode];
}

- (IBAction)UserNameChange:(id)sender {
    
    NSMutableArray *array=[self  query];
    
    NSLog(@"array:-----%@",array);
    if ([array containsObject:self.txtusername.text]) {
        [self.uvVerfyCode  setHidden:NO];
        NSString *strloginVerifyCode=[htmlUrl stringByAppendingString:@"/login_validate.jsp"];
        [self loadVerifyCode:self.verifyCodeView webviewUrl:strloginVerifyCode];
        
        [self.confirmBtn setHidden:YES];
        [self.RefindBtn setHidden:YES];
        [self.resigerBtn setHidden:YES];
        
        [self.confirmBtn2 setHidden:NO];
        [self.refindBtn2 setHidden:NO];
        [self.resigerBtn2 setHidden:NO];

    }
    else
    {   [self.uvVerfyCode  setHidden:YES];
        
        [self.confirmBtn setHidden:NO];
        [self.RefindBtn setHidden:NO];
        [self.resigerBtn setHidden:NO];
        
        [self.confirmBtn2 setHidden:YES];
        [self.refindBtn2 setHidden:YES];
        [self.resigerBtn2 setHidden:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.txtpassword)
    {
        NSMutableArray *array=[self  query];
        
        NSLog(@"array:-----%@",array);
        if ([array containsObject:self.txtusername.text]) {
            [self.uvVerfyCode  setHidden:NO];
            NSString *strloginVerifyCode=[htmlUrl stringByAppendingString:@"/login_validate.jsp"];
            [self loadVerifyCode:self.verifyCodeView webviewUrl:strloginVerifyCode];
            
            [self.confirmBtn setHidden:YES];
            [self.RefindBtn setHidden:YES];
            [self.resigerBtn setHidden:YES];
            
            [self.confirmBtn2 setHidden:NO];
            [self.refindBtn2 setHidden:NO];
            [self.resigerBtn2 setHidden:NO];
            
        }
        else
        {   [self.uvVerfyCode  setHidden:YES];
            
            [self.confirmBtn setHidden:NO];
            [self.RefindBtn setHidden:NO];
            [self.resigerBtn setHidden:NO];
            
            [self.confirmBtn2 setHidden:YES];
            [self.refindBtn2 setHidden:YES];
            [self.resigerBtn2 setHidden:YES];
        }
    }
}




- (IBAction)btnRegister:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    registerViewController *registercontroller=[[registerViewController alloc] init];
    registercontroller.delegate=self;
    [self.navigationController pushViewController:registercontroller animated:YES];
}

- (IBAction)btnForgetPassWord:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];

    ForgetViewController *forgetview = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:forgetview animated:YES];
}



//注册成功自动登录
-(void)LoginDelegate:(NSString *)value password:(NSString *)password
{
    
    self.txtusername.text=value;
    self.txtpassword.text=password;
    
    self.isRegisterReturn=@"true";
    NSString *strJS=[NSString stringWithFormat:@"login('%@','%@','%@');",value,password,@""];//验证码随便填
    //NSString *strJS=[NSString stringWithFormat:@"login('%@','%@','%@');",self.txtusername.text,self.txtpassword.text,@"2134"];
    NSString *strLogin= [self.wv stringByEvaluatingJavaScriptFromString:strJS];
    
    NSLog(@"strlogin:%@",strLogin);

}

//判断当前是否有网络
-(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

@end

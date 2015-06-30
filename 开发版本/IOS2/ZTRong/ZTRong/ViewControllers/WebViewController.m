//
//  WebViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "WebViewController.h"
#import "loginViewController.h"
#import "investManagerViewController.h"
#import "SharePopup.h"

@interface WebViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UIWebView *_webView;
    
    NSString *erweimaURL;

}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.opaque=NO;
    _webView.backgroundColor=[UIColor clearColor];
    
    if (_isFromMiaosha) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[[UserTool getUserID] length] ? [UserTool getUserID] : @""}];
        
        _url = [NSString stringWithFormat:@"%@/activity/seckillActivities.htm?message=%@",htmlUrl,[StringHelper dictionaryToJson:[Tool getHttpParams:dic]]];
    }
    //网页
    _url = [_url stringByReplacingOccurrencesOfString:@" " withString:@" "];    //url修改了两次  第二不能刷新原来页面
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [_webView reload];
}
#pragma mark -
#pragma mark - UserAction

- (IBAction)backClick:(UIBarButtonItem *)sender {
    
    if (_webView.canGoBack && !_isFromBanner) {
        [_webView goBack];
    }else{
        if (_isFromHome) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else
            [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;

    NSRange rangeInvestHistory = [urlStr rangeOfString:@"ios=returnInvestHistory"];
    NSRange rangeContinueInvest = [urlStr rangeOfString:@"ios=continueInvest"];
    NSRange rangeCharge = [urlStr rangeOfString:@"ios=toCharge"];
    NSRange rangeSeckillLogin = [urlStr rangeOfString:@"ios=seckillPageLogin"];
    NSRange rangeSeckillInvest = [urlStr rangeOfString:@"ios=seckillPageToInvest"];
    NSRange rangePromotion = [urlStr rangeOfString:@"ios=promotion"];
    NSRange rangeToInvest = [urlStr rangeOfString:@"ios=bestPageToInvest"];
    
    if (rangeInvestHistory.length) {
        //跳转查看投资记录
        //投资管理
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        investManagerViewController *view = [sb instantiateViewControllerWithIdentifier:@"investManagerViewController"];
        view.isFromWebView = YES;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
        return NO;
    }else if (rangeContinueInvest.length){
        //跳转继续投资
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }else if (rangeCharge.length){
        //跳转充值
        [Tool pushToRecharge:self.navigationController];
        return NO;
    }else if (rangeSeckillLogin.length){
        //天天秒登录
        loginViewController *loginView = [[loginViewController alloc] init];
        loginView.isFromWeb = YES;
        [self.navigationController pushViewController:loginView animated:YES];
        return NO;
    }else if (rangeSeckillInvest.length){
        //天天秒去投资
        UITabBarController *tab = (UITabBarController *) self.navigationController.presentingViewController;
        tab.selectedIndex = 0;
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }else if (rangePromotion.length){

//        if ([UserTool userIsLogin]) {
//            NSDictionary *param = @{@"userId":[UserTool getUserID],@"device":@"IOS"};
//            NSString *str = [StringHelper dicSortAndMD5:param];
//            NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
//            
//            [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/invitationCode.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
//                if([dict[@"success"] intValue] == 1)
//                {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享好友" message:@"\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
//                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, alertController.view.frame.size.width, 1)];
//                    erweimaURL = dict[@"map"][@"invitation"];
//                    image.backgroundColor = [UIColor lightGrayColor];
//                    
//                    [self setAlertControl:alertController];
//                    [alertController.view addSubview:image];
//                    [alertController addAction:cancleAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                }
//                else
//                {
//                    
//                }
//
//                
//                
//            } failure:^(NSError *NSError) {
//                
//                NSString *message= [Tool getErrorMsssage:NSError];
//                
//                NSLog(@"%@",message);
//                
//            }];
        
//
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你还没有登录，请问是否需要登录？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//            [alert show];
//        }
        SharePopup *popup=[[SharePopup  alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        popup.sharecontent=@"中投融分享测试";
        popup.shareImage=[UIImage imageNamed:@"banner_01@2x.jpg"]; //图片2选1
        popup.shareURL= @"https://www.baidu.com";
        popup.rootViewController = self;
        
        [popup showInView:self.tabBarController.view MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
            
            
        }];
        
        return NO;

    }else if (rangeToInvest.length){
        UITabBarController *tab = (UITabBarController *) self.navigationController.presentingViewController;
         tab.selectedIndex = 0;
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;

    }

    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;{

    NSString *JsToGetHTMLSource = @"document.body.innerHTML";
    NSString *pageSource = [webView stringByEvaluatingJavaScriptFromString:JsToGetHTMLSource];
    NSLog(@"pagesource:%@", pageSource);
}
- (void)setAlertControl:(UIAlertController *)alertController{
    
    UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(alertController.view.bounds.size.width/2-40, 50, 80, 80)];
    [button6 setImage:[UIImage imageNamed:@"share_icon15"] forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(shareErweima) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(button6.frame.origin.x-10, 135, 100, 20)];
    label6.font = [UIFont fontWithName:nil size:14];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.text = @"二维码";
    [alertController.view addSubview:button6];
    [alertController.view addSubview:label6];
}
- (void)shareErweima
{
    [self dismissViewControllerAnimated:YES completion:nil];

    WebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:@"web"];
//    UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:web];
    
//    nc.navigationBar.barStyle = UIStatusBarStyleDefault;
//    [nc.navigationBar setTintColor:[UIColor whiteColor]];
    web.title = @"二维码分享";
    web.url = erweimaURL;
//    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
//    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        loginViewController *lcv=[[loginViewController alloc] init];
        lcv.isFromWeb = YES;
        [self.navigationController pushViewController:lcv animated:YES];
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

@end

//
//  AppDelegate.m
//  ZTRong
//
//  Created by 李婷 on 15/5/11.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initShareSDK];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:39.0f/255.0f green:15.0f/255.0f blue:8.0f/255.0f alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    if(kAppHeight > 480){
        self.autoSizeScaleX = kAppWidth/320.0;
        self.autoSizeScaleY = kAppHeight/568.0;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }

//    [[ShareUitl ShareInstrance] doShare:[Tool getShareDate:[NSString stringWithFormat:@"%@",
//                                                            @"中投融转发测试"]]   image:[UIImage imageNamed:@"banner_01@2x.jpg"] url:@"https://www.baidu.com" ShareType:ShareUitl_QQzq finishBlock:^{
//        // [Tool showerrorLabelView:@"好友分享成功!" rootView:self.view superController:self];
//        NSLog(@"分享成功");
//    } faildBlock:^(NSError *error){
//        //[Tool showerrorLabelView:[error domain] rootView:self.view superController:self];
//        
//        NSLog(@"%@",[error domain]);
//    }];

    return YES;
}
void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告======== name:%@ reason: %@ callStackSymbols: %@",name,reason,[callStack componentsJoinedByString:@" "]];
    NSLog(@"%@",content);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}









//初始化ShareSDK


-(void)initShareSDK{
    
   //  NSLog(@"%@",[[ASIdentifierManager sharedManager] advertisingIdentifier]);
    // [ShareSDK registerApp:@"5559f92aa230"];
    [ShareSDK registerApp:ShareSDKAppkey];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:ShareSDKAppkey];
    //新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:SinaWeibo_AppKey appSecret:SinaWeibo_AppSecret redirectUri:SinaWeibo_AppRedirectURI];
    
    //腾讯微博
    //    [ShareSDK connectTencentWeiboWithAppKey:TencentWeibo_APP_KEY
    //                                  appSecret:TencentWeibo_APP_SECRET
    //                                redirectUri:TencentWeibo_REDIRECT_URL
    //                                   wbApiCls:[WeiboApi class]];
    
   // [ShareSDK connectTencentWeiboWithAppKey:TencentWeibo_APP_KEY appSecret:TencentWeibo_APP_SECRET redirectUri:TencentWeibo_REDIRECT_URL];
    //腾讯微博
  //  [ShareSDK connectTencentWeiboWithAppKey:TencentWeibo_APP_KEY appSecret:TencentWeibo_APP_SECRET redirectUri:TencentWeibo_REDIRECT_URL];
    
    
    //qq空间
    [ShareSDK connectQZoneWithAppKey:kQQAppKey appSecret:kQQAppSecret];
    
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:kQQAppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
   
    //微信
    //[WXApi registerApp:@"wxcea9004022eb8127"];
    //      [WXApi registerApp:WeiXin_AppID];
       //   [ShareSDK connectWeChatWithAppId:WeiXin_AppID wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:WeiXin_AppID appSecret:WeiXin_AppKey wechatCls:[WXApi class]];
    
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
    //                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
    //                           wechatCls:[WXApi class]];
    
    
    //连接短信分享
   // [ShareSDK connectSMS];
    //连接邮件
   // [ShareSDK connectMail];
    
    
    
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    NSString *stringUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //     DebugLog(@"sourceApplication_stringUrl = %@",stringUrl);
    //    BOOL isHandOpenURL = NO;
    //    if([stringUrl rangeOfString:@"sinaweibosso"].location != NSNotFound){
    //        isHandOpenURL =  [WeiboSDK handleOpenURL:url delegate:self];
    //        return isHandOpenURL;
    //    }
    
    // return isHandOpenURL;
    //[ShareSDK connectWeChatWithAppId:WeiXin_AppID wechatCls:[WXApi class]];
   
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSString *stringUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
   // DebugLog(@"sourceApplication_stringUrl = %@",stringUrl);
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        BOOL isHandOpenURL = NO;
        if([stringUrl rangeOfString:SinaWeibo_AppKey].location != NSNotFound){
            if ([stringUrl rangeOfString:@"sinaweibosso"].location != NSNotFound) {
                isHandOpenURL = [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
//                [[SinaManager ShareInstrance].sinaweibo handleOpenURL:url];
                return isHandOpenURL;
            }else{
                isHandOpenURL = [WeiboSDK handleOpenURL:url delegate:self];
                return isHandOpenURL;
            }
        }
    }
    
    
    // return isHandOpenURL;
    // [ShareSDK connectWeChatWithAppId:WeiXin_AppID wechatCls:[WXApi class]];
    return [ShareSDK handleOpenURL:url   sourceApplication:sourceApplication   annotation:annotation
                        wxDelegate:self];
}




#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}



#pragma mark 新浪微博SDK 
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
      //  NSDate *creationDate = [NSDate date];
        NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
        [item setObject:[NSNumber numberWithBool:YES] forKey:@"hasAuthToken"];
//        [item setObject:StringWithFormat(@"%@",[(WBAuthorizeResponse *)response accessToken])
//                 forKey:@"access_token"];
//        [item setObject:StringWithFormat(@"%@",[(WBAuthorizeResponse *)response userID])
//                 forKey:@"uid"];
//        [item setObject:StringWithFormat(@"%@",[NSNumber numberWithDouble:[[(WBAuthorizeResponse *)response expirationDate] timeIntervalSinceDate:creationDate]])
//                 forKey:@"expirationDate"];
//        [item setObject:StringWithFormat(@"%@",[shareWeiBo UserShow:SinaSource access_token:[(WBAuthorizeResponse *)response accessToken] uid:[(WBAuthorizeResponse *)response userID]]) forKey:@"username"];
//        [item setObject:StringWithFormat(@"%@",[shareWeiBo createTimeInit:creationDate]) forKey:@"create_at"];
//        [item setObject:StringWithFormat(@"%@",nil) forKey:@"openkey"];
//        [item setObject:StringWithFormat(@"%@",SinaSource) forKey:@"source"];
        
       // [shareWeiBo writeToPlist:item isBoundSource:NO];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.1 * 1000ull) * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kSSOAuthorisationDomeNotification object:nil];
//        
//    });
}





@end

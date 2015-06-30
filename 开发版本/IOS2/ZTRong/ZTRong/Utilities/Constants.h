//
//  Constants.h
//  NewProduct
//
//  Created by fly on 13-4-9.
//  Copyright (c) 2013年 Lee. All rights reserved.
//



#import "Tool.h"

// URL
//#define     serviceURL       @"http://10.18.11.236:8080/app           //
//#define     serviceURL        [[NSUserDefaults standardUserDefaults]objectForKey:@"serviceURL"]




/********************************************************************
 *
 *  常用颜色值
 *
 *  Created by ysy on 15-5-21.
 *
 ********************************************************************/
#define BACKGROUNDCOLOR         ([UIColor whiteColor])
#define NAVBACKGROUNDCOLOR      ([UIColor colorWithRed:255/255.0 green:0/255. blue:0/255.0 alpha:1])
#define ButtonBG                ([UIColor colorWithRed:179/255.0 green:141/255. blue:79/255.0 alpha:1])


#define LOWRED                  ([UIColor colorWithRed:241/255.0 green:241/255. blue:241/255.0 alpha:1])
#define FOINTRED                ([UIColor colorWithRed:243/255.0 green:106/255. blue:79/255.0 alpha:1])
#define CUSTOMCOLOR(R,G,B)      ([UIColor colorWithRed:(R)/255.0 green:(G)/255. blue:(B)/255.0 alpha:1])
#define LandBackGroundColor     ([UIColor colorWithRed:(88)/255.0 green:(129)/255. blue:(234)/255.0 alpha:1])




/********************************************************************
 *
 *  http请求
 *
 *  Created by ysy on 15-5-21.
 *
 ********************************************************************/
// 充值
#define kCmdidentityAuth              @"/user/identityAuthForm.htm"         //验证实名（身份证）
#define kCmdbankVerify                @"/user/bankVerify.htm"               //绑定银行卡
#define kCmdUserBankList              @"/user/queryUserBankList.htm"        //获取银行卡列表
#define kCmdqueryBankVerify           @"/user/queryBankVerify.htm"          //认证银行卡
#define kCmdbankSendSMS               @"/user/bankSendSMS.htm"              //银行卡验证码
#define KCmdrecharge                  @"/recharge/recharge.htm"             //充值
#define KCmdrechargeRecords           @"/user/rechargeRecords.htm"          //充值记录
#define KCmdgetUserIdentity           @"/user/getUserIdentityCard.htm"      //获取用户实名信息
#define KCmdbankCardAuth              @"/user/bankCardAuth.htm"             //获取银行列表信息

//提现
#define kCmddeposit                   @"/user/deposit.htm"                 //进入提现界面
#define kCmddepositForm               @"/user/depositForm.htm"             //提现
#define kCmdreflectRecords            @"/user/reflectRecords.htm"          //提现记录
#define KCmdqueryUseDepositAmount     @"/user/queryUseDepositAmount.htm"   //提现最大限额
#define KCmdfindSendMessage           @"/findSendMessage.htm"              //app短信认证

//首页
#define kHome                         @"/indexStatic.htm"                  //首页信息


//在线投资
#define kInvestItemStatic             @"/itemStatic.htm"                   //投资详情
#define kInvestConfirmInvestCheck     @"/confirmInvestCheck.htm"           //订单验证
#define kInvestIndex                  @"/investIndex.htm"                  //投资首页利率
#define kInvestItemList               @"/itemList.htm"                     //投资列表

//我的
#define kUserIndex                    @"/user/index.htm"                   //账户首页
#define kUserRedEnvelope              @"/user/redEnvelope.htm"             //红包列表
#define kUserAwards                   @"/user/awards.htm"                  //奖励明细
#define kUserPromotionUser            @"/user/myPromotionUser.htm"         //分享用户
#define kUserRegisterForm             @"/registerForm.htm"                 //注册
#define kUserRegSendMessage           @"/regSendMessage.htm"               //注册短信验证码

/********************************************************************
 *
 *  系统相关
 *
 *  Created by ysy on 15-5-21.
 *
 ********************************************************************/
#define gRootVC                     ([UIApplication sharedApplication].keyWindow.rootViewController)
#define gkeyWindow                  ([UIApplication sharedApplication].keyWindow)
#define GET_CURRENT_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APPDELEGATE ((AppDelegate *)([[UIApplication sharedApplication] delegate]))
#define StringWithFormat(format,str)   ([NSString stringWithFormat:format,str])
#define PathBox                 ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents"])
#define HOMEIMGPATH             ([NSString stringWithFormat:@"%@/Documents/%@", NSTemporaryDirectory(), @"HomeImgs"])


#define  errorMessage           @"服务端未知错误"




/********************************************************************
 *
 *  分享相关
 *
 *  Created by ysy on 15-6-2.
 *
 ********************************************************************/

//微信 朋友圈
//#define WeiXin_AppID                        @"wx4868b35061f87885"
//#define WeiXin_AppKey                       @"64020361b8ec4c99936c0e3999a9f249"
//[ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                       wechatCls:[WXApi class]];

#define WeiXin_AppID                        @"wx55eb11b22cf71829"     //中投融
#define WeiXin_AppKey                       @"f0076fa9da3325528ff9395a68ba7ce8"





//qq  空间
//#define kQQAppKey                           @"100485012"    //old
//#define kQQAppSecret                        @"5179fdadd76849e550a0f29d1d43c218"

#define kQQAppKey                           @"1104661092"     //中投融
#define kQQAppSecret                        @"enJcOW5r1TFOOvoB"

//腾讯微博
#define TencentWeibo_APP_KEY                @"801376826"
#define TencentWeibo_APP_SECRET             @"9d0de2511c8b3f5816dd0e4f259d451f"
#define TencentWeibo_REDIRECT_URL           @"http://www.ztrong.com"

//新浪微博
//#define SinaWeibo_AppKey                    @"537037623"
//#define SinaWeibo_AppSecret                 @"10d7c9d7cde6a1296440e9ca69887aaa"
//#define SinaWeibo_AppRedirectURI            @"http://www.zhuanlingyong.com"

#define SinaWeibo_AppKey                    @"3903912145"       //中投融
#define SinaWeibo_AppSecret                 @"abdf69c0b5ffbf4622a206586d6d2e0d"
#define SinaWeibo_AppRedirectURI            @"http://www.ztrong.com"


//ShareSDK
//#define ShareSDKAppkey                      @"3e55cb6e464e"
//#define ShareSDKAppSecret                   @"6b5c23a1a59e965ad1cd2924799a90e7"

#define ShareSDKAppkey                      @"7e7b67c1a7f8"             //中投融
#define ShareSDKAppSecret                   @"8319d5101c5f193bb5e195953db9cc88"





//
//  ShareUitl.h
//  ShareTest
//
//  Created by ysy on 14-10-21.
//  Copyright (c) 2014年 ysy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "Constants.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/NSString+Common.h>
#import <ShareSDK/ShareSDK.h>
#import <MessageUI/MessageUI.h>
#import  "WeiboApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "ShareDate.h"

#define SHARE_TITLE @"中投融"
#define StringWithFormat(format,str)   ([NSString stringWithFormat:format,str])
typedef enum {
    ShareUitl_Sina,             //新浪微博
    ShareUitl_WX,               //微信
    ShareUitl_WXQ,              //微信朋友圈
    ShareUitl_QQ,               //qq
    
    ShareUitl_QQzq,             //qq空间
    ShareUitl_TencentWeibo,     //腾讯微博
    ShareUitl_SMS,              //短信
    ShareUitl_email,            //邮件
    ShareUitl_Copy,             //复制
    ShareUitl_Error             //错误

} ShareUitl_ShareType;



typedef void (^ShareFinishBlock)(void);//无返回值,无入参的block,应用在大多数位置
typedef void (^ShareDICFinishBlock)(NSDictionary *dic);//NSDictionary,无入参的block,返回第三方信息
typedef void (^ShareFaildBlock)(NSError *error);//无返回值,入参无为型

@interface ShareUitl : NSObject <ISSShareViewDelegate>

//初始化ShareSDK
+(ShareUitl *)ShareInstrance;


//分享入口
//代码示例
//[[ShareUitl ShareInstrance] doShare:[Tool getShareDate:[NSString stringWithFormat:@"%@",
//                                                        @"中投融转发测试"]]   image:[UIImage imageNamed:@"banner_01@2x.jpg"] url:@"https://www.baidu.com" ShareType:ShareUitl_QQ finishBlock:^{
//    // [Tool showerrorLabelView:@"好友分享成功!" rootView:self.view superController:self];
//    NSLog(@"分享成功");
//} faildBlock:^(NSError *error){
//    //[Tool showerrorLabelView:[error domain] rootView:self.view superController:self];
//    
//    NSLog(@"%@",[error domain]);
//}];


//
// content  分享的内容 ;    image 分享的图片 可以为nil  ;url 分享的链接 可以为nil ; type 分享类型 ; finishBlock 成功回调 ;faildBlock 失败回调
-(void)doShare :(ShareDate *)sd image :(UIImage *) image url :(NSString *) url ShareType :(ShareUitl_ShareType) type
   finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock;




// content  分享的内容 ;    image 分享的网络图片  ;url 分享的链接 可以为nil ; type 分享类型 ; finishBlock 成功回调 ;faildBlock 失败回调
-(void)doShare :(ShareDate *)sd URLimage :(NSString *) imageurl url :(NSString *) url ShareType :(ShareUitl_ShareType) type
   finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock;




//判断是否授权
+(BOOL) hasAuthorizedWithType:(ShareUitl_ShareType) type;


//获取授权信息
+(void)getCredentialWithType:(ShareUitl_ShareType) type  finishBlock : (ShareDICFinishBlock) finishBlock;


//授权
+(void) getUserInfoWithType :(ShareUitl_ShareType) type finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock;


//取消授权
+(void) cancelAuthWithType:(ShareUitl_ShareType) type;



-(BOOL)isQQInstalled;

@end

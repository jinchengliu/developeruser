//
//  Tool.h
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTRMajorViewController.h"
#import "UIButton+Block.h"
#import "NSString+MaskString.h"
#import "AFNetworking.h"
#import "ZTRHTTPOperation.h"
#import "SheetPicker.h"
#import "Constants.h"
#import "ShareUitl.h"
#import "ShareDate.h"
#import "UIAlertView+Block.h"
#import "AddressDBUitl.h"


@interface Tool : NSObject



typedef void (^ZTRFinishBlock)(NSInteger i);// 成功完成回调 返回nsinteger
typedef void (^ZTRdoFinishBlock)(void) ;// 成功完成回调
typedef void (^RequestFinish)(NSDictionary *dic);// 请求成功回调
typedef void (^RequestFailed)(NSError *NSError);//  请求失败回调



typedef enum : NSInteger
{
    Recharge,                                                               //充值
    Withdrawals  = 1001,                                                   //提现
}  RechargeType;



//通过颜色创建图片
+(UIImage *)createImageWithColor:(UIColor *)color;
//通过图片创建颜色
+(UIColor *)createColorWithImage:(UIImage *)image;

//通过16进制颜色值创建颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;


+(void)showerrorLabelView :(NSString *) message rootView :(UIView *) rootView  superController :(UIViewController *) superController;
////计算文本高度
//+(float) calculateHeight:(NSString*)content separated:(NSString*)separatedString font:(UIFont*)textFont width:(float)textWidth;
//
//
////计算textView的高度
//+ (float) heightForTextView:(float)textWidth font:(UIFont*)textFont
//                   WithText: (NSString *) strText;
//
//
////计算文本长度
//+(float) calculateWidth:(NSString*)content separated:(NSString*)separatedString font:(UIFont*)textFont;


//是否包含字符
+(BOOL)stringHasRange:(NSString *)string  range:(NSString *)range;

//当前是否有网络
+(BOOL) hasNetWork ;

////http post请求 现基于afnetwork
//+(void)ZTRPostRequest :(NSString *)url parameters :(NSDictionary *) param
//          finishBlock:(RequestFinish)success
//              failure:(RequestFailed)failure;
//// 获取网络错误信息  基于 afnetwork的error


#pragma mark- post请求
+(void)ZTRPostRequest :(NSString *)url  parameters :(NSDictionary *) param
         finishBlock:(RequestFinish)finishBlock
             failure:(RequestFailed)faledBlock;

+(NSString *)getErrorMsssage :(NSError *)error;


//封装HTTP请求的参数
+(NSMutableDictionary  *)getHttpParams :(NSMutableDictionary *)params;


//跳转到充值
+(void)pushToRecharge :(UIViewController *)nvc;



//跳转到提现
+(void)pushToWithdrawals :(UIViewController *)nvc;


#pragma mark - 初始化分享数据对象
+(ShareDate *) getShareDate:(NSString*) content;
//返回日期格式
+(NSString *)dateFormatter :(NSDate *)date;


//快捷UiLable
+(UILabel *)createLable :(UIColor *)stringColor font :(float)font frame:(CGRect)frame;

//正则验证
+(BOOL)isRegex :(NSString *)regex  string:(NSString *)string;


@end

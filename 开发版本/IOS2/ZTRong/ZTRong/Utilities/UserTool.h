//
//  UserTool.h
//  ZTRong
//
//  Created by 李婷 on 15/5/22.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTool : NSObject

/**
 *  保存用户信息
 *
 *  @param userID   用户ID
 *  @param username 用户名
 */
+ (void)saveLoginStatus:(NSString *)userID userName:(NSString *)username withTel:(NSString *)tel;
//注销用户登录状态
+ (void)logOffLogin;
//用户是否登录
+ (BOOL)userIsLogin;
//获取用户ID
+ (NSString *)getUserID;
//获取用户名
+ (NSString *)getUserName;
//获取电话号码
+ (NSString *)getTel;
@end

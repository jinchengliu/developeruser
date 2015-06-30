//
//  UserTool.m
//  ZTRong
//
//  Created by 李婷 on 15/5/22.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "UserTool.h"

@implementation UserTool

//保存用户登录状态
+ (void)saveLoginStatus:(NSString *)userID userName:(NSString *)username withTel:(NSString *)tel{

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginStatus];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:userId];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:UserName];
    [[NSUserDefaults standardUserDefaults] setObject:tel forKey:Telphone];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
//注销用户登录状态
+ (void)logOffLogin{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LoginStatus];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Telphone];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
//用户是否登录
+ (BOOL)userIsLogin{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:LoginStatus];
    }else
        return NO;
    
}
//获取用户ID
+ (NSString *)getUserID{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:userId];
    
}
//获取用户名
+ (NSString *)getUserName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
}
//获取电话号码
+ (NSString *)getTel{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:Telphone];
}
@end

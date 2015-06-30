//
//  AppDelegate.h
//  ZTRong
//
//  Created by 李婷 on 15/5/11.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "ShareUitl.h"
#import <ShareSDK/ShareSDK.h>
//#import  <AdSupport/AdSupport.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property float autoSizeScaleX;       //用于适配的长宽比
@property float autoSizeScaleY;       

@end


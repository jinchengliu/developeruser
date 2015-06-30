//
//  WebViewController.h
//  ZTRong
//
//  Created by 李婷 on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface WebViewController : UIViewController
@property (nonatomic, strong) NSString *url;
@property (nonatomic) BOOL isFromHome;
@property (nonatomic) BOOL isFromMiaosha;
@property (nonatomic) BOOL isFromBanner;
@end

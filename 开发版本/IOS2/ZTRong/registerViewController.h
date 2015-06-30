//
//  registerViewController.h
//  yilong
//
//  Created by fcl on 15/3/26.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 定义协议，用来实现传值代理
 */
@protocol registerViewControllerDelegate <NSObject>

/**
 此方为必须实现的协议方法，用来传值
 */
- (void)LoginDelegate:(NSString *)value  password:(NSString *)password;

@end

@interface registerViewController : UIViewController
@property (nonatomic, unsafe_unretained) id<registerViewControllerDelegate> delegate;
@end

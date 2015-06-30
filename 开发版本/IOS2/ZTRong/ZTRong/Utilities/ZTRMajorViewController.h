//  输入法回收
//  ZTRMajorViewController.h
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"



typedef enum : NSInteger
{
    kNavigation,                                                           //导航条进入  默认
    kpresent=1001,                                                       //模态进入
}  popType;

@interface ZTRMajorViewController : UIViewController<UIGestureRecognizerDelegate>


@property(nonatomic) popType type;
@property(nonatomic,strong)MBProgressHUD *HUD;

-(void)backAction;

-(void)showHUD;


-(void)hideHUD:(NSString *)error;

@end

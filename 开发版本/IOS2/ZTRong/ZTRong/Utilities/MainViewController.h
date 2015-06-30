//
//  MainViewController.h
//  ZTRong
//
//  Created by 李婷 on 15/5/22.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ZTRMajorViewController.h"

@interface MainViewController : UITableViewController<UIGestureRecognizerDelegate>


@property(nonatomic) popType type;
@property(nonatomic,strong)MBProgressHUD *HUD;

-(void)backAction;

-(void)showHUD;


-(void)hideHUD:(NSString *)error;

@end
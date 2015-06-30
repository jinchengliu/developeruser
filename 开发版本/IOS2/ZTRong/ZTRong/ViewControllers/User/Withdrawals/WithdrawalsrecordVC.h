//
//  WithdrawalsrecordVC.h
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionPopup.h"
#import "MJRefresh.h"
#import "ZTRNoDateView.h"

@interface WithdrawalsrecordVC : ZTRMajorViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tv;
@property(nonatomic,strong)NSDictionary *dateMap;       //列表相关数据;
@property(nonatomic,strong)  UIView *selectView;

@end

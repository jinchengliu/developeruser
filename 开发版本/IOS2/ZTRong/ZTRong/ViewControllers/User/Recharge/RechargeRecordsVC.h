//  充值记录
//  RechargeRecordsVC.h
//  ZTRong
//
//  Created by fcl on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentSelectView.h"
#import "SelectionPopup.h"
#import "MJRefresh.h"
#import "XLScrollViewer.h"
#import "ZTRNoDateView.h"


@interface RechargeRecordsVC : ZTRMajorViewController<UITableViewDelegate,UITableViewDataSource,XLScrollViewerDelegate>

@property(nonatomic,strong) UITableView *tv;
@property(nonatomic,strong)NSDictionary *dateMap;       //列表相关数据;
@property(nonatomic,strong)  UIView *selectView;
@property(nonatomic,strong)NSMutableArray *viewArrays;
@property(nonatomic,strong)XLScrollViewer *xlScroll;


@end

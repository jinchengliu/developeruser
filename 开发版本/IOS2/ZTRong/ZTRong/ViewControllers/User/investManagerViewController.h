//
//  investManagerViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/22.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionPopup.h"
#import "MJRefresh.h"

@interface investManagerViewController : ZTRMajorViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet SegmentSelectView *sc;
@property(nonatomic,strong)NSString *Selection;
@property(nonatomic)NSInteger page;
@property (nonatomic) BOOL isFromHome;
@property(nonatomic,strong)  UIView *selectView;
@property(nonatomic)BOOL hasmoreSC;
@property(nonatomic)BOOL isRefush;
@property(nonatomic)BOOL isFromWebView;
@end

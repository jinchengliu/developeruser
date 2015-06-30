//
//  NewActionViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface NewActionViewController : ZTRMajorViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property(nonatomic,strong)  UIView *selectView;
@property(nonatomic)BOOL hasmoreSC;
@property(nonatomic)BOOL isRefush;
@property(nonatomic)NSInteger page;
@end

//
//  ActivityViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : ZTRMajorViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet SegmentSelectView *segScrollView;
@property(nonatomic,strong)NSString *Selection;
@property(nonatomic)NSInteger page;
@property (nonatomic) BOOL isFromHome;
@property(nonatomic,strong)  UIView *selectView;
@property(nonatomic)BOOL hasmoreSC;
@property(nonatomic)BOOL isRefush;
@property(nonatomic)BOOL isFromWebView;
@end

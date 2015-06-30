//
//  MessageViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionPopup.h"

@interface MessageViewController : ZTRMajorViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property(nonatomic,strong)NSString *Selection;
@property(nonatomic)NSInteger page;

@property (nonatomic) BOOL isFromHome;
@end

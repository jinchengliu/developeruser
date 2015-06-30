//
//  MyRedbagTableViewController.h
//  ZTRong
//
//  Created by 李婷 on 15/5/21.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionPopup.h"
#import "MJRefresh.h"

@interface MyRedbagTableViewController : UITableViewController
@property (nonatomic) BOOL isFromHome;
@property (weak, nonatomic) IBOutlet UILabel *bagTotal;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property(nonatomic,strong)NSString *Selection;
@end

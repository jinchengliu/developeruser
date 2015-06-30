//
//  myshareViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/24.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myshareViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *shareTotalMoney;
@property (weak, nonatomic) IBOutlet UILabel *todayMoney;
@property (weak, nonatomic) IBOutlet UILabel *weekMoney;
@property (weak, nonatomic) IBOutlet UILabel *monthMoney;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet SegmentSelectView *sc;
@property (weak, nonatomic) IBOutlet UIButton *sharefriendBtn;
- (IBAction)shareBtnPressed:(id)sender;
- (IBAction)sharefriendBtnPressed:(id)sender;
@end

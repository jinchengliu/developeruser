//
//  WithdrawalsVC.h
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"

@interface WithdrawalsVC : ZTRMajorViewController<UIPopoverListViewDelegate,UIPopoverListViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
   
        NSInteger secondsCountDown;
   

}

@property(nonatomic,strong)NSMutableArray *bankList;    //银行卡列表
@property(nonatomic)NSInteger selectIndex;              //选中的银行卡
//@property(nonatomic,strong)NSString *batchNo;           //批次号
@property(nonatomic,strong)NSDictionary *dateMap;       //账户相关数据;
@property(nonatomic,strong)NSString *phone;             //预留手机号
@property(nonatomic,strong)NSString *backCard;          //选中的银行卡号



@property(nonatomic,strong)  UITableView *tv;
@property(nonatomic,strong) IBOutlet UITableViewCell *bankCardCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *yuerCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *txCushCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *zfPassWordCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *yzmCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *doButtonCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *zfeeCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *zphoneCell;

@property(nonatomic)float maxQuota ;    //可提现的最大限额
@property(nonatomic)float yuer ;    //可提现的最大限额


@end

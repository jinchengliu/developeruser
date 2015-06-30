//
//  RechargeVC.h
//  ZTRong
//
//  Created by fcl on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"


typedef enum : NSInteger
{
    RechargeFromVC,                                                           //默认
    RechargeFromNewVC  = 1001,                                               //从认证银行卡进入
} RechargeVCFromType;

@interface RechargeVC : ZTRMajorViewController<UIPopoverListViewDelegate,UIPopoverListViewDataSource,UITextFieldDelegate>{
   NSInteger secondsCountDown;
}

@property(nonatomic)RechargeVCFromType rechargeVCFromType;
@property(nonatomic,strong)NSMutableArray *bankList;    //银行卡列表
@property(nonatomic)NSInteger selectIndex;              //选中的银行卡
@property(nonatomic,strong)NSString *batchNo;           //批次号
@property(nonatomic,strong)NSString *phone;             //预留手机号
@property(nonatomic,strong)NSString *backCard;          //选中的银行卡号


@end

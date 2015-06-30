//
//  BankCardAuthenticationVC.h
//  ZTRong
//
//  Created by fcl on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardAuthenPopup.h"
#import "UIPopoverListView.h"

typedef enum : NSInteger
{
    BankCardNew,                                                           //认证时候添加
    BankCardAdd  = 1001,                                                   //添加新银行卡进入
} BankCardFromType;


@interface BankCardAuthenticationVC : ZTRMajorViewController<UIPopoverListViewDelegate,UIPopoverListViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic) BankCardFromType bankCardFromType;
@property(nonatomic,strong)  UITableView *tv;
@property(nonatomic,strong) IBOutlet UITableViewCell *topCell;     //头部标签
@property(nonatomic,strong) IBOutlet UITableViewCell *inputCell;   //银行卡号
@property(nonatomic,strong) IBOutlet UITableViewCell *userMessageCell;  //用户信息
@property(nonatomic,strong) IBOutlet UITableViewCell *messageCell;      //提示信息
@property(nonatomic,strong) IBOutlet UITableViewCell *doCell;           //提交按钮
@property(nonatomic,strong) IBOutlet UITableViewCell *backNameCell;     //开户银行
@property(nonatomic,strong) IBOutlet UITableViewCell *addressCell;      //银行省市
@property(nonatomic,strong) IBOutlet UITableViewCell *banckDetailedCell; //银行具体地址


@property(nonatomic,strong) HZLocation *stateHZ;   //省地址
@property(nonatomic,strong) HZLocation *cityHZ;    //城市地址

@property(nonatomic,strong) NSArray *stateArray;
@property(nonatomic,strong) NSArray *cityArray;

@property(nonatomic,strong) NSArray *backNameList;  //银行名字列表
@property(nonatomic,strong) NSArray *backiconList;  //银行icon列表
@property(nonatomic,strong) NSString *backname;

@property(nonatomic,strong) UIPopoverListView *popoList;

@end

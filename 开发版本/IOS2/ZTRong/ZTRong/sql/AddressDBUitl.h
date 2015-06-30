//
//  AddressDBUitl.h
//  ZTRong
//
//  Created by fcl on 15/6/17.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "HZLocation.h"



typedef enum : NSInteger
{
    kAddressPickerCommon,   // 普通地址选择器
    kAddressPickerBank,     // 银行卡地址选择器
    kPickerBankList         // 银行卡列表选择器
} AddressPickerType;
@interface AddressDBUitl : NSObject



@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSMutableArray *bankInfoList;

// 单例方法
+ (AddressDBUitl *)sharedDAO;

// 初始化用户数据库
- (BOOL)initDatabase;
- (void)closeDatabase;

// 获得所有省的信息
- (NSArray *)allProvincesWithPickertype:(AddressPickerType)type;

// 根据省获取市的信息
- (NSArray *)citiesWithProvinceID:(NSString *)proID pickerType:(AddressPickerType)type;

// 根据市获取区的信息
- (NSArray *)districtsWithCityID:(NSString *)cityID;



@end

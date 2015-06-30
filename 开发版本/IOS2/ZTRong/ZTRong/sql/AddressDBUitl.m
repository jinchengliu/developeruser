//
//  AddressDBUitl.m
//  ZTRong
//
//  Created by fcl on 15/6/17.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "AddressDBUitl.h"

#define kCommonProTable     @"tm_province"
#define kCommonCityTable    @"tm_city"
#define kBankProTable       @"tm_province"
#define kBankCityTale       @"tm_city"


@implementation AddressDBUitl

#pragma mark - Singleton Methods
static  AddressDBUitl *sharedSupportDAO = nil;
+ (AddressDBUitl *)sharedDAO
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedSupportDAO = [[self alloc] init];
        [sharedSupportDAO singletonInit];
    });
    
    return sharedSupportDAO;
}

#pragma mark - Singleton Methods
- (void)singletonInit
{
    _bankInfoList = [[NSMutableArray alloc] init];
}

- (void)dealloc
{
    [self closeDatabase];
}



#pragma mark - ECPCommonDAO initial
- (BOOL)initDatabase
{
    NSString *dbFilePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"sqlite"];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    //数据库优化
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         // 开启缓存
         [db setShouldCacheStatements:YES];
         
         // 关闭同步，日志系统写入内容，临时表写入内存--加快sql处理速度
         sqlite3_exec([db sqliteHandle], "PRAGMA synchronous=OFF", NULL, NULL, NULL);
         
         if ([db hadError])
         {
             NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
         }
     }];
    
    return YES;
}

- (void)closeDatabase
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         [db closeOpenResultSets];
         [db clearCachedStatements];
         [db close];
     }];
    
    [self.dbQueue close];
}


#pragma mark - Actions

// 结果集转换对象
- (HZLocation *)rsToProvince:(FMResultSet *)rs
{
    HZLocation *addressInfo = [[HZLocation alloc] init];
    addressInfo.addressID = [rs stringForColumn:@"pro_id"];;
    addressInfo.addressName = [rs stringForColumn:@"pro_name"];;
    return addressInfo;
}

- (HZLocation *)rsToCiyt:(FMResultSet *)rs
{
    HZLocation *addressInfo = [[HZLocation alloc] init];
    addressInfo.addressID = [rs stringForColumn:@"city_id"];
    addressInfo.addressName = [rs stringForColumn:@"city_name"];;
    return addressInfo;
}

- (HZLocation *)rsToDistrict:(FMResultSet *)rs
{
    HZLocation *addressInfo = [[HZLocation alloc] init];
    addressInfo.addressID = [rs stringForColumn:@"cou_id"];;
    addressInfo.addressName = [rs stringForColumn:@"cou_name"];;
    return addressInfo;
}






#pragma mark - Address Management

// 获得所有省的信息
- (NSArray *)allProvincesWithPickertype:(AddressPickerType)type
{
    NSMutableArray *addresses = [NSMutableArray array];
    NSString *tableName = (type == kAddressPickerCommon) ? kCommonProTable : kBankProTable;
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", tableName];  // ORDER BY pinyin
         FMResultSet *rs = [db executeQuery:sql];
         while ([rs next])
         {
             HZLocation *address = [self rsToProvince:rs];
             [addresses addObject:address];
         }
         
         [rs close];
     }];
    
    NSLog(@"%zi",addresses.count);
    
    
    return addresses;
}

// 根据省获取市的信息
- (NSArray *)citiesWithProvinceID:(NSString *)proID pickerType:(AddressPickerType)type
{
    NSMutableArray *addresses = [NSMutableArray array];
    NSString *tableName = (type == kAddressPickerCommon) ? kCommonCityTable : kBankCityTale;
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@  WHERE pro_id = '%@' ", tableName  ,proID]  ;    //  ORDER BY pinyin
         FMResultSet *rs = [db executeQuery:sql];
         while ([rs next])
         {
             HZLocation *address = [self rsToCiyt:rs];
             [addresses addObject:address];
         }
         
         [rs close];
     }];
    
    return addresses;
}

// 根据市获取区的信息
- (NSArray *)districtsWithCityID:(NSString *)cityID
{
    NSMutableArray *addresses = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:@"SELECT * FROM com_county  WHERE cit_id = ?  ORDER BY pinyin", cityID];
         while ([rs next])
         {
             HZLocation *address = [self rsToDistrict:rs];
             [addresses addObject:address];
         }
         
         [rs close];
     }];
    
    return addresses;
}






@end

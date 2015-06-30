//
//  HZLocation.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZLocation : NSObject

@property (nonatomic, strong) NSString *state;          // 省
@property (nonatomic, strong) NSString *stateID;
@property (nonatomic, strong) NSString *city;           // 市
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *district;       // 区
@property (nonatomic, strong) NSString *districtID;
@property (nonatomic, strong) NSString *addressID;      // 地址ID
@property (nonatomic, strong) NSString *addressName;    // 地址名称

@end

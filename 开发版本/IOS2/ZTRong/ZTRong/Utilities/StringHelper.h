//
//  StringHelper.h
//  ZTRong
//
//  Created by 李婷 on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface StringHelper : NSObject

/**
 *  字典转字符串
 *
 *  @param dic 需转化的字典
 *
 *  @return 转化好的字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/**
 *  字典转化为用MD5加密过的字符串
 *
 *  @param dic 需转化的字典
 *
 *  @return 加密过的字符串
 */
+ (NSString *)dicSortAndMD5:(NSDictionary *)dic;
@end

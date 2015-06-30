//
//  APIClient.h
//  ZTRong
//
//  Created by 李婷 on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//
#import "AFHTTPSessionManager.h"
#import <UIKit/UIKit.h>

@interface APIClient : AFHTTPSessionManager

/**
 *  初始化
 *
 *  @return APIClient
 */
+ (instancetype)sharedClient;
/**
 *  初始化
 *
 *  @param URLString baseUrl
 *
 *  @return APIClient
 */
+ (instancetype)sharedClientWithBaseURL:(NSString *)URLString;
/**
 *  数据请求
 *
 *  @param URLString  方法名/完整url
 *  @param parameters 参数（键对值）
 *  @param completion 回调
 *
 *  @return 数据
 */
- (NSURLSessionDataTask *)fetchJSONForURLString:(NSString *)URLString
                                     Parameters:(NSDictionary *)parameters
                                     completion:(void (^)(NSDictionary *dict, NSError *error))completion;
@end

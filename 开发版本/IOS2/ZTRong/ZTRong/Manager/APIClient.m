//
//  APIClient.m
//  ZTRong
//
//  Created by 李婷 on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (instancetype)sharedClient
{
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:htmlUrl]];
        [_sharedClient.requestSerializer setTimeoutInterval:15.0]; //设置超时时间

    });
    
    return _sharedClient;
}
+ (instancetype)sharedClientWithBaseURL:(NSString *)URLString {
    
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:URLString]];
        [_sharedClient.requestSerializer setTimeoutInterval:15.0]; //设置超时时间
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)fetchJSONForURLString:(NSString *)URLString
                                     Parameters:(NSDictionary *)parameters
                                     completion:(void (^)(NSDictionary *dict, NSError *error))completion
{
    return [self POST:URLString
           parameters:parameters
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                      completion(responseObject, nil);
                  });
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                      completion(nil, error);
                      NSLog(@"ERROR:%@",error);
                  });
              }];
}


@end

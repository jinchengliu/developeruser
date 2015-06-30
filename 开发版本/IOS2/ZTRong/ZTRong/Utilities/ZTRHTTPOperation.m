//
//  ZTRHTTPOperation.m
//  ZTRong
//
//  Created by fcl on 15/5/21.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "ZTRHTTPOperation.h"

@implementation ZTRHTTPOperation

static ZTRHTTPOperation *sharedManager = nil;


+(ZTRHTTPOperation *)sharedManager{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedManager = [self manager];
        [sharedManager.operationQueue setMaxConcurrentOperationCount:4];
    });
    
    return sharedManager;
}


@end

//
//  ZTRHTTPOperation.h
//  ZTRong
//
//  Created by fcl on 15/5/21.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface ZTRHTTPOperation : AFHTTPRequestOperationManager


+(ZTRHTTPOperation *)sharedManager;

@end

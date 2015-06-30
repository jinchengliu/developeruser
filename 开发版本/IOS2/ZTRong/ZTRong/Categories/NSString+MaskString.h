//
//  NSString+MaskString.h
//  NewProduct
//
//  Created by zqf on 13-8-24.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MaskCellphone)

- (NSString *)maskPhoneNumber;
- (NSString *)maskName;
- (NSString *)maskIDCard;
- (NSString *)maskEmail;
- (NSString *)maskAlipay;

@end

//
//  NSString+MaskString.m
//  NewProduct
//
//  Created by zqf on 13-8-24.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "NSString+MaskString.h"

@implementation NSString (MaskCellphone)

- (NSString *)maskPhoneNumber
{
    NSMutableString *cellphone = [NSMutableString stringWithString:self];
    if (cellphone.length == 11)
    {
        [cellphone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return cellphone;
}

- (NSString *)maskName
{
    NSMutableString *name = [NSMutableString stringWithString:self];
    if (name.length >= 2 && ![name isEqualToString:@"(null)"])
    {
        [name replaceCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
    }
    return name;
}

- (NSString *)maskIDCard
{
    NSMutableString *idCard = [NSMutableString stringWithString:self];
    if (idCard.length >= 15)
    {
        [idCard replaceCharactersInRange:NSMakeRange(4, self.length - 7) withString:@"****"];
    }
    return idCard;
}

- (NSString *)maskEmail
{
    NSMutableString *email = [NSMutableString stringWithString:self];
    if (email.length > 0)
    {
        NSRange range = [email rangeOfString:@"@"];
        if (range.location != NSNotFound)
        {
            NSInteger length = range.location - 3;
            NSInteger location = 3;
            if (length < 0)
            {
                location = 0;
                length = range.location;
            }
            [email replaceCharactersInRange:NSMakeRange(location, length) withString:@"****"];
        }
    }
    return email;
}

- (NSString *)maskAlipay
{
    NSMutableString *alipay = [NSMutableString stringWithString:self];
    if (alipay.length > 0)
    {
        NSRange range = [alipay rangeOfString:@"@"];
        if (range.location != NSNotFound)
        {
            NSInteger length = range.location - 3;
            NSInteger location = 3;
            if (length < 0)
            {
                location = 0;
                length = range.location;
            }
            [alipay replaceCharactersInRange:NSMakeRange(location, length) withString:@"****"];
        }
        else
        {
            if (alipay.length == 11)
            {
                return [self maskPhoneNumber];
            }
        }
    }
    return alipay;
}

@end

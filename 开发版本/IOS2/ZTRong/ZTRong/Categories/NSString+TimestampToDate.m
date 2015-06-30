//
//  NSString+TimestampToDate.m
//  NewProduct
//
//  Created by zqf on 13-7-9.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "NSString+TimestampToDate.h"

@implementation NSString (MessageTime)

- (NSDate *)timestampToDate
{
    NSDate *date = nil;
    NSTimeInterval startTimeInterval =[self longLongValue];
    //[self longLongValue]/1000;
    if (startTimeInterval > 0)
    {
       //date= [NSDate dateWithTimeIntervalInMilliSecondSince1970:startTimeInterval];
       date = [NSDate dateWithTimeIntervalSince1970:startTimeInterval];
//       date =[NSDate new];
//        
//        
//        double ret =[date timeIntervalSinceNow];
//       NSLog(@"%f",ret);
       
       
    }
    else
    {
        date = [NSDate date];
    }
    return date;
}

@end

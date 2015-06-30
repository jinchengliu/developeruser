//
//  StringHelper.m
//  ZTRong
//
//  Created by 李婷 on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSString *)dicSortAndMD5:(NSDictionary *)dic{
    
    //取得所有KEY值
    NSMutableArray *allKeys= [NSMutableArray arrayWithArray:[dic allKeys]];
    
    //比较排序
    for (int i = 0; i < [allKeys count]; i ++)
    {
        for (int j = i + 1; j < [allKeys count]; j ++)
        {
            NSString  *firstOne=[NSString stringWithFormat:@"%@",[allKeys objectAtIndex:i]];
            NSString  *secondOne=[NSString stringWithFormat:@"%@",[allKeys objectAtIndex:j]];
            
            int result = [firstOne compare:secondOne];
            if (result == 1)
            {
                [allKeys exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
        
    }
    
    //KEY、VALUE组成字符串
    NSString *combineStr = @"";
    
    for (int i = 0; i < allKeys.count; i++) {
        NSString *key=  allKeys[i];
        
        if ([dic[key] length]) {
            combineStr = [NSString stringWithFormat:@"%@%@%@=%@",combineStr,i == 0 ? @"":@"&",key,dic[key]];
        }
    }
    
    combineStr = [combineStr stringByAppendingString:@"&key=51e4dc1269013ccd8f257164a79f465a"];
    return [[self createMD5:combineStr] lowercaseString];
    
}
+(NSString*) md5:(NSString*) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}
+ (NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

@end

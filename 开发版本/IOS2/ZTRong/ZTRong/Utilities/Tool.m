//
//  Tool.m
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "Tool.h"
#import "IdentityAuthenticationVC.h"
#import  "BankCardAuthenticationVC.h"
#import "RechargeVC.h"
#import "WithdrawalsVC.h"
#import "UIAlertView+Block.h"
#import "loginViewController.h"
#import "errorLabelView.h"


static BOOL hasNetWork=YES;

@implementation Tool


#pragma mark- 通过颜色创建图片
+(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}



+(UIColor *)createColorWithImage:(UIImage *)image{
   
    return [UIColor colorWithPatternImage:image];
}


#pragma mark- 通过16进制颜色值创建颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark- 错误提示 toast
+(void)showerrorLabelView :(NSString *) message rootView :(UIView *) rootView  superController :(UIViewController *) superController {
    errorLabelView *errorView = [[errorLabelView alloc] initWithFrame:CGRectZero superController:superController];
    [errorView setErrorText:message];
    [rootView addSubview:errorView];
}



//#pragma mark- 计算文本高度
//+(float) calculateHeight:(NSString*)content separated:(NSString*)separatedString font:(UIFont*)textFont width:(float)textWidth
//{
//    if(content==nil ||content.length==0){
//        content=@"A";
//    }
//    // content =[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    float height = 0.0f;
//    if ([separatedString isEqualToString:@""] || !separatedString) {
//        CGSize contentSize = [content sizeWithFont:textFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        height = contentSize.height;
//    }
//    else{
//        NSArray *contentArray = [content componentsSeparatedByString:separatedString];
//        for (NSString *itemString in contentArray){
//            height += [self calculateHeight:itemString separated:nil font:textFont width:textWidth];
//        }
//    }
//    
//    return height;
//}
//
//
//#pragma mark- 计算文本长度
//+(float) calculateWidth:(NSString*)content separated:(NSString*)separatedString font:(UIFont*)textFont {
//    
//    
//    if(content==nil ||content.length==0){
//        content=@"A";
//    }
//    content =[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    float height = 0.0f;
//    if ([separatedString isEqualToString:@""] || !separatedString) {
//        CGSize contentSize = [content sizeWithFont:textFont constrainedToSize:CGSizeMake(99999, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        height = contentSize.width;
//    }
//    else{
//        NSArray *contentArray = [content componentsSeparatedByString:separatedString];
//        for (NSString *itemString in contentArray){
//            height += [self calculateWidth:itemString separated:nil font:textFont];
//        }
//    }
//    
//    return height+textFont.pointSize;
//    
//    
//    
//    
//}
//
//
//#pragma mark- 计算textView的高度
//+ (float) heightForTextView:(float)textWidth font:(UIFont*)textFont
//                   WithText: (NSString *) strText{
//    if(strText==nil ||strText.length==0){
//        strText=@"A";
//    }
//    //去除空格
//    // strText =[strText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    float fPadding = 16.0; // 8.0px x 2
//    CGSize constraint = CGSizeMake(textWidth - fPadding, CGFLOAT_MAX);
//    
//    CGSize size = [strText sizeWithFont: textFont constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    
//    float fHeight = size.height + 16.0;
//    
//    return fHeight;
//}

//是否包含字符
+(BOOL)stringHasRange:(NSString *)string  range:(NSString *)range{
    
    NSRange ranges = [string rangeOfString:range];
    if (ranges.length >0)//包含
    {
        return YES;
    }
    else//不包含
    {
        return NO;
    }
}

+(BOOL) hasNetWork {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // NSLog(@"AFNetworkReachabilityManager   %d", status);
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                hasNetWork=NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                hasNetWork=NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                hasNetWork=YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNetWork=YES;
                break;
                
                
            default:
                break;
        }
    }];
    
    return hasNetWork;
}


//#pragma mark- post请求
//
//+(void)ZTRPostRequest:(NSString *)url parameters :(NSDictionary *) param
//          finishBlock:(RequestFinish)finishBlock
//              failure:(RequestFailed)faledBlock{
//    
//    
//    ZTRHTTPOperation *httpClient=[ZTRHTTPOperation manager];
////    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
////    NSString *tokenValue = [[NSString alloc] initWithFormat:@"Bearer %@", accessToken];
//    
//    NSString *urlString=url;
//    //[NSString stringWithFormat:@"%@%@",serviceURL,url];
//    NSMutableDictionary *map=[[NSMutableDictionary alloc] initWithDictionary:param];
////    [map setObject:GET_CURRENT_VERSION forKey:@"version"];
////    DebugLog(urlString);
//    NSMutableURLRequest *request = [httpClient.requestSerializer requestWithMethod:@"POST" URLString:urlString
//                                                                        parameters:map  error:nil];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    // DebugLog(tokenValue);
//   // [request setValue:tokenValue forHTTPHeaderField:@"Authorization"];
//    [request setTimeoutInterval:15];
//    
//    AFHTTPRequestOperation *operation =  [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation ,id responseObject){
//        if ([responseObject isKindOfClass: [NSDictionary class]]) {
//            NSDictionary *dic=[NSDictionary dictionaryWithDictionary:responseObject];
//            if(dic == nil){
//                if(faledBlock){
//                    faledBlock([NSError errorWithDomain:@"数据获取异常!"code:1001 userInfo:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"数据获取异常!",@"errormessage", nil]]);
//                }
//            }else{
//                if(finishBlock){
//                    finishBlock(dic);
//                }
//                
//            }
//            
//        }else{
//            if(faledBlock){
//                faledBlock([NSError errorWithDomain:@"数据获取异常!"code:1001 userInfo:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"数据获取异常!",@"errormessage", nil]]);
//            }
//            
//        }
//        
//        
//        
//    }failure:^(AFHTTPRequestOperation *operation ,NSError *error){
//        NSString *message=[Tool getErrorMsssage:error];
//        if(faledBlock){
//            faledBlock([NSError errorWithDomain:message code:error.code userInfo:[[NSMutableDictionary alloc] initWithObjectsAndKeys:message,@"errormessage", nil]]);
//        }
//        
//    }];
//    
//    
//    [httpClient.operationQueue addOperation:operation];
//    
//    
//}
//
#pragma mark -   获取网络错误信息  基于 afnetwork的error
+(NSString *)getErrorMsssage :(NSError *)error{
    // NSURLErrorCancelled
    if(error.code==-1011){
        NSString *string= [error.userInfo objectForKey:@"NSLocalizedDescription"];
        NSLog(@"errorMSG   :  %@",string);
        NSArray *array=[string  componentsSeparatedByString:@":"];
        string =[array objectAtIndex:array.count-1];
        if(string==nil){
            string=@"内部服务器错误";
        }
        return string;
        
    }else if(error.code == -1001){
        return @"请求超时";
    }else if(error.code == -1004){
        return  @"未能连接到服务器。";
    }else if(error.code ==-1009){
        return @"似乎已断开与互联网的连接";
    }
    
    return @"请检查网络环境!";
}


#pragma mark- 封装HTTP请求的参数
+(NSMutableDictionary  *)getHttpParams :(NSDictionary *)params{
     NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
     [map setObject:@"APP" forKey:@"channel"];
     [map setObject:params forKey:@"params"];
     [map setObject:[StringHelper dicSortAndMD5:params] forKey:@"sign"];
     [map setObject:@"1.0" forKey:@"version"];
     return map;
}


#pragma mark-  跳转到充值
+(void)pushToRecharge :(UIViewController *)nvc{

    if([UserTool userIsLogin]==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您未登录，是否需要登录?" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 1000;
        [alert show];
        
        return;
    }
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    NSMutableDictionary *params =[Tool getHttpParams:map];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    [nvc.view addSubview:HUD];
    
    [HUD show:YES];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/querySafety.htm"]  parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
        
        NSLog(@"%@",dict.description);
        NSString *string=[[dict objectForKey:@"map"] objectForKey:@"identityAuditstatusE"];
        if([dict[@"map"][@"identityCard"] intValue] == 0  ||[string  isEqualToString:@"passed"]==NO){
            IdentityAuthenticationVC *iavc=[[IdentityAuthenticationVC alloc] initWithNibName:@"IdentityAuthenticationVC" bundle:nil];
            iavc.identityAuditstatusE=string;
            [HUD hide:YES];
            if([nvc isKindOfClass:[UINavigationController class]]){
                [(UINavigationController *)nvc pushViewController:iavc animated:YES];     //身份认证
            } else{
                iavc.type=kpresent;
                UINavigationController *vc=[[UINavigationController alloc] initWithRootViewController:iavc];
                
                [nvc presentViewController:vc animated:YES completion:nil];
            }
            
            return ;
        }else {
            
            [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kCmdUserBankList] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dic){
                NSLog( @"%@", dic.description);
                if([dic[@"success"] intValue] == 1){
                    NSArray *arr=[[dic objectForKey:@"map"] objectForKey:@"bankList"];
                    if(arr.count==0){
                        BankCardAuthenticationVC *bavc=[[BankCardAuthenticationVC alloc]        initWithNibName:@"BankCardAuthenticationVC" bundle:nil];
                        [HUD hide:YES];
                        if([nvc isKindOfClass:[UINavigationController class]]){
                            [(UINavigationController *)nvc pushViewController:bavc animated:YES];      //银行卡认证
                        } else{
                            bavc.type=kpresent;
                            UINavigationController *vc=[[UINavigationController alloc] initWithRootViewController:bavc];
                            
                            [nvc presentViewController:vc animated:YES completion:nil];
                        }
                        
                    }else{
                        RechargeVC *rvc=[[RechargeVC alloc ] initWithNibName:@"RechargeVC" bundle:nil];
                        [HUD hide:YES];
                        if([nvc isKindOfClass:[UINavigationController class]]){
                            [(UINavigationController *)nvc pushViewController:rvc animated:YES];      //充值
                        }else{
                            rvc.type=kpresent;
                            UINavigationController *vc=[[UINavigationController alloc] initWithRootViewController:rvc];
                            
                            [nvc presentViewController:vc animated:YES completion:nil];
                        }
                    }
                }else{
                    [HUD hide:YES];
                    NSString *message=dict[@"errorMsg"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    
                }
            

            
            
            
            } failure:^(NSError *error){
            
                NSString *message= [Tool getErrorMsssage:error];
               // [HUD hide:YES];
                NSLog(@"%@",message);
                HUD.labelText=message;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUD hide: YES];
                });
            }];
            
                
            
                    
                    
        
        }
        

        
        
        
        
    
    } failure:^(NSError *error){
       // [HUD hide:YES];
        HUD.labelText=[Tool getErrorMsssage:error];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hide: YES];
        });
        
    
    }];
    
    
    
//    [[APIClient sharedClient] fetchJSONForURLString:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/querySafety.htm"]   Parameters:@{@"message":[StringHelper dictionaryToJson:params]} completion:^(NSDictionary *dict, NSError *error) {
//        if(error !=nil){
//            [HUD hide:YES];
//        }
//        if(error==nil){
//            NSLog(@"%@",dict.description);
//            NSString *string=[[dict objectForKey:@"map"] objectForKey:@"identityAuditstatusE"];
//            if([dict[@"map"][@"identityCard"] intValue] == 0  ||[string  isEqualToString:@"passed"]==NO){
//                IdentityAuthenticationVC *iavc=[[IdentityAuthenticationVC alloc] initWithNibName:@"IdentityAuthenticationVC" bundle:nil];
//                iavc.identityAuditstatusE=string;
//                [HUD hide:YES];
//                if([nvc isKindOfClass:[UINavigationController class]]){
//                    [(UINavigationController *)nvc pushViewController:iavc animated:YES];     //身份认证
//                } else{
//                    iavc.type=kpresent;
//                    UINavigationController *vc=[[UINavigationController alloc] initWithRootViewController:iavc];
//                    
//                    [nvc presentViewController:vc animated:YES completion:nil];
//                }
//
//                return ;
//            }else {
//                
//                
//                [[APIClient sharedClient] fetchJSONForURLString:[NSString stringWithFormat:@"%@%@",htmlUrl,kCmdUserBankList]   Parameters:@{@"message":[StringHelper dictionaryToJson:params]} completion:^(NSDictionary *dict, NSError *error) {
//                    if(error==nil){
//                        NSLog( @"%@", dict.description);
//                        if([dict[@"success"] intValue] == 1){
//                            NSArray *arr=[[dict objectForKey:@"map"] objectForKey:@"bankList"];
//                            
//                            if(arr.count==0){
//                                BankCardAuthenticationVC *bavc=[[BankCardAuthenticationVC alloc]        initWithNibName:@"BankCardAuthenticationVC" bundle:nil];
//                                [HUD hide:YES];
//                                if([nvc isKindOfClass:[UINavigationController class]]){
//                                    [(UINavigationController *)nvc pushViewController:bavc animated:YES];      //银行卡认证
//                                } else{
//                                    bavc.type=kpresent;
//                                    UINavigationController *vc=[[UINavigationController alloc] initWithRootViewController:bavc];
//                                    
//                                    [nvc presentViewController:vc animated:YES completion:nil];
//                                }
//                                
//                            }else{
//                                RechargeVC *rvc=[[RechargeVC alloc ] initWithNibName:@"RechargeVC" bundle:nil];
//                                [HUD hide:YES];
//                                if([nvc isKindOfClass:[UINavigationController class]]){
//                                    [(UINavigationController *)nvc pushViewController:rvc animated:YES];      //充值
//                                }else{
//                                    rvc.type=kpresent;
//                                    UINavigationController *vc=[[UINavigationController alloc] initWithRootViewController:rvc];
//                                    
//                                    [nvc presentViewController:vc animated:YES completion:nil];
//                                }
//                            }
//                            
//                            
//                        }else{
//                            NSString *message=dict[@"errorMsg"];
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                            [alert show];
//                            
//                        }
//                        
//                        
//                    }else{
//                        NSString *message= [Tool getErrorMsssage:error];
//                        [HUD hide:YES];
//                        NSLog(@"%@",message);
//                    }
//                    
//                    
//                }];
//
//                
//                
//           
//            }
//        }
//        
//    }];
//    
    


    
    
    
}



#pragma mark-  跳转到提现
+(void)pushToWithdrawals :(UIViewController *)nvc{
        WithdrawalsVC *wvc=[[WithdrawalsVC alloc] initWithNibName:@"WithdrawalsVC" bundle:nil];
        //[nvc pushViewController:wvc animated:YES];
    
        if([nvc isKindOfClass:[UINavigationController class]]){
            [(UINavigationController *)nvc pushViewController:wvc animated:YES];      //跳转到提现
        }else{
            wvc.type=kpresent;
            UINavigationController *vc=[[UINavigationController alloc] initWithRootViewController:wvc];
            [nvc presentViewController:vc animated:YES completion:nil];
        }

}


#pragma mark - 初始化分享数据对象
+(ShareDate *) getShareDate:(NSString*) content{
    ShareDate *sd=[[ShareDate alloc] init];
    if (content) {
        sd.content=[NSString stringWithFormat:@"%@",content];
    }
    return sd;
}


#pragma mark-日期格式
+(NSString *)dateFormatter :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //formatter s
    return [formatter stringFromDate:date];
}

//快速创建lable
+(UILabel *)createLable :(UIColor *)stringColor font :(float)font frame:(CGRect)frame{
    UILabel *label=[[UILabel alloc] initWithFrame:frame];
    label.backgroundColor=[UIColor clearColor];
    if(stringColor){
        label.textColor=stringColor;
    }
    [label setFont:[UIFont systemFontOfSize:font]];
    
    
    return  label;
    
}










#pragma mark- post请求
+(void)ZTRPostRequest :(NSString *)url  parameters :(NSDictionary *) param
          finishBlock:(RequestFinish)finishBlock
              failure:(RequestFailed)faledBlock{
        ZTRHTTPOperation *httpClient=[ZTRHTTPOperation sharedManager];
        NSMutableDictionary *map=[[NSMutableDictionary alloc] initWithDictionary:param];
        NSMutableURLRequest *request = [httpClient.requestSerializer requestWithMethod:@"POST" URLString:url parameters:map  error:nil];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
        [request setTimeoutInterval:15];
        AFHTTPRequestOperation *operation =  [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation ,id responseObject){
           if ([responseObject isKindOfClass: [NSDictionary class]]) {
               NSDictionary *dic=[NSDictionary dictionaryWithDictionary:responseObject];
               if(dic == nil){
                    if(faledBlock){
                      faledBlock([NSError errorWithDomain:@"数据获取异常!"code:1001 userInfo:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"数据获取异常!",@"errormessage", nil]]);
                   }
             }else{
                  if(finishBlock){
                      finishBlock(dic);
                  }
   
              }
            }else{
             if(faledBlock){
                  faledBlock([NSError errorWithDomain:@"数据获取异常!"code:1001 userInfo:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"数据获取异常!",@"errormessage", nil]]);
              }
   
            }
    
      
       }failure:^(AFHTTPRequestOperation *operation ,NSError *error){
           NSString *message=[Tool getErrorMsssage:error];
          if(faledBlock){
              faledBlock([NSError errorWithDomain:message code:error.code userInfo:[[NSMutableDictionary alloc] initWithObjectsAndKeys:message,@"errormessage", nil]]);
           }
           
      }];
    
       [httpClient.operationQueue setMaxConcurrentOperationCount:4];
       [httpClient.operationQueue addOperation:operation];
    
    
    
    
    
    
}



//正则验证
+(BOOL)isRegex :(NSString *)regex  string:(NSString *)string{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:string];
    return  isValid;
    
}



@end

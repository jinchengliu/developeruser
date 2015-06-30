//
//  ShareUitl.m
//  ShareTest
//
//  Created by ysy on 14-10-21.
//  Copyright (c) 2014年 ysy. All rights reserved.
//

#import "ShareUitl.h"
//#import "shareWeiBo.h"



#define APPDELEGATE ((AppDelegate *)([[UIApplication sharedApplication] delegate]))
#define rootVC APPDELEGATE.tabBarController
#define ShareUitl_SinaString  @"ShareUitl_SinaString"
#define ShareUitl_TencentWeiboString  @"ShareUitl_TencentWeiboString"

#define SHARE_URL @"http://www.ztrong.com"
#define SinaSource                   @"weibo"
#define TenCentSource                @"qqweibo"
#define WeiXinSource                 @"weixin"

static ShareUitl * shareUitl = nil;
@implementation ShareUitl
+(ShareUitl *)ShareInstrance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
       // shareUitl=nil;
        shareUitl = [[self alloc] init];
    });
    return shareUitl;
}




//判断是否授权
+(BOOL) hasAuthorizedWithType:(ShareUitl_ShareType) type{
    switch (type) {
        case ShareUitl_Sina:
            return [ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo];
            break;
        case ShareUitl_TencentWeibo:
            return [ShareSDK hasAuthorizedWithType:ShareTypeTencentWeibo];
            break;
        case ShareUitl_WX:
            return [ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession];
            break;
        default:
            break;
    }
    return NO;
}


//第三方登录
+(void)getCredentialWithType:(ShareUitl_ShareType) type finishBlock : (ShareDICFinishBlock) finishBlock{
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
        ShareType stype;
        switch (type) {
            case ShareUitl_Sina:
                stype=ShareTypeSinaWeibo;
                break;
            case ShareUitl_TencentWeibo:
                stype=ShareTypeTencentWeibo;
                break;
            case ShareUitl_WX:
                stype=ShareTypeWeixiSession;
                break;
            default:
                stype=ShareTypeTencentWeibo;
                break;
        }
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        [ShareSDK getUserInfoWithType:stype
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   if (result)
                                   {
                                       if(finishBlock){
                                           [dic setObject:[NSNumber numberWithBool:YES] forKey:@"hasAuthToken"];
                                           [dic setObject:[userInfo.credential token] forKey:@"access_token"];
                                           [dic setObject:userInfo.uid forKey:@"uid"];
                                           [dic setObject:StringWithFormat(@"%@",@"")
                                                       forKey:@"expirationDate"];
                                           [dic setObject:StringWithFormat(@"%@",userInfo.nickname) forKey:@"username"];
                                           [dic setObject:StringWithFormat(@"%@",@"") forKey:@"create_at"];
                                           [dic setObject:@"" forKey:@"openkey"];
                                           [dic setObject:@"" forKey:@"refreshToken"];
                                           [dic setObject:@"" forKey:@"unionid"];
                                           if( stype==ShareTypeTencentWeibo){
                                               [dic setObject:StringWithFormat(@"%@",TenCentSource) forKey:@"source"];
                                           }else if(stype == ShareTypeWeixiSession){
                                               [dic setObject:StringWithFormat(@"%@",WeiXinSource) forKey:@"source"];
                                               
                                           }
                                           
                                           
                                           finishBlock(dic);
                                       }
                                   }else{
                                       if(finishBlock){
                                           finishBlock(nil);
                                       }
                                   }
                               }];
        
        
        
        
        
        
        
        
  //  }
  
    
    
}



//授权
+(void) getUserInfoWithType :(ShareUitl_ShareType) type finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    ShareType stype;
    switch (type) {
        case ShareUitl_Sina:
            stype=ShareTypeSinaWeibo;
           // stype=ShareTypeWeixiSession;
            break;
        case ShareUitl_TencentWeibo:
            stype=ShareTypeTencentWeibo;
            break;
        case ShareUitl_WX:
            stype=ShareTypeWeixiSession;
            break;
        default:
            stype=ShareTypeTencentWeibo;
            break;
    }
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:stype
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                             //  DebugLog(@"1111");
                               if (result)
                               {
                                   if(finishBlock){
                                       
                                       
                                       NSLog(@"nickname %@",[userInfo nickname]);
                                       NSLog(@"uid %@",[userInfo uid]);
                                       NSLog(@"%@",[userInfo nickname]);
                                       NSLog(@"profileImage%@",[userInfo profileImage]);
                                       NSLog(@"gender %zi",[userInfo gender]);
                                       NSLog(@"%@",[userInfo nickname]);
                                       NSLog(@"%@",[userInfo nickname]);

                                       if(stype==ShareTypeSinaWeibo){
                                          // [Tool saveInfoPilst:[userInfo nickname] byKey:ShareUitl_SinaString];
                                           
                                           // 由于sharekit的新浪客户端发送不回调
                                           // 新浪有两种发送消息方式，需要两种授权，
                                           // 转发题只发给新浪时用一种，发给多平台时用一种，此处要注意
                                           
                                           NSDate *creationDate = [NSDate date];
                                           NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
                                           [item setObject:[NSNumber numberWithBool:YES] forKey:@"hasAuthToken"];
                                           [item setObject:StringWithFormat(@"%@",[[userInfo credential] token])
                                                    forKey:@"access_token"];
                                           [item setObject:StringWithFormat(@"%@",[[userInfo credential] uid])
                                                    forKey:@"uid"];
                                           NSTimeInterval expired = [[[userInfo credential] expired] timeIntervalSinceDate:creationDate];
                                           [item setObject:StringWithFormat(@"%@",[NSNumber numberWithDouble:expired])
                                                    forKey:@"expirationDate"];
                                           [item setObject:StringWithFormat(@"%@",[userInfo nickname]) forKey:@"username"];
                                           [item setObject:StringWithFormat(@"%f",[userInfo regAt]) forKey:@"create_at"];
                                           [item setObject:StringWithFormat(@"%@",nil) forKey:@"openkey"];
                                           [item setObject:StringWithFormat(@"%@",SinaSource) forKey:@"source"];
                                           //[shareWeiBo writeToPlist:item isBoundSource:NO];
                                           
                                       }else{
                                          // [Tool saveInfoPilst:[userInfo nickname] byKey:ShareUitl_TencentWeiboString];
                                       }
                                       
                                       finishBlock();
                                   }
                                   
                               }else{
                                   NSLog(@"%ld:%@",(long)[error errorCode], [error errorDescription]);
                                   if(faildBlock){
                                       faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                       
                                   }
                                   
                               }
                               
                           }];
    
    
    
}


//取消授权
+(void) cancelAuthWithType:(ShareUitl_ShareType) type{
    switch (type) {
        case ShareUitl_Sina:
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
            break;
        case ShareUitl_TencentWeibo:
            [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
            break;
        case ShareUitl_WX:
            [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
            break;
        
        default:
            break;
    }
    
}






//分享入口
-(void)doShare :(ShareDate *)sd image :(UIImage *) image url :(NSString *) url ShareType :(ShareUitl_ShareType) type
   finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    
    
//    if (content.length > 0) {
//        content = [NSString stringWithString:content];
//    }
//    image=[Tool JpegImage:image];
    id<ISSCAttachment> imageItem = nil;
    if (image) {
        imageItem = [ShareSDK jpegImageWithImage:image quality:1];
    }
    switch (type) {
        case ShareUitl_Sina:
            [self shareSina:sd.content image:imageItem url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        case ShareUitl_WX:
            [self shareWX:sd image:imageItem url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        case ShareUitl_WXQ:
            [self shareWXQ:sd image:imageItem url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        case ShareUitl_QQ:
            [self shareQQ:sd image:imageItem url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        case ShareUitl_QQzq:
            [self shareQQZQ:sd image:imageItem url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        case ShareUitl_TencentWeibo:
            [self shareTencentWeibo:sd.content image:imageItem url:url finishBlock:finishBlock  faildBlock:faildBlock];
            
            break;
        case ShareUitl_SMS:
            [self shareSMS:sd.content url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        case ShareUitl_email:
            [self shareEmail:sd.content image:imageItem url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        case ShareUitl_Copy:
            [self shareCopy:sd.content image:image url:url finishBlock:finishBlock  faildBlock:faildBlock];
            break;
        default:
            break;
            
    }

}


//分享网络图片
-(void)doShare :(ShareDate *)sd URLimage :(NSString *) imageurl url :(NSString *) url ShareType :(ShareUitl_ShareType) type
   finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
//    if (content.length > 0) {
//        content = [NSString stringWithString:content];
//    }

    
    id<ISSCAttachment> imageItem = nil;
    if (imageurl &&  imageurl.length > 0) {
        imageItem = [ShareSDK imageWithUrl:imageurl];
    }

    
    
    switch (type) {
        case ShareUitl_Sina:
            [self shareSina:sd.content image:imageItem url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_WX:
            [self shareWX:sd image:imageItem url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_WXQ:
            [self shareWXQ:sd image:imageItem url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_QQ:
            [self shareQQ:sd image:imageItem url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_QQzq:
            [self shareQQZQ:sd image:imageItem url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_email:
            [self shareEmail:sd.content image:imageItem url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_TencentWeibo:
            [self shareTencentWeibo:sd.content image:imageItem url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_SMS:
            [self shareSMS:sd.content url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
        case ShareUitl_Copy:
            [self shareCopy:sd.content image:nil url:url finishBlock:finishBlock faildBlock:faildBlock];
            break;
            
            
            
        default:
            if(faildBlock){
                faildBlock([NSError errorWithDomain:@"不支持发送url图片"code:110 userInfo:[NSDictionary dictionaryWithObject:@"不支持发送url图片" forKey:@"errormessage"]]);
            }
            break;
    }
    
    
    
    // [self Sharewx:content URLimage:imageurl url:url finishBlock:finishBlock faildBlock:faildBlock];
    
    
}







#pragma mark- 分享到新浪微博
-(void)shareSina :(NSString *)content image :(id<ISSCAttachment>) image url :(NSString *) url
     finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    
    // 腾讯微博  SSPublishContentMediaTypeNews
    // URl 可以为空
    // 出现图片和文字
    
    if(image ==nil){
        NSLog(@"no image");
        image = [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"AppIcon"] quality:1];
    }

    
    SSPublishContentMediaType ssType;
    if(image && content.length > 0){
        ssType=SSPublishContentMediaTypeNews;
    }else {
        ssType=SSPublishContentMediaTypeText;
    }
    
    if (url && [content rangeOfString:url].location == NSNotFound) {
        content = [NSString stringWithFormat:@"%@ %@",content,url];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:image
                                                title:SHARE_TITLE
                                                  url:url
                                          description: @""
                                            mediaType:ssType];
    
    [ShareSDK clientShareContent:publishContent
                            type:ShareTypeSinaWeibo
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                  if(finishBlock){
                                      finishBlock();
                                  }
                                  
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                 // NSLog( @"分享失败,错误码%d:,错误描述:%@",[error errorCode],  [error errorDescription]);
                                  if(faildBlock){
                                
                                      faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                  }
                              }
                          }];



}




#pragma mark- 微信
-(void)shareWX :(ShareDate *)sd image :(id<ISSCAttachment>) image url :(NSString *) url
     finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    
    
    // 微信  SSPublishContentMediaTypeNews
    // URL 不能为空
    // 如果URL 为空 用SSPublishContentMediaTypeText 不传图片，只上传文字
    
   // [ShareSDK connectWeChatWithAppId:WeiXin_AppID wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId: WeiXin_AppID
                           appSecret:WeiXin_AppKey
     
                           wechatCls: [WXApi class]];
    
    if(sd.content.length==0){
        sd.content=sd.desc;
    }
        NSLog(@"%@",sd.content);
    if(image ==nil){
         NSLog(@"no image");
        
        image = [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"AppIcon"] quality:1];
    }
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        SSPublishContentMediaType ssType;
        if(image && sd.content.length > 0 && url.length > 0){
            ssType=SSPublishContentMediaTypeNews;
        }else {
            ssType=SSPublishContentMediaTypeText;
            if (url && [sd.content rangeOfString:url].location == NSNotFound) {
               sd.content = [NSString stringWithFormat:@"%@ %@",sd.content,url];
            }
        }
            id<ISSContent> publishContent = [ShareSDK content:sd.content
                                       defaultContent:@""
                                                image:image
                                                title:sd.desc
                                                  url:url
                                          description: @""
                                            mediaType:ssType];
    
            [ShareSDK clientShareContent:publishContent
                            type:ShareTypeWeixiSession
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                 // NSLog (@"分享成功");
                                  if(finishBlock){
                                      finishBlock();
                                  }
                                  
                              }
                              
                              
                              else if(state ==SSPublishContentStateCancel) {
                                  NSLog(@"微信取消");
                              }
                              
                              else if (state == SSPublishContentStateFail)
                              {
                                 // NSLog( @"分享失败,错误码%d:,错误描述:%@",[error errorCode],  [error errorDescription]);
                                  if(faildBlock){
                                      faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                  }
                              }
                             
                              
            }];

    }else{

        if(faildBlock){
            faildBlock([NSError errorWithDomain:@"您的iPhone上尚未安装微信，请安装成功后再分享。" code:1 userInfo:[NSDictionary dictionaryWithObject:@"您的iPhone上尚未安装微信，请安装成功后再分享。" forKey:@"errormessage"]]);
        }
        
    }




}



#pragma mark- 微信圈
-(void)shareWXQ :(ShareDate *)sd image :(id<ISSCAttachment>) image url :(NSString *) url
   finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    //[ShareSDK connectWeChatWithAppId:@"wxcea9004022eb8127" wechatCls:[WXApi class]];
    //  [ShareSDK connectWeChatWithAppId:WeiXin_AppID appSecret:WeiXin_AppKey wechatCls:[WXApi class]];
    // ShareSDK
    [ShareSDK connectWeChatWithAppId: WeiXin_AppID
                           appSecret:WeiXin_AppKey
     
                           wechatCls: [WXApi class]];
     NSLog(@"%@",sd.content);
    if(sd.content.length==0){
        sd.content=sd.desc;
    }
    
    if(image ==nil){
         NSLog(@"no image");
        
        image = [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"AppIcon"] quality:1];
    }
//    [WXApi registerApp:WeiXin_AppID];
//    [ShareSDK connectWeChatWithAppId:WeiXin_AppID wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:WeiXin_AppID appSecret:WeiXin_AppKey wechatCls:[WXApi class]];
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        
        // 微信圈  SSPublishContentMediaTypeNews
        // URL 不能为空
        // 如果URL 为空 用SSPublishContentMediaTypeText 不传图片，只上传文字
        
        SSPublishContentMediaType ssType;
        if(image && sd.content.length > 0 && url.length > 0){
            ssType=SSPublishContentMediaTypeNews;
        }else {
            ssType=SSPublishContentMediaTypeText;
            if (url && [sd.content rangeOfString:url].location == NSNotFound) {
                sd.content = [NSString stringWithFormat:@"%@ %@",sd.content,url];
            }
        }
        
            id<ISSContent> publishContent = [ShareSDK content: sd.content
                                       defaultContent:sd.content
                                                image:image
                                                title:sd.content
                                                  url:url
                                          description: sd.content
                                            mediaType:ssType];
    
        
             NSLog (@"开始分享");
            [ShareSDK clientShareContent:publishContent
                            type:ShareTypeWeixiTimeline
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog (@"分享成功");
                                  if(finishBlock){
                                      finishBlock();
                                  }
                                  
                              }
                              
                              else if(state ==SSPublishContentStateCancel) {
                                  NSLog(@"微信取消");
                              }
                              
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog( @"分享失败,错误码%zi:,错误描述:%@",[error errorCode],  [error errorDescription]);
                                  if(faildBlock){
                                      faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                  }
                              }
            }];
        
    }else{
        if(faildBlock){
            faildBlock([NSError errorWithDomain:@"您的iPhone上尚未安装微信，请安装成功后再分享。" code:1 userInfo:[NSDictionary dictionaryWithObject:@"您的iPhone上尚未安装微信，请安装成功后再分享。" forKey:@"errormessage"]]);
        }
        
    }
    
    
}



-(BOOL)isQQInstalled{
    
    return [QQApi isQQInstalled];
}


#pragma mark- qq
-(void)shareQQ :(ShareDate *)sd image :(id<ISSCAttachment>) image url :(NSString *) url
     finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    
    
    // qq  SSPublishContentMediaTypeNews
    // URL 不能为空
    // 如果URL 为空 用SSPublishContentMediaTypeText 不传图片，只上传文字
    
    if(sd.content.length==0){
        sd.content=sd.desc;
    }
    if(image ==nil){
         NSLog(@"no image");
        
        image = [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"AppIcon"] quality:1];
    }

    
    if([QQApi isQQInstalled]){
    
            SSPublishContentMediaType ssType;
        if(image && sd.content.length > 0 && url.length > 0){
            ssType=SSPublishContentMediaTypeNews;
        }else {
            ssType=SSPublishContentMediaTypeText;
            if (url && [sd.content rangeOfString:url].location == NSNotFound) {
                sd.content = [NSString stringWithFormat:@"%@ %@",sd.content,url];
            }
        }
    
    
            id<ISSContent> publishContent = [ShareSDK content: sd.content
                                       defaultContent:@""
                                                image:image
                                                title:sd.desc
                                                  url:url
                                          description: @""
                                            mediaType:ssType];
    
            [ShareSDK clientShareContent:publishContent
                            type:ShareTypeQQ
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                 // NSLog (@"分享成功");
                                  if(finishBlock){
                                      finishBlock();
                                  }
                                  
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                 // NSLog( @"分享失败,错误码%d:,错误描述:%@",[error errorCode],  [error errorDescription]);
                                  if(faildBlock){
                                      faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                  }
                              }
                          }];
        
    }else{

        if(faildBlock){
            faildBlock([NSError errorWithDomain:@"您的iPhone上尚未安装QQ，请安装成功后再分享。" code:2 userInfo:[NSDictionary dictionaryWithObject:@"您的iPhone上尚未安装QQ，请安装成功后再分享。" forKey:@"errormessage"]]);
        }
        
        
    }
    
    
    
}



#pragma mark- qq空间
-(void)shareQQZQ :(ShareDate *)sd image :(id<ISSCAttachment>) image url :(NSString *) url
   finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    
    
    // qq空间 只能用 SSPublishContentMediaTypeNews
    // URL 不能为空
    // 图片可以为空
    if(sd.content.length==0){
        sd.content=sd.desc;
    }
    if(image ==nil){
         NSLog(@"no image");
        
        image = [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"AppIcon"] quality:1];
    }

    
     if([QQApi isQQInstalled]){
         
         SSPublishContentMediaType ssType;
         ssType=SSPublishContentMediaTypeNews;
         
         if (url.length == 0) {
             
             NSMutableString *shareText = [[NSMutableString alloc]initWithString:sd.content];
             NSRange range = [shareText rangeOfString:@"http://"];
             if(range.location != NSNotFound)
             {
                 url = [shareText substringFromIndex:range.location];
             }
             if (url.length == 0) {
                 url = [NSString stringWithFormat:@"%@",SHARE_URL];
             }
         }
         
//         if (url.length > 0 && [content rangeOfString:url].location == NSNotFound) {
//             content = [NSString stringWithFormat:@"%@ %@",content,url];
//         }
         
    
    
         id<ISSContent> publishContent = [ShareSDK content:sd.content
                                            defaultContent:@""
                                                     image:image
                                                     title:sd.content
                                                       url:url
                                               description:@""
                                                 mediaType:ssType];
         
         
         
    
            [ShareSDK clientShareContent:publishContent
                            type:ShareTypeQQSpace
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                 // NSLog (@"分享成功");
                                  if(finishBlock){
                                      finishBlock();
                                  }
                                  
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  //NSLog( @"分享失败,错误码%d:,错误描述:%@",[error errorCode],  [error errorDescription]);
                                  if(faildBlock){
                                      faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                  }
                              }
                          }];
    
     }else{
         
         if(faildBlock){
             faildBlock([NSError errorWithDomain:@"您的iPhone上尚未安装QQ，请安装成功后再分享。" code:1 userInfo:[NSDictionary dictionaryWithObject:@"您的iPhone上尚未安装QQ，请安装成功后再分享。" forKey:@"errormessage"]]);
         }
         
         
     }
    
}


#pragma mark- 腾讯微博
-(void)shareTencentWeibo :(NSString *)content image :(id<ISSCAttachment>) image url :(NSString *) url
     finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    
    
    // 腾讯微博  SSPublishContentMediaTypeNews
    // URl 可以为空
    // 出现图片和文字
    if(image ==nil){
        NSLog(@"no image");
        
        image = [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"AppIcon"] quality:1];
    }

    
    SSPublishContentMediaType ssType;
    if(image && content.length > 0){
        ssType=SSPublishContentMediaTypeNews;
    }else {
        ssType=SSPublishContentMediaTypeText;
    }
    
    if (url && [content rangeOfString:url].location == NSNotFound) {
        content = [NSString stringWithFormat:@"%@ %@",content,url];
    }
    
    id<ISSContent> publishContent = [ShareSDK content: content
                                       defaultContent:@""
                                                image:image
                                                title:SHARE_TITLE
                                                  url:url
                                          description: @""
                                            mediaType:ssType];
    
    [ShareSDK clientShareContent:publishContent
                            type:ShareTypeTencentWeibo
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                 // NSLog (@"分享成功");
                                  if(finishBlock){
                                      finishBlock();
                                  }
                                  
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                 // NSLog( @"分享失败,错误码%d:,错误描述:%@",[error errorCode],  [error errorDescription]);
                                  if(faildBlock){
                                      faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                  }
                              }
                          }];
    
    
    
}



#pragma mark- 短信
-(void)shareSMS :(NSString *)content url :(NSString *) url
             finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    Class mailClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (mailClass != nil &&  [mailClass canSendText]){//判断是否是可以发送短信的设备
    
        if (url && [content rangeOfString:url].location == NSNotFound) {
            content = [NSString stringWithFormat:@"%@ %@",content,url];
        }

        
            id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:nil
                                                title:@""
                                                  url:@""
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
            id<ISSContainer> container = [ShareSDK container];
            [container setIPadContainerWithView:APPDELEGATE.window.rootViewController.view arrowDirect:UIPopoverArrowDirectionUp];
    
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self];
    
    //在授权页面中添加关注官方微博
//            [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
            [ShareSDK showShareViewWithType:ShareTypeSMS
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:self
                                                       friendsViewDelegate:self
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                    // NSLog( @"发表成功");
                                     
                                     if(finishBlock){
                                         finishBlock();
                                     }

                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                    // NSLog( @"分享失败,错误码:,错误描述:%@",  [error errorDescription]);
                                     
                                     if(faildBlock){
                                         faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);                                     }

                                 }
                             }];
    

    
    }else{
        
        if(faildBlock){
            faildBlock([NSError errorWithDomain:@"您的设备不支持短信业务" code:1 userInfo:[NSDictionary dictionaryWithObject:@"您的设备不支持短信业务" forKey:@"errormessage"]]);
        }

        
    }
    
}


#pragma mark- 复制
-(void)shareCopy :(NSString *)content image :(UIImage *)image url :(NSString *) url
     finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    
//    if (image) {
//        pasteboard.image = image;
//        if(finishBlock){
//            finishBlock();
//        }
//    }
//    else
    if(content.length > 0 || url.length > 0){
        if (url && [content rangeOfString:url].location == NSNotFound) {
            content = [NSString stringWithFormat:@"%@ %@",content,url];
        }

        pasteboard.string = content;
        if(finishBlock){
            finishBlock();
        }
    }else{
        if(faildBlock){
            faildBlock([NSError errorWithDomain:@"没有复制内容"code:110 userInfo:[NSDictionary dictionaryWithObject:@"没有复制内容" forKey:@"errormessage"]]);
        }
        
    }
    
    
}


#pragma mark- 发送Email
-(void)shareEmail :(NSString *)content image :(id<ISSCAttachment>) image url :(NSString *) url
    finishBlock : (ShareFinishBlock) finishBlock faildBlock:(ShareFaildBlock) faildBlock{
  
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil &&  [mailClass canSendMail])  //判断是否是可以发送邮件的设备
    {
            id<ISSContent> publishContent = [ShareSDK content: content
                                       defaultContent:@""
                                                image:image
                                                title:SHARE_TITLE
                                                  url:url
                                          description: content
                                            mediaType:SSPublishContentMediaTypeText];
    
            id<ISSContainer> container = [ShareSDK container];
            [container setIPadContainerWithView:APPDELEGATE.window.rootViewController.view arrowDirect:UIPopoverArrowDirectionUp];
    
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self];
    
    //在授权页面中添加关注官方微博
//            [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    //显示分享菜单
            [ShareSDK showShareViewWithType:ShareTypeMail
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:self
                                                       friendsViewDelegate:self
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                    // NSLog(@"发表成功");
                                     if(finishBlock){
                                         finishBlock();
                                     }

                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                    // NSLog( @"分享失败,错误码:,错误描述:%@",  [error errorDescription]);
                                     
                                     if(faildBlock){
                                         faildBlock([NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:@"errormessage"]]);
                                     }
                                 }
                             }];
       
    
    }else{

        
        if(faildBlock){
            faildBlock([NSError errorWithDomain:@"您的设备不支持邮件业务" code:1 userInfo:[NSDictionary dictionaryWithObject:@"您的设备不支持邮件业务" forKey:@"errormessage"]]);
        }

    }
    
    
}


- (void)dealloc
{
    shareUitl = nil;
}
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        UIButton *leftBtn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
        UIButton *rightBtn = (UIButton *)viewController.navigationItem.rightBarButtonItem.customView;
        
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = viewController.title;
        label.font = [UIFont boldSystemFontOfSize:18];
        [label sizeToFit];
        
        viewController.navigationItem.titleView = label;
        
        // [label release];
    }
    
    if ([UIDevice currentDevice].isPad)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:22];
        viewController.navigationItem.titleView = label;
        label.text = viewController.title;
        [label sizeToFit];
        // [label release];
        
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    }
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
    if ([UIDevice currentDevice].isPad)
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    }
}



@end

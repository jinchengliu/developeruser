//
//  SharePopup.h
//  ZTRong
//
//  Created by fcl on 15/6/9.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "IEPopupMaskView.h"

@interface SharePopup : IEPopupMaskView


@property(nonatomic,strong)NSString *shareURL;            //分享的地址
@property(nonatomic,strong)NSString *sharecontent;        //分享的图片
@property(nonatomic,strong)UIImage   *shareImage;         //分享的图片    和图片地址2选1    默认
@property(nonatomic,strong)NSString  *shareImageURL;      //分享的图片地址    和图片2选1
@property(nonatomic,strong)ZTRdoFinishBlock  ErweimaBlock;  //二维码选中事件
@property(nonatomic,strong)UIViewController *rootViewController; //根视图
@end

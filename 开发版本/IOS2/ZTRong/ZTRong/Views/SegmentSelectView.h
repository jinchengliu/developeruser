//
//  SegmentSelectView.h
//  ZTRong
//
//  Created by 李婷 on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentSelectView : UIScrollView

//未选中状态图片
@property (nonatomic, strong) NSString *normalImage;
//选中状态图片
@property (nonatomic, strong) NSString *selectImage;
//字体
@property (nonatomic, strong) UIFont *font;
//字体未选中颜色
@property (nonatomic, strong) UIColor *normalColor;
//字体选中颜色
@property (nonatomic, strong) UIColor *selectColor;
//显示文字内容（数组）,如 @[@"默认",@"6个月以下",@"6-12个月",@"12个月以上"]
@property (nonatomic, strong) NSArray *titleArrs;
//可获取点击按钮的TAG
@property (nonatomic, strong) void (^didSelect)(NSInteger index);

/**
 *  初始化ScrollView
 *
 *  @param frame ScrollView大小
 *  @param arrs  按钮文本数组
 *
 *  @return 返回自定义scrollView
 */
- (id)initWithFrame:(CGRect)frame withTitleArrs:(NSArray *)arrs;
/**
 *  已初始化过的scrollView,直接在上面加segment按钮
 *
 *  @param titleArrs   按钮文本数组
 *  @param normalImage 按钮未选中状态
 *  @param selectImage 按钮选中状态
 */
- (void)addSegmentButton:(NSArray *)titleArrs withNormalImage:(NSString *)normalImage withSelectImage:(NSString *)selectImage;
@end

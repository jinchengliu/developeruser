//
//  SegmentSelectView.m
//  ZTRong
//
//  Created by 李婷 on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "SegmentSelectView.h"
#define kAppWidth [UIScreen mainScreen].bounds.size.width
@implementation SegmentSelectView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (id)initWithFrame:(CGRect)frame withTitleArrs:(NSArray *)arrs{
    self = [super initWithFrame:frame];
    if (self) {
        float kWidth = kAppWidth/arrs.count;
        for (int i = 0; i < arrs.count; i ++) {
            UIButton *segment = [[UIButton alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, self.frame.size.height)];
            [segment setBackgroundImage:[UIImage imageNamed:@"touzi_segment"] forState:UIControlStateNormal];
            [segment setBackgroundImage:[UIImage imageNamed:@"touzi_segment_f"] forState:UIControlStateSelected];
            [segment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [segment setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
            segment.tag = 1 + i;
            if (i == 0) {
                segment.selected = YES;
            }
            [segment setTitle:arrs[i] forState:UIControlStateNormal];
            segment.titleLabel.font = [UIFont systemFontOfSize:12];
            [segment addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:segment];
        }
    }
    return self;
}
- (void)addSegmentButton:(NSArray *)titleArrs withNormalImage:(NSString *)normalImage withSelectImage:(NSString *)selectImage{
    
    float kWidth = kAppWidth/titleArrs.count;
    
    for (int i = 0; i < titleArrs.count; i ++) {
        UIButton *segment =[[UIButton alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, self.frame.size.height)];
        [segment setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [segment setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
        [segment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [segment setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
        segment.tag = 1 + i;
        if (i == 0) {
            segment.selected = YES;
        }
        [segment setTitle:titleArrs[i] forState:UIControlStateNormal];
        segment.titleLabel.font = [UIFont systemFontOfSize:12];
        [segment addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:segment];
    }
}
- (void)setNormalImage:(NSString *)normalImage{
    for (UIButton * btn in self.subviews) {
        if (btn.tag > 0) {
            [btn setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        }
    }
}
- (void)setSelectImage:(NSString *)selectImage{
    for (UIButton * btn in self.subviews) {
        if (btn.tag > 0) {
            [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
        }
    }
}
- (void)setFont:(UIFont *)font{
    for (UIButton * btn in self.subviews) {
        if (btn.tag > 0) {
            btn.titleLabel.font = font;
        }
    }
}
- (void)setNormalColor:(UIColor *)normalColor{
    for (UIButton * btn in self.subviews) {
        if (btn.tag > 0) {
            [btn setTitleColor:normalColor forState:UIControlStateNormal];
        }
    }
}
- (void)setSelectColor:(UIColor *)selectColor{
    for (UIButton * btn in self.subviews) {
        if (btn.tag > 0) {
            [btn setTitleColor:selectColor forState:UIControlStateNormal];
        }
    }
}
- (void)setTitleArrs:(NSArray *)titleArrs{
    for (UIButton * btn in self.subviews) {
        if (btn.tag > 0) {
            [btn setTitle:titleArrs[btn.tag - 1] forState:UIControlStateNormal];
        }
    }
}
#pragma mark -
#pragma mark - UserAction
- (void)selectClick:(UIButton *)sender{
    
    //选中其中一个  其他都不选
    for (UIButton *btn in self.subviews) {
        if (btn.tag > 0) {
            if (btn.tag == sender.tag) {
                btn.selected = YES;
            }else
                btn.selected = NO;
        }
    }
    
    if (_didSelect) {
        _didSelect(sender.tag - 1);
    }
}
@end

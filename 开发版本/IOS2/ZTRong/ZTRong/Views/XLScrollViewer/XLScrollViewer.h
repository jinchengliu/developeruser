//
//  XLScrollView.h
//  XLScrollDemo
//
//  Created by  on 15/1/12.
//  Copyright (c) 2015年 ______. All rights reserved.
//
//
//

#pragma mark -使用

//CGRect frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -64);//如果没有导航栏，则去掉64
//
////对应填写两个数组
//NSArray *views =@[[View1 new],[View2 new],[View3 new],[View4 new]   //页面数组
//                  ,[View5 new],[View6 new],[View7 new]];
//NSArray *names =@[@"  首页  ",@"  红色  ",@"  橙色  ",@"  黄色  ",@"绿色",@"蓝色",@"紫色"]; //按钮名字数组
////创建使用
//self.scroll =[XLScrollViewer scrollWithFrame:frame withViews:views withButtonNames:names withThreeAnimation:111];//三中动画都选择
//
////自定义各种属性。。打开查看
//
//self.scroll.xl_topBackColor =[UIColor whiteColor];              //头部背景色
//self.scroll.xl_buttonColorNormal =[UIColor blackColor];          //按钮文字默认颜色
//self.scroll.xl_buttonColorSelected =[UIColor brownColor];        //按钮选中颜色
//self.scroll.xl_buttonFont =14;                                   //按钮字体
//self.scroll.xl_topHeight =40;                                //头部宽
//self.scroll.xl_isMoveButton = NO;                            //滚动切换时候滚动按钮动画
////self.scroll.xl_topBackImage =[UIImage imageNamed:@"10.jpg"];  //头部背景图片
////    self.scroll.xl_buttonToSlider =20;
////    self.scroll.xl_sliderHeight =40;
////self.scroll.xl_sliderColor =[UIColor orangeColor];
//// self.scroll.xl_isSliderCorner =YES;


//加入控制器视图
//[self.view addSubview:self.scroll];






#import <UIKit/UIKit.h>

@interface XLScrollViewer : UIView

#pragma mark -使用XLScrollView
/**
 *     使用XLScrollView,数组如果填nil，则为默认，choose处填写三位数字，代表选择与否，1代表选择，2代表不选择。例如：你准备选择第1种和第3种动画效果，则填写121
 */
-(instancetype)initWithFrame:(CGRect)frame withViews:(NSArray *)views withButtonNames:(NSArray *)names withThreeAnimation:(int)choose;//实例方法
+(instancetype)scrollWithFrame:(CGRect)frame withViews:(NSArray *)views withButtonNames:(NSArray *)names withThreeAnimation:(int)choose;//类方法



#pragma mark -三种动画效果,按照顺序来
/**
 *     1、滑动视图时是否展示头部控制条 移动按钮 的动画效果,默认为 NO
 */
@property (nonatomic) BOOL xl_isMoveButton;
/**
 *     2、点击未被选中的按钮时时候展示 缩放按钮 的动画效果,默认为 NO
 */
@property (nonatomic) BOOL xl_isScaleButton;
/**
 *     3、滑动视图时是否展示头部控制条 滑动滑块 的动画效果,默认为 NO
 */
@property (nonatomic) BOOL xl_isMoveSlider;

@property(nonatomic,weak)id delegate;


/**
 *     要展示在scollView中的view，一页一视图，可在new出来后直接放入数组
 *     如果为空，默认为 红、橙、黄三个背景色的view
 */
@property (nonatomic ,strong) NSArray *xl_views;
/**
 *     头部控制条按钮的名称,存放在此数组中,NSString直接赋值,默认字号下不宜超过3个汉字
 *     如果为空，默认为  @[@"田馥甄",@"章晓亮",@"哈哈哈"]
 */
@property (nonatomic ,copy) NSArray *xl_buttonNames;


#pragma mark -各种可供自定义的属性
/**
 *     头部控制条的高度,默认为50
 */
@property (nonatomic ,assign) CGFloat xl_topHeight;
/**
 *     头部控制条按钮的字号,默认为18
 */
@property (nonatomic ,assign) CGFloat xl_buttonFont;
/**
 *     头部控制条按钮在UIControlStateNormal状态下的文字颜色,默认为黑色
 */
@property (nonatomic ,strong) UIColor *xl_buttonColorNormal;
/**
 *     头部控制条按钮在UIControlStateSelected状态下的文字颜色,默认为白色
 */
@property (nonatomic ,strong) UIColor *xl_buttonColorSelected;
/**
 *     头部控制条的背景颜色,默认为浅灰色lightGrayColor
 */
@property (nonatomic ,strong) UIColor *xl_topBackColor;
/**
 *     头部控制条的背景图片,默认为无
 */
@property (nonatomic ,strong) UIImage *xl_topBackImage;
/**
 *     头部控制条里的滑块颜色,默认为蓝色
 */
@property (nonatomic ,strong) UIColor *xl_sliderColor;
/**
 *     微调滑块相对于按钮的坐标x值，默认为10
 */
@property (nonatomic ,assign) CGFloat xl_buttonToSlider;
#pragma mark 由于滑块的宽度根据按钮文字内容自适应，若要调整滑块的宽度，只需在xl_buttonNames数组中的字符串左右两边加上空格即可
/**
 *     头部控制条里的滑块的高度，默认为2
 */
@property (nonatomic ,assign) CGFloat xl_sliderHeight;
/**
 *     头部控制条滑块是否设置圆角，默认为 NO
 */
@property (nonatomic) BOOL xl_isSliderCorner;
/**
 *     设置头部控制条圆角比例，默认为5
 */
@property (nonatomic ,assign) CGFloat xl_sliderCorner;

@end


@protocol XLScrollViewerDelegate<NSObject>

@optional


//代理方法用于页面跳转
- (void)XLScrollViewerScroll:(NSInteger )index;

@end


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

//
//  InvestmentHomeViewController.h
//  ZTRong
//
//  Created by 李婷 on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestmentHomeViewController : MainViewController<UIGestureRecognizerDelegate>

- (IBAction)tapClick:(id)sender;
@property(nonatomic,strong)NSString *Selection;
@property(nonatomic)NSInteger page;
@property (nonatomic) BOOL isFromHome;
@property(nonatomic,strong)  UIView *selectView;
@property(nonatomic)BOOL hasmoreSC;
@property(nonatomic)BOOL isRefush;
@property(nonatomic)BOOL isFromWebView;
@end

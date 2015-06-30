//
//  SheetPicker.h
//  DropDown
//
//  Created by Liu Leo on 8/28/10.
//  Copyright 2010 Xiansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SheetPickerDelegate;
@interface SheetPicker : UIView 
@property (nonatomic,assign)id<SheetPickerDelegate> delegate;
@property (nonatomic,retain)UIViewController *viewController;
@property (nonatomic,retain)NSArray *listData;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)UIView *bgviews;

@property (nonatomic,assign)NSInteger selectId;
-(SheetPicker *)init;
-(void)showSheetPicker;
@property (nonatomic,copy)void(^clearBlock)(NSInteger row);
@property (nonatomic,copy)void(^doneBlock)(NSInteger row);
@end
@protocol SheetPickerDelegate
@optional
- (void)sheetPicker:(SheetPicker *)sheetPicker clickedDone:(NSInteger)row;//确定
- (void)sheetPicker:(SheetPicker *)sheetPicker clickedClear:(NSInteger)row;//取消
- (void)sheetPicker:(SheetPicker *)sheetPicker didSelectRow:(NSInteger)row;//滑动picker后
@end
/*
 SheetPicker *sp=[[SheetPicker alloc]init];
 sp.listData=[NSArray arrayWithObjects:@"5M",@"10M",@"15M",@"30M",nil];
 sp.doneBlock=^(int row){NSLog(@"done %d",row);};
 sp.clearBlock=^(int row){NSLog(@"clear %d",row);};
 sp.viewController=当前viewcontroller;
 [sp showSheetPicker];
 [sp release];
 */
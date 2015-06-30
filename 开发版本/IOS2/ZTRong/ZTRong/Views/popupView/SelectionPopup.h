//
//  SelectionPopup.h
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "IEPopupMaskView.h"

@interface SelectionPopup : IEPopupMaskView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView  *showTV;
@property(nonatomic,strong)NSArray *showDate;
@property(nonatomic,strong)ZTRFinishBlock  finishBlock;

@end

//
//  MoreViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/11.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *moreTable;
@property (nonatomic,strong) NSArray *list1Array;
@property (nonatomic,strong) NSArray *list2Array;
@property (nonatomic,strong) NSArray *list3Array;
@property (nonatomic,strong) NSArray *image1Array;
@property (nonatomic,strong) NSArray *image2Array;
@property (nonatomic,strong) NSArray *image3Array;

@property(nonatomic,copy) NSString *appstoreURL;

@end

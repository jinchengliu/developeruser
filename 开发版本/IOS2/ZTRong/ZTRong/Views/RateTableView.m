//
//  RateTableView.m
//  ZTRong
//
//  Created by 李婷 on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "RateTableView.h"

@interface RateTableView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_rateTable;
    NSArray *_rateArrs;

}
@end
@implementation RateTableView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initWithFrame:(CGRect)frame withArrs:(NSArray *)arrs{
    self.frame=frame;
    _rateTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _rateTable.layer.borderWidth = 0.5;
    _rateTable.layer.borderColor = [UIColor grayColor].CGColor;
    _rateTable.dataSource = self;
    _rateTable.delegate = self;
    _rateTable.backgroundColor = [UIColor redColor];
    
    [self addSubview:_rateTable];
    self.userInteractionEnabled=YES;
    _rateArrs = arrs;
    [_rateTable reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _rateArrs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    UIButton *button;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        button.tag=1001;
        [cell addSubview:button];
    }
    NSDictionary *tempDict = (NSDictionary *)_rateArrs[indexPath.row];
    if (_isDescendingOrder) {
        tempDict = (NSDictionary *)_rateArrs[_rateArrs.count - 1 - indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *content = [NSString stringWithFormat:@"%@月 利率%@",tempDict[@"repayPeriod"],tempDict[@"yearRateStr"]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[content rangeOfString:[NSString stringWithFormat:@"利率%@",tempDict[@"yearRateStr"]]]];
    
    
    button=(UIButton *)[cell viewWithTag:1001];
    
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_didSelect) {
            [self removeFromSuperview];
            _didSelect(cell.textLabel.text);
        }
    
    }];
    
    cell.textLabel.attributedText = str;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_didSelect) {
        [self removeFromSuperview];
        _didSelect(cell.textLabel.text);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (BOOL)becomeFirstResponder{
    return YES;
}
@end

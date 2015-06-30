//
//  SheetPicker.m
//  DropDown
//
//  Created by Liu Leo on 8/28/10.
//  Copyright 2010 Xiansoft. All rights reserved.
//

#import "SheetPicker.h"
@interface SheetPicker()<UIPickerViewDelegate,UIPickerViewDataSource>
{
	UIPickerView *_pickerView;
    UIToolbar *_tool;
	NSArray *_listData;
    NSInteger _selectId;    
    UIViewController *viewController;
}
- (void)clearEvent;
- (void)done;
-(void)showPickerBG;
-(void)viewControllerLock;
-(void)viewControllerUnlock;
@end

@implementation SheetPicker
@synthesize delegate = _delegate;
@synthesize listData = _listData;
@synthesize viewController;
@synthesize selectId=_selectId;
@synthesize doneBlock,clearBlock;
-(SheetPicker *)init
{
	if(self = [super initWithFrame:CGRectMake(0.0, 175.0+49+kAppHeight-480, kAppWidth, kAppHeight)])
    {
        [self setAlpha:0.9];
        [self setBackgroundColor:[UIColor whiteColor]];
        _selectId = 0;
    }
	return self;
}
-(void)showSheetPicker
{
    [self viewControllerLock];
    if(_pickerView != nil)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        CGRect rect = [self frame];
        rect.origin.y = 175;
        [self setFrame:rect];
        [UIView commitAnimations];
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:_selectId inComponent:0 animated:NO];
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
        dispatch_async(q, ^{ 
            [NSThread sleepForTimeInterval:0.40f];
            UIView *bg=[self viewWithTag:10000];
            [bg performSelectorOnMainThread:@selector(setHidden:)
                                                       withObject:nil
                                                    waitUntilDone:NO];
        });
        return;
    }
    [self showPickerBG];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,kAppWidth, 216)];
    _tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kAppWidth, 40)];
	_pickerView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	_pickerView.showsSelectionIndicator = YES;
	_pickerView.delegate=self;
	_pickerView.dataSource=self;
    _pickerView.backgroundColor=[UIColor whiteColor];
	[_pickerView selectRow:_selectId inComponent:0 animated:NO];
	
	UIBarButtonItem*clear=[[UIBarButtonItem alloc]initWithTitle:@"  取 消 " style:UIBarButtonItemStyleBordered target:nil action:@selector(clearEvent)];
	UIBarButtonItem *donespace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    lable.text=self.title;
    lable.font=[UIFont systemFontOfSize:14];
    //kMiddleSizeFont;
    //lable.textColor=[UIColor whiteColor];
    lable.backgroundColor=[UIColor clearColor];
    lable.textAlignment=NSTextAlignmentCenter;
    UIBarButtonItem *titleb=[[UIBarButtonItem alloc] initWithCustomView:lable];

	UIBarButtonItem*doneButton=[[UIBarButtonItem alloc]initWithTitle:@"  确 定 " style:UIBarButtonItemStyleBordered target:nil action:@selector(done)];
	NSArray *array=[[NSArray alloc]initWithObjects:clear,donespace,titleb,donespace,doneButton,nil];
	[_tool setItems:array animated:YES];
	_tool.tintColor=[UIColor blackColor];
	[self addSubview:_pickerView];
	[self addSubview:_tool];
    self.bgviews=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    [APPDELEGATE.window addSubview: self.bgviews];
    [APPDELEGATE.window addSubview:self];

//	[doneButton release];
//	[donespace release];
//    [ lable release];
//    [clear release];
//	[array release];
}

#pragma mark - viewController lock
-(void)showPickerBG
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0-self.frame.origin.y, kAppWidth, kAppHeight*2)];
    bgView.backgroundColor=[UIColor blackColor];
    bgView.alpha=.3;
    bgView.tag=10000;
    [self addSubview: bgView];
   // [bgView release];
}
-(void)viewControllerLock
{
    if(_delegate)
        viewController=(UIViewController *)_delegate;
    else
        if(!viewController)
            return;

}
-(void)viewControllerUnlock
{
    if(_delegate)
        viewController=(UIViewController *)_delegate;
    else
        if(!viewController)
            return;
    [self viewWithTag:10000].hidden=YES;
}

#pragma mark - buttonEvent
-(void)hideView
{
    [self viewControllerUnlock];    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.7];
	
	CGRect rect = [self frame];
    
    rect.origin.y =900;
	[self setFrame:rect];
	[UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tool removeFromSuperview];
        [self removeFromSuperview];
    });
}
- (void)clearEvent
{
    [self.bgviews removeFromSuperview];
    [self hideView];
    if(_delegate)
        [_delegate sheetPicker:self clickedClear:_selectId];
    if(clearBlock)
        clearBlock(_selectId);
}

- (void)done
{
    [self.bgviews removeFromSuperview];
    [self hideView];
    if(_delegate)
        [_delegate sheetPicker:self clickedDone:_selectId];
    if(doneBlock)
        doneBlock(_selectId);
}

#pragma mark -
#pragma mark pickerview methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [_listData count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [_listData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectId = row;
    if(_delegate)
        [_delegate sheetPicker:self didSelectRow:_selectId];
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
   // [pickerView rowSizeForComponent:component].width-12
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f,kAppWidth-40 , [pickerView rowSizeForComponent:component].height)]  ;
    
    [label setText:[self.listData objectAtIndex:row]];
    
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}


- (void)dealloc {
//    [_pickerView release];
//    [_tool release];
//	[_listData release];
//    [_bgviews release];
  // [super dealloc];
}


@end

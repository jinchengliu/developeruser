//
//  HomeViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "HomeViewController.h"
#import "loginViewController.h"
#import "NewCustomViewController.h"
#import "MessageViewController.h"
#import "loginViewController.h"
#import "MyRedbagTableViewController.h"
#import "IdentityAuthenticationVC.h"
#import "investManagerViewController.h"
#import "WebActionViewController.h"
#import "MyRewardViewController.h"


@interface HomeViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>{
    
    __weak IBOutlet UIView *_banerView;
    __weak IBOutlet UILabel *_messageLbl;//我的消息个数
    __weak IBOutlet UILabel *_miaoshaTitle;
    __weak IBOutlet UIView *_miaoshaView;
    __weak IBOutlet UIScrollView *_noticeScrollView;
    __weak IBOutlet UIImageView *_miaoshaImageV;
    
    __weak IBOutlet NSLayoutConstraint *_bannerHeight;//banner的高度
    __weak IBOutlet NSLayoutConstraint *_loginBtnHeight;//登录4个按钮的高度
    __weak IBOutlet NSLayoutConstraint *_noticeViewHeight;//通知View高度
    __weak IBOutlet NSLayoutConstraint *_zhuanquBtnHeight;//3个专区的高度
    __weak IBOutlet NSLayoutConstraint *_miaoshaViewHeight;//秒杀View的高度
    __weak IBOutlet NSLayoutConstraint *_logoRadio;//电池兰的横幅宽比
    
    __weak IBOutlet NSLayoutConstraint *_titleOrignY;
    __weak IBOutlet NSLayoutConstraint *_miaoViewOrignY;
    __weak IBOutlet NSLayoutConstraint *_miaoshaViewOrignX;
    __weak IBOutlet NSLayoutConstraint *_miaoshaHeight;
    __weak IBOutlet NSLayoutConstraint *_miaoshaWidth;
    __weak IBOutlet NSLayoutConstraint *_dianWidth;
    
    NSArray *_bannerList;//banner
    NSNumber *_messageCount;//未读消息数量
    NSArray *_seckillList;//秒杀
    NSArray *_noticeList;//公告
    UIScrollView *_bannerScrollView;
    UIPageControl *_pageControl;
    NSInteger _currentPage;
    NSString *erweimaURL;
    BOOL isFirstIn;
    NSMutableArray *noticeArray;

}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //不同的尺寸改变布局
    if (DEVICE_IS_IPHONE5) {
        _bannerHeight.constant = 145;
        _loginBtnHeight.constant = 70;
        _noticeViewHeight.constant = 30;
        _zhuanquBtnHeight.constant = 120;
        _miaoshaViewHeight.constant = 103;

        _titleOrignY.constant = 21;
        _miaoViewOrignY.constant = 50;
        _miaoshaViewOrignX.constant = 17;
        _miaoshaWidth.constant = 25;
        _miaoshaHeight.constant = 45;
        _dianWidth.constant = 18;
        
    }else if (DEVICE_IS_IPHONE6){
        
        _bannerHeight.constant = 170;
        _loginBtnHeight.constant = 83;
        _noticeViewHeight.constant = 35;
        _zhuanquBtnHeight.constant = 140;
        _miaoshaViewHeight.constant = 120;

        _titleOrignY.constant = 25;
        _miaoViewOrignY.constant = 58;
        _miaoshaViewOrignX.constant = 20;
        _miaoshaWidth.constant = 28;
        _miaoshaHeight.constant = 53;
        _dianWidth.constant = 23;
        
    }else if (DEVICE_IS_IPHONE6Plus){
        
        _bannerHeight.constant = 187;
        _loginBtnHeight.constant = 92;
        _noticeViewHeight.constant = 39;
        _zhuanquBtnHeight.constant = 153;
        _miaoshaViewHeight.constant = 133;

        _titleOrignY.constant = 27;
        _miaoViewOrignY.constant = 64;
        _miaoshaViewOrignX.constant = 22;
        _miaoshaWidth.constant = 31;
        _miaoshaHeight.constant = 59;
        _dianWidth.constant = 24;
        
    }else if (DEVICE_IS_IPHONE4){
        
        _bannerHeight.constant = 110;
        _loginBtnHeight.constant = 55;
        _noticeViewHeight.constant = 25;
        _zhuanquBtnHeight.constant = 95;
        _miaoshaViewHeight.constant = 87;
    }
    
    //banner
    _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, _bannerHeight.constant)];
    _bannerScrollView.pagingEnabled = YES;
    _bannerScrollView.bounces = NO;
    _bannerScrollView.delegate = self;
    _bannerScrollView.userInteractionEnabled = YES;
    [_banerView addSubview:_bannerScrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                   (_bannerHeight.constant - 20) + (kAppWidth/_logoRadio.multiplier),
                                                                   kAppWidth,
                                                                   20)];
    _pageControl.backgroundColor = [UIColor grayColor];
    _pageControl.numberOfPages = _bannerList.count;
    _pageControl.alpha = 0.5;
    _pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
    _pageControl.hidesForSinglePage = YES;
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
            
    _messageLbl.layer.masksToBounds = YES;
    _messageLbl.layer.cornerRadius = 9;
    _messageLbl.hidden = YES;
    
    isFirstIn = YES;
    noticeArray = [NSMutableArray array];
    
    _miaoshaTitle.hidden = YES;
    
    for (UIView *subView in _miaoshaView.subviews) {
        if (subView != _miaoshaImageV) {
            subView.hidden = YES;
        }
    }
    
}

- (void)recoverTabbar
{
    self.tabBarController.view.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    //判断是否登录
    
    UIImageView *loginImage = (UIImageView *)[self.view viewWithTag:12];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if ([UserTool userIsLogin]) {
        loginImage.image = [UIImage imageNamed:@"index_bg08"];
        
        if ([[UserTool getUserName] length]) {
            dic[@"userName"] = [UserTool getUserName];
        }
        
    }else
        loginImage.image = [UIImage imageNamed:@"index_bg01"];
    
    NSMutableDictionary *param = [Tool getHttpParams:dic];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateFormt = [dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"%@",dateFormt);
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //在主线程中更新UI代码
            if(isFirstIn)
            {
                //取消之前所有的线程
                [[self class] cancelPreviousPerformRequestsWithTarget:self];
                [self showHUD];
                
                [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kHome] parameters:@{@"message":[StringHelper dictionaryToJson:param]} finishBlock:^(NSDictionary *dict) {
                    
                    if([dict[@"success"] intValue] == 1){
                        
                        [self hideHUD:@""];

                        _bannerList = dict[@"map"][@"banner_app"];
                        _noticeList = dict[@"map"][@"public_notice_app"];
                        _seckillList = dict[@"map"][@"seckill_time_app"];
                        _messageCount = dict[@"map"][@"messageCount"];
                        
                        isFirstIn = NO;
                        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"netTime"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self refreshBanner];
                        [self refreshSeckill];
                        
                        if (_seckillList.count) {
                            NSLog(@"%@",_seckillList[0][@"title"]);
                            [self showTitle:_seckillList[0][@"title"] withContent:_seckillList[0][@"content"]];
                            if(![_seckillList[0][@"picUrl"] isEqualToString:@""])
                            {
                                NSURL *url = [NSURL URLWithString:_seckillList[0][@"picUrl"]];

                                [_miaoshaImageV sd_setImageWithURL:url];
                            }
                            
                        }
                        
                        if (_noticeList.count) {
                            
                            [self refreshNotice];
                        }
                        
                        if ([_messageCount integerValue] > 0) {
                            _messageLbl.hidden = NO;
                            
                            if ([_messageCount integerValue] > 99) {
                                _messageLbl.text = @"...";
                            }else
                                _messageLbl.text = [_messageCount stringValue];
                            
                        }

                        
                    }else{
                        
                        NSString *message=dict[@"errorMsg"];
                        if(message==nil || message.length==0){
                            message=errorMessage;
                        }
                        [self hideHUD:message];

                    }
                } failure:^(NSError *NSError) {
                    
                    NSString *message= [Tool getErrorMsssage:NSError];
                    [self hideHUD:message];
                    
                }];
            }
            else
            {
                NSDate *earlyDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"netTime"];
                NSTimeInterval _fitstDate = [earlyDate timeIntervalSince1970]*1;
                
                NSTimeInterval _secondDate = [date timeIntervalSince1970]*1;
                
                if(_secondDate - _fitstDate > 600)
                {
                    
                    //取消之前所有的线程
                    [[self class] cancelPreviousPerformRequestsWithTarget:self];
                    [self showHUD];
                    
                    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kHome] parameters:@{@"message":[StringHelper dictionaryToJson:param]} finishBlock:^(NSDictionary *dict) {
                        
                        if([dict[@"success"] intValue] == 1){
                            
                            [self hideHUD:@""];

                            _bannerList = dict[@"map"][@"banner_app"];
                            _noticeList = dict[@"map"][@"public_notice_app"];
                            _seckillList = dict[@"map"][@"seckill_time_app"];
                            _messageCount = dict[@"map"][@"messageCount"];
                            
                            isFirstIn = NO;
                            [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"netTime"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [self refreshBanner];
                            [self refreshSeckill];
                            
                            if (_seckillList.count) {
                                [self showTitle:_seckillList[0][@"title"] withContent:_seckillList[0][@"content"]];
                                if(![_seckillList[0][@"picUrl"] isEqualToString:@""])
                                {
                                    NSURL *url = [NSURL URLWithString:_seckillList[0][@"picUrl"]];

                                    [_miaoshaImageV sd_setImageWithURL:url];
                                }

                                
                            }
                            
                            if (_noticeList.count) {
                                
                                [self refreshNotice];
                            }
                            if ([_messageCount integerValue] > 99) {
                                _messageLbl.text = @"...";
                            }else
                                _messageLbl.text = [_messageCount stringValue];
                            
                            
                        }else{
                            
                            NSString *message=dict[@"errorMsg"];
                            if(message==nil || message.length==0){
                                message=errorMessage;
                            }
 
                            [self hideHUD:message];

                        }
                    } failure:^(NSError *NSError) {
                        
                        NSString *message= [Tool getErrorMsssage:NSError];
                        [self hideHUD:message];
                    }];
                }
                else
                {
//                    [self refreshNotice];
                }
            }
            
        });
    });
}
//秒杀首页标题显红
- (void)showTitle:(NSString *)title withContent:(NSString *)content{
    
    NSString *contentStr = [NSString stringWithFormat:@"第%@期   %@",title,content];
    NSMutableAttributedString *showStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    [showStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[contentStr rangeOfString:title]];
    [showStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:111/255.0f green:36/255.0f blue:22/255.0f alpha:1]
                    range:[contentStr rangeOfString:[NSString stringWithFormat:@"期   %@",content]]];
    [showStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:111/255.0f green:36/255.0f blue:22/255.0f alpha:1]
                    range:[contentStr rangeOfString:@"第"]];
    [showStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:NSMakeRange(0, contentStr.length - 1)];
    _miaoshaTitle.adjustsFontSizeToFitWidth = YES;
    _miaoshaTitle.attributedText = showStr;
    
}
//banner页面更新
- (void)refreshBanner{
    
    float kWidth = kAppWidth;
    float kHeight = _bannerHeight.constant;
    
    for (UIView *subView in _bannerScrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < _bannerList.count; i ++) {
        UIImageView *banner = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i,0, kWidth, kHeight)];
        NSURL *url = [NSURL URLWithString:_bannerList[i][@"picUrl"]];

        [banner sd_setImageWithURL:url];
        banner.userInteractionEnabled = YES;
        banner.tag = i;
        [_bannerScrollView addSubview:banner];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [banner addGestureRecognizer:tapGestureRecognizer];
    }

    _bannerScrollView.contentSize = CGSizeMake(kWidth * _bannerList.count, kHeight);
    _pageControl.numberOfPages = _bannerList.count;
    
}
//公告更新
- (void)refreshNotice{
    
    [noticeArray removeAllObjects];
    _noticeScrollView.scrollEnabled = NO;
    
    float kWidth = _noticeScrollView.frame.size.width;
    float kHeight = _noticeScrollView.frame.size.height;
    
    for (UIView * subView in _noticeScrollView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]||[subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if(_noticeList.count > 0)
    {
        for (int i = 0; i < 100; i ++) {
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight * i, kWidth, kHeight)];
            lbl.text = _noticeList[i%(_noticeList.count)][@"title"];
            if([_noticeList[i%(_noticeList.count)][@"hrefUrl"] isEqualToString:@""])
            {
                [noticeArray addObject:@""];
            }
            else
            {
                [noticeArray addObject:_noticeList[i%(_noticeList.count)][@"hrefUrl"] ];
            }
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, lbl.frame.size.width, lbl.frame.size.height)];
            button.tag = 100+i;
            [button addTarget:self action:@selector(pushtoNotice:) forControlEvents:UIControlEventTouchUpInside];
            lbl.adjustsFontSizeToFitWidth = YES;
            lbl.font = [UIFont systemFontOfSize:14];
            [_noticeScrollView addSubview:lbl];
            [_noticeScrollView addSubview:button];
        }
        
        _noticeScrollView.contentSize = CGSizeMake(kWidth, kHeight * 100);
        
        _currentPage = 1;
        
        [self performSelector:@selector(noticeRolling) withObject:self afterDelay:5];
    }
    
    
}

- (void)pushtoNotice:(UIButton *)btn
{
    NSString *UrlStr = noticeArray[btn.tag-100];
    if(![UrlStr isEqualToString:@""])
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        WebViewController *web = [storyBoard instantiateViewControllerWithIdentifier:@"web"];
        web.url = noticeArray[btn.tag-100];
        web.title = @"详情";
        web.isFromHome = YES;
        UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:web];
        
        nc.navigationBar.barStyle = UIStatusBarStyleDefault;
        [nc.navigationBar setTintColor:[UIColor whiteColor]];
        [self presentViewController:nc animated:YES completion:nil];
    }
}
//公告滚动
- (void)noticeRolling{
    
    _currentPage ++;
    if (_currentPage > 100) {
        _currentPage = 1;
    }
    CGSize viewSize = _noticeScrollView.frame.size;
    CGRect rect = CGRectMake(0, (_currentPage - 1) * viewSize.height, viewSize.width, viewSize.height);
    [_noticeScrollView scrollRectToVisible:rect animated:YES];
    
    [self performSelector:@selector(noticeRolling) withObject:self afterDelay:5];

}
/**
 *  更新秒杀时间
 */
- (void)refreshSeckill{
    if (_seckillList.count && [_seckillList[0][@"title"] length]) {
        
        
        NSString *createDateStr = _seckillList[0][@"createDateStr"];
//createDateStr = @"2015-6-12 23:12:10";
        NSDate *date = [[NSDateFormatter defaultDateFormatter] dateFromString:createDateStr];
       // NSLog(createDateStr);
      //  NSLog([date])
        if ([date isLaterThanDate:[NSDate date]]) {
            
            
            _miaoshaTitle.hidden = NO;
            
            for (UIView *subView in _miaoshaView.subviews) {
                if (subView != _miaoshaImageV) {
                    subView.hidden = NO;
                }
            }
            
            //时间正确
            NSString *hours = [NSString stringWithFormat:@"%ld",(long)[date hoursAfterDate:[NSDate date]]];
            NSString *minutes = [NSString stringWithFormat:@"%zi",[date minutesAfterDate:[NSDate date]] - [hours intValue] * 60];
            NSString *seconds = [NSString stringWithFormat:@"%zi",[date secondsAfterDate:[NSDate date]] - [date minutesAfterDate:[NSDate date]] * 60];
            
            UIView *subView1 = (UIView *)[_miaoshaView viewWithTag:7];
            UIView *subView2 = (UIView *)[_miaoshaView viewWithTag:2];
            UIView *subView3 = (UIView *)[_miaoshaView viewWithTag:3];
            UIView *subView4 = (UIView *)[_miaoshaView viewWithTag:4];
            UIView *subView5 = (UIView *)[_miaoshaView viewWithTag:5];
            UIView *subView6 = (UIView *)[_miaoshaView viewWithTag:6];

            //小时超过3位数不处理
            if (hours.length == 2){
                [(UILabel *)[subView1 viewWithTag:1] setText:[hours substringToIndex:1]];
            }else
                [(UILabel *)[subView1 viewWithTag:1] setText:@"0"];

            [(UILabel *)[subView2 viewWithTag:1] setText:[hours substringFromIndex:hours.length - 1]];

            if (minutes.length == 2) {
                [(UILabel *)[subView3 viewWithTag:1] setText:[minutes substringToIndex:1]];
            }else
                [(UILabel *)[subView3 viewWithTag:1] setText:@"0"];

            [(UILabel *)[subView4 viewWithTag:1] setText:[minutes substringFromIndex:minutes.length - 1]];

            if (seconds.length == 2) {
                [(UILabel *)[subView5 viewWithTag:1] setText:[seconds substringToIndex:1]];
            }else
                [(UILabel *)[subView5 viewWithTag:1] setText:@"0"];

            [(UILabel *)[subView6 viewWithTag:1] setText:[seconds substringFromIndex:seconds.length - 1]];

            [self performSelector:@selector(refreshSeckill) withObject:self afterDelay:0.1];

        }else{
            
//            _miaoshaTitle.hidden = YES;
//            
//            for (UIView *subView in _miaoshaView.subviews) {
//                if (subView != _miaoshaImageV) {
//                    subView.hidden = YES;
//                }
//            }
        }
        

    }else{
        
        //当没有列表的时候  内容清空
        _miaoshaTitle.hidden = YES;
        
        for (UIView *subView in _miaoshaView.subviews) {
            if (subView != _miaoshaImageV) {
                subView.hidden = YES;
            }
        }
    }

}

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    _pageControl.currentPage = current;
    
}
#pragma mark - UserAction
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];
    
    switch (sender.view.tag - 10) {
        case 1:{
            //先判断是否登录,不登陆不显示
            if ([UserTool userIsLogin]) {
                //跳转我的消息
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                MessageViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"MessageViewController"];
                view.isFromHome = YES;
                view.type = kpresent;
                UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:view];
                
                nc.navigationBar.barStyle = UIStatusBarStyleDefault;
                [nc.navigationBar setTintColor:[UIColor whiteColor]];
                [self presentViewController:nc animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你还没有登录，请问是否需要登录？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
            }

        }
            break;
        case 2:
        {//登录
            if (![UserTool userIsLogin]) {
                //跳转登录界面
                
                loginViewController *lcv=[[loginViewController alloc] init];
                UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:lcv];
                
                nc.navigationBar.barStyle = UIStatusBarStyleDefault;
                [nc.navigationBar setTintColor:[UIColor whiteColor]];
                
                [self presentViewController:nc animated:YES completion:nil];
            }else{
                
                //充值
                [Tool pushToRecharge:self];
            }
        }
            break;
        case 4:{

            if (![UserTool userIsLogin]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你还没有登录，请问是否需要登录？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
            }else{
                MyRedbagTableViewController *redBagVC = [self.storyboard instantiateViewControllerWithIdentifier:@"redbag"];
                redBagVC.title = @"我的红包";
                redBagVC.isFromHome = YES;
                
                UINavigationController *redNav = [[UINavigationController alloc] initWithRootViewController:redBagVC];
                [self presentViewController:redNav animated:YES completion:nil];
            }
            
        }
            break;
        case 5:
        {

                    SharePopup *popup=[[SharePopup  alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
                    popup.sharecontent=@"中投融分享测试";
                    popup.shareImage=[UIImage imageNamed:@"banner_01@2x.jpg"]; //图片2选1
            
                    popup.shareURL= @"https://www.baidu.com";
                    popup.rootViewController = self;
            
                    [popup showInView:self.tabBarController.view MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
                        
                        
                    }];
                    
        }
            break;
        case 6:
        {
            NewCustomViewController *newCustom = [[NewCustomViewController alloc] init];
            UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:newCustom];
            
            nc.navigationBar.barStyle = UIStatusBarStyleDefault;
            [nc.navigationBar setTintColor:[UIColor whiteColor]];
            [self presentViewController:nc animated:YES completion:nil];
        }
            break;
        case 7:
            self.tabBarController.selectedIndex = 0;
            break;
        case 8:
            self.tabBarController.selectedIndex = 1;
            break;
        case 3:{
            //我的奖励
            if ([UserTool userIsLogin]) {
                
                MyRewardViewController *myRewardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRewardViewController"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myRewardViewController];
                myRewardViewController.title = @"我的奖励明细";
                [self presentViewController:nav animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你还没有登录，请问是否需要登录？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
            }
        }
            break;

            
        default:
            break;
    }
}
//更多跳转网站公告
- (IBAction)moreClick:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];

    WebActionViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"WebActionViewController"];
    view.hidesBottomBarWhenPushed = YES;
    view.isFromHome = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}
//图片切换
- (void)pageTurn:(UIPageControl *)pageControl
{
    CGSize viewSize = _bannerScrollView.frame.size;
    CGRect rect = CGRectMake(pageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_bannerScrollView scrollRectToVisible:rect animated:YES];
}

//banner跳转详情

- (IBAction)imageClick:(UITapGestureRecognizer *)sender {
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webVC = [sb instantiateViewControllerWithIdentifier:@"web"];
    
    if (sender.view.tag == 9) {
        
        //当Picurl有内容的时候，才能进入详情
        if ([_seckillList[0][@"picUrl"] length]>0) {
            if(![_seckillList[0][@"title"] isEqualToString:@""])
            {
                NSString *contentStr = [NSString stringWithFormat:@"第%@期   %@",_seckillList[0][@"title"],_seckillList[0][@"content"]];
                webVC.title = contentStr;
                webVC.isFromMiaosha = YES;
                
                webVC.isFromHome = YES;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
                
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
        }else{
            
            if ([_bannerList[sender.view.tag][@"picUrl"] length]) {
                
                webVC.title = _bannerList[sender.view.tag][@"title"];
                webVC.url = _bannerList[sender.view.tag][@"hrefUrl"];
                
                webVC.isFromHome = YES;
                webVC.isFromBanner = YES;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
                
                [self presentViewController:nav animated:YES completion:nil];
            }

    }

    
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag != 1000)
    {
        if (buttonIndex == 0) {
            //跳转登录界面
            loginViewController *lcv=[[loginViewController alloc] init];
            UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:lcv];
            
            nc.navigationBar.barStyle = UIStatusBarStyleDefault;
            [nc.navigationBar setTintColor:[UIColor whiteColor]];
            
            [self presentViewController:nc animated:YES completion:nil];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

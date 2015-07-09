//
//  CNScrollView.m
//  CNScrollView-Demo
//
//  Created by mac on 15-3-19.
//  Copyright (c) 2015年 Baby_V5. All rights reserved.
//

#import "CNScrollView.h"
#import "UIView+UIViewController.h"
#define kBaseTAG 500
#define kFlipViewTag 600

/**
   版权所有，翻版也不能把你咋滴
 */


/**
 目的：
    类似海报浏览
 */


/**
 1.分析框架
 
    UIView->UIScrollView->ItemView
 
 2.布局
 
    各种View的frame
 
 3.动画分析
 
    item的动画实现（难点）
 
 */
@implementation CNScrollView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        _itemsCount = 6;//默认有6个item
        
        [self setScrollWithFrame:frame];
        
    }
    
    return self;
}

//创建视图
-(void)setScrollWithFrame:(CGRect)frame{

    _scrollView = [[UIScrollView alloc]initWithFrame:frame];
    
    _scrollView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.8];
    
    _scrollView.userInteractionEnabled = YES;

    _scrollView.contentSize = CGSizeMake(self.frame.size.width*_itemsCount, self.frame.size.height);
    
    _scrollView.delegate = self;//设置代理
    
    _scrollView.pagingEnabled = YES;//分页效果
    
    _scrollView.bounces = YES;//反弹效果
    
    _scrollView.showsHorizontalScrollIndicator = NO;//水平滚动条
    
    [self addSubview:_scrollView];

}

//图片数组
-(void)setDataList:(NSArray *)dataList{

    _dataList = dataList;
    
    _itemsCount = dataList.count;
    
    [self creatItemView];//创建itemView


}

//创建itemView
-(void)creatItemView{
    
    if (_itemsCount == 0) {
        
        return;
    }
    
    for ( int i = 0; i < _itemsCount; i++ ) {
        
        
        ItemsView*item = [[ItemsView alloc]initWithFrame:CGRectMake(20+i*kScrollW, 60, kScrollW-40, kScrollH-100)];
        
        item.userInteractionEnabled = YES;
        
        item.index = i;
        
        item.tag = kBaseTAG+item.index;
        
        item.cnViewController = [[CNViewController alloc]init];
        
        item.cnViewController.title = [NSString stringWithFormat:@"第%ld个界面",item.index+1];
        
        item.bgImageView.image = [UIImage imageNamed:[_dataList objectAtIndex:i]];
        
        item.cnViewController.dataList = _dataList;
        
        [_scrollView addSubview:item];
    }
    
    //初始化pageControl
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenH-20, kScreenW, 20)];
    
    pageControl.numberOfPages = _itemsCount;
    
    pageControl.currentPage = 0;
    
    [pageControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    [_scrollView addSubview:pageControl];
    
    
}

-(void)valueChange:(UIPageControl*)page{

    [UIView animateWithDuration:.35 animations:^{
    
        _scrollView.contentOffset = CGPointMake(page.currentPage*kScreenW, 0);
        
    }];
}

#pragma mark - UIScrollViewDelegate
/**
 *  滑动时对itemView做动画
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenW;
    
    pageControl.currentPage = index;
    
    pageControl.frame = CGRectMake(scrollView.contentOffset.x, kScreenH-20, kScreenW, 20);
    
    if (index < _itemsCount) {
        
        ItemsView*item = (ItemsView*)[self viewWithTag:index+kBaseTAG];//根据tag取出对应的视图
        
        item.transform = CATransform3DGetAffineTransform([self transformFromView:item isShow:YES]);
        
        ItemsView*itemView = (ItemsView*)[self viewWithTag:index+kBaseTAG+1];
            
        itemView.transform = CATransform3DGetAffineTransform([self transformFromView:itemView isShow:NO]);
    }
    
}


#pragma mark - transform

//根据View获得横向偏移
- (CGFloat)baseOffsetForView:(ItemsView *)view
{
    CGFloat offsetX =  view.index*kScreenW;
    
    return offsetX;
}

//根据偏移算角度
- (CGFloat)angleForView:(ItemsView *)view
{

    CGFloat baseOffsetX = [self baseOffsetForView:view];//固定的偏移

    
    CGFloat currentOffsetX = _scrollView.contentOffset.x;//根据滑动改变的偏移
    
    
    CGFloat angle = (currentOffsetX - baseOffsetX)/(kScreenW-50);//根据比例计算角度
    
    
    return angle;
}

//返回3D形变
-(CATransform3D)transformFromView:(ItemsView *)view isShow:(BOOL)isShow{

    CGFloat angle = [self angleForView:view];//角度
    
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m34  = 1.0/view.frame.size.width;//对立体感很重要

    //    transform.m34 = .008;
    
    if (isShow)
    {
        transform = CATransform3DRotate(transform,angle, 1, 1, 0);
    }
    else
    {
        transform = CATransform3DRotate(transform,angle, -1, 1, 0);
    }
    
    return transform;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"=====TouchScroll====");

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"move");
    
    
}


@end

/**
 *  itemsView
 */
@implementation ItemsView


-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setSubViews];
    }
    return self;
}

-(void)setSubViews{
    
    self.userInteractionEnabled = YES;
    
    self.layer.cornerRadius = 20;//圆角
    
    self.layer.masksToBounds = NO;//覆盖边界

//    self.layer.shadowOpacity = .5;//阴影效果不透明度
    
    self.layer.shadowOffset = CGSizeMake(0, 3);
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];

    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, self.bounds.size.width-40, self.bounds.size.height-110)];
    
    _bgImageView.backgroundColor = [UIColor orangeColor];
    
    _bgImageView.userInteractionEnabled = YES;
    
    [_bgImageView addGestureRecognizer:tap];
    
    [self setMyKit];
    
    [self addSubview:_bgImageView];
    
}


-(void)setMyKit{

    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btn.frame = CGRectMake(self.frame.size.width/2-30, self.frame.size.height-64, 60, 60);
    
    _btn.layer.cornerRadius = 30;
    
    _btn.backgroundColor = [UIColor grayColor];
    
    [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btn];
    
    
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-30, 15, 60, 10)];
    
    view.layer.cornerRadius = 5;
    
    view.backgroundColor = [UIColor grayColor];
    
    [self addSubview:view];
    
    
}

#pragma mark - Action区
-(void)btnAction{

    NSLog(@"=====Click====");
    
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 2, 2);
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        UINavigationController*navi = [[UINavigationController alloc]initWithRootViewController:_cnViewController];
        
        _cnViewController.view.backgroundColor =[UIColor whiteColor];
        
        [self.viewController presentViewController:navi animated:NO completion:^{
            
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1;
        }];
        
    }];

}



-(void)tap{
    
    NSLog(@"tap.....");
    
    [self btnAction];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"=====TouchItem====");
    
}
@end


@implementation CNViewController



-(void)viewDidLoad{

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"BACK" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    
    [self setMyKit];
    
}


-(void)setMyKit{
    
    
    if (!_dataList) {
        
        _dataList = [[NSArray alloc]init];
        
        return;
    }
    
    
    for (int i = 0; i < _dataList.count; i++) {
    
        if ([self.title isEqualToString:[NSString stringWithFormat:@"第%d个界面",i+1]]) {
            
            item = [[ItemsView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64)];
            
            item.bgImageView.image = [UIImage imageNamed:[_dataList objectAtIndex:i]];
            
            item.userInteractionEnabled = NO;
            
        }
        
    }
    [self.view addSubview:item];
    
}

-(void)dismiss{

    
    [self dismissViewControllerAnimated:YES completion:^{
        

    }];


}


@end





